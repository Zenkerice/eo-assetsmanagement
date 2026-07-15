<?php
/**
 * EmailService — sends SMTP emails via PHP's built-in mail() with custom headers,
 * or via a raw SMTP socket connection (no external library needed).
 *
 * Uses Gmail SMTP with the app-password credentials stored in config.php.
 */
class EmailService {

    private const SMTP_HOST = 'smtp.gmail.com';
    private const SMTP_PORT = 587; // TLS / STARTTLS

    private string $fromEmail;
    private string $fromName;
    private string $smtpPassword;

    public function __construct() {
        $this->fromEmail    = MAIL_FROM_EMAIL;
        $this->fromName     = MAIL_FROM_NAME;
        $this->smtpPassword = MAIL_SMTP_PASSWORD;
    }

    /**
     * Send a plain-text + HTML email.
     *
     * @param string      $toEmail    Recipient email address
     * @param string      $toName     Recipient display name
     * @param string      $subject    Email subject
     * @param string      $bodyText   Plain-text fallback body
     * @param string|null $bodyHtml   Optional HTML body (falls back to $bodyText)
     * @return bool  true on success, false on failure (errors are logged, not thrown)
     */
    public function send(string $toEmail, string $toName, string $subject, string $bodyText, ?string $bodyHtml = null): bool {
        if (empty($toEmail) || !filter_var($toEmail, FILTER_VALIDATE_EMAIL)) {
            error_log("EmailService: invalid recipient email — '$toEmail'");
            return false;
        }

        $html = $bodyHtml ?? nl2br(htmlspecialchars($bodyText, ENT_QUOTES));

        try {
            return $this->sendViaSMTP($toEmail, $toName, $subject, $bodyText, $html);
        } catch (\Throwable $e) {
            error_log("EmailService::sendViaSMTP failed: " . $e->getMessage());
            return false;
        }
    }

    /**
     * Convenience: send the same email to multiple recipients.
     */
    public function sendToMany(array $recipients, string $subject, string $bodyText, ?string $bodyHtml = null): void {
        foreach ($recipients as $r) {
            $email = $r['email'] ?? '';
            $name  = $r['name']  ?? '';
            if (!empty($email)) {
                $this->send($email, $name, $subject, $bodyText, $bodyHtml);
            }
        }
    }

    // ── Private SMTP implementation ───────────────────────────────────────────

    private function sendViaSMTP(string $toEmail, string $toName, string $subject, string $bodyText, string $bodyHtml): bool {
        $socket = @fsockopen(self::SMTP_HOST, self::SMTP_PORT, $errno, $errstr, 15);
        if (!$socket) {
            throw new \RuntimeException("Cannot connect to SMTP: $errstr ($errno)");
        }

        $boundary = '----=_Part_' . md5(uniqid('', true));

        try {
            $this->expect($socket, 220);
            $this->send_cmd($socket, "EHLO " . gethostname());
            $this->expect($socket, 250);
            $this->send_cmd($socket, "STARTTLS");
            $this->expect($socket, 220);

            if (!stream_socket_enable_crypto($socket, true, STREAM_CRYPTO_METHOD_TLS_CLIENT)) {
                throw new \RuntimeException("TLS handshake failed");
            }

            $this->send_cmd($socket, "EHLO " . gethostname());
            $this->expect($socket, 250);
            $this->send_cmd($socket, "AUTH LOGIN");
            $this->expect($socket, 334);
            $this->send_cmd($socket, base64_encode($this->fromEmail));
            $this->expect($socket, 334);
            $this->send_cmd($socket, base64_encode($this->smtpPassword));
            $this->expect($socket, 235);

            $this->send_cmd($socket, "MAIL FROM:<{$this->fromEmail}>");
            $this->expect($socket, 250);
            $this->send_cmd($socket, "RCPT TO:<{$toEmail}>");
            $this->expect($socket, 250);
            $this->send_cmd($socket, "DATA");
            $this->expect($socket, 354);

            $safeSubject = '=?UTF-8?B?' . base64_encode($subject) . '?=';
            $fromFormatted = $this->encodeHeader($this->fromName) . " <{$this->fromEmail}>";
            $toFormatted   = $this->encodeHeader($toName)         . " <{$toEmail}>";

            $headers  = "From: $fromFormatted\r\n";
            $headers .= "To: $toFormatted\r\n";
            $headers .= "Subject: $safeSubject\r\n";
            $headers .= "MIME-Version: 1.0\r\n";
            $headers .= "Content-Type: multipart/alternative; boundary=\"$boundary\"\r\n";
            $headers .= "X-Mailer: InventorySystem/1.0\r\n";
            $headers .= "\r\n";

            $plainPart  = "--$boundary\r\n";
            $plainPart .= "Content-Type: text/plain; charset=UTF-8\r\n";
            $plainPart .= "Content-Transfer-Encoding: quoted-printable\r\n\r\n";
            $plainPart .= $this->quotedPrintableEncode($bodyText) . "\r\n";

            $htmlPart  = "--$boundary\r\n";
            $htmlPart .= "Content-Type: text/html; charset=UTF-8\r\n";
            $htmlPart .= "Content-Transfer-Encoding: quoted-printable\r\n\r\n";
            $htmlPart .= $this->quotedPrintableEncode($this->buildHtmlEmail($subject, $bodyHtml)) . "\r\n";

            $closePart = "--{$boundary}--\r\n";

            $message = $headers . $plainPart . $htmlPart . $closePart . "\r\n.\r\n";
            fwrite($socket, $message);
            $this->expect($socket, 250);

            $this->send_cmd($socket, "QUIT");
        } finally {
            fclose($socket);
        }

        return true;
    }

