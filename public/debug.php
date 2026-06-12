<?php
// Temporary debug — visit http://localhost/inventory/api/auth/me in browser
// then check http://localhost/inventory/public/debug.php
header('Content-Type: text/plain');
echo "REQUEST_URI:  " . ($_SERVER['REQUEST_URI']  ?? 'n/a') . "\n";
echo "REDIRECT_URL: " . ($_SERVER['REDIRECT_URL'] ?? 'n/a') . "\n";
echo "SCRIPT_NAME:  " . ($_SERVER['SCRIPT_NAME']  ?? 'n/a') . "\n";
echo "PATH_INFO:    " . ($_SERVER['PATH_INFO']     ?? 'n/a') . "\n";
echo "_GET:         " . json_encode($_GET) . "\n";
