<?php
$t = file_get_contents(__DIR__ . '/../public/login.html');

$i = strpos($t, 'brand-icon">') + 12;
echo "brand-icon bytes: " . bin2hex(substr($t, $i, 8)) . "\n";

// find password icon - second input-icon
$i1 = strpos($t, 'input-icon">');
$i2 = strpos($t, 'input-icon">', $i1 + 1);
echo "password icon bytes: " . bin2hex(substr($t, $i2 + 12, 8)) . "\n";

// find warning icon
$iw = strpos($t, 'font-size:36px');
echo "warning area bytes: " . bin2hex(substr($t, $iw + 30, 10)) . "\n";