    private function send_cmd($socket, string $cmd): void {
        fwrite($socket, $cmd . "\r\n");
    }

    private function expect($socket, int $expectedCode): string {
        $response = '';
        while ($line = fgets($socket, 512)) {
            $response .= $line;
            // Continue reading multi-line responses (e.g. "250-...")
            if (strlen($line) >= 4 && $line[3] === ' ') break;
        }
        $code = (int) substr($response, 0, 3);
        if ($code !== $expectedCode) {
            throw new \RuntimeException("SMTP expected $expectedCode, got $code: $response");
        }
        return $response;
    }

    private function encodeHeader(string $text): string {
        if (preg_match('/[^\x20-\x7E]/', $text) || strpbrk($text, '"<>@,;')) {
            return '=?UTF-8?B?' . base64_encode($text) . '?=';
        }
        return $text;
    }

    private function quotedPrintableEncode(string $text): string {
        // PHP's built-in function, available since 5.3
        if (function_exists('quoted_printable_encode')) {
            return quoted_printable_encode($text);
        }
        return $text;
    }

    /**
     * Wraps email body in a clean HTML template styled to match the app's dark theme.
     */
    private function buildHtmlEmail(string $subject, string $body): string {
        $appName = defined('APP_NAME') ? APP_NAME : 'Inventory System';
        return <<<HTML
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>{$subject}</title>
</head>
<body style="margin:0;padding:0;background:#0d1117;font-family:Arial,Helvetica,sans-serif;">
  <table width="100%" cellpadding="0" cellspacing="0" style="background:#0d1117;padding:32px 0;">
    <tr><td align="center">
      <table width="600" cellpadding="0" cellspacing="0" style="background:#161b22;border:1px solid #30363d;border-radius:12px;overflow:hidden;max-width:600px;">
        <!-- Header -->
        <tr>
          <td style="background:#1c2333;padding:24px 32px;border-bottom:1px solid #30363d;">
            <p style="margin:0;font-size:20px;font-weight:700;color:#e6edf3;">{$appName}</p>
          </td>
        </tr>
        <!-- Body -->
        <tr>
          <td style="padding:32px;color:#c9d1d9;font-size:15px;line-height:1.7;">
            {$body}
          </td>
        </tr>
        <!-- Footer -->
        <tr>
          <td style="padding:16px 32px;border-top:1px solid #30363d;background:#0d1117;">
            <p style="margin:0;font-size:12px;color:#6e7681;">
              This is an automated notification from {$appName}. Please do not reply to this email.
            </p>
          </td>
        </tr>
      </table>
    </td></tr>
  </table>
</body>
</html>
HTML;
    }
}
