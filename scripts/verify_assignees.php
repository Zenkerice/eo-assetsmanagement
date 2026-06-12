<?php
$t = file_get_contents(__DIR__ . '/../public/assignees2.html');
echo "Title: "      . substr($t, strpos($t,'<title>'), 50) . "\n";
echo "Select opt: " . substr($t, strpos($t,'Select category'), 35) . "\n";
echo "JS comment: " . substr($t, strpos($t,'Utilities'), 30) . "\n";
echo "Load Page: "  . substr($t, strpos($t,'Load Page'), 20) . "\n";
echo "Non-ASCII remaining: " . preg_match_all('/[\xC0-\xFF][\x80-\xFF]+/', $t) . "\n";
