<?php
$path = __DIR__ . '/../public/settings.html';
$c = file_get_contents($path);

// Replace all onclick="scrollTo(...)" with onclick="navTo(this,...)"
$c = preg_replace("/onclick=\"scrollTo\('([^']+)'\)\"/", "onclick=\"navTo(this,'$1')\"", $c);

// Fix the scrollTo function definition to be navTo
$c = str_replace(
    "function scrollTo(id) {\n  const el = document.getElementById(id);\n  if (el) el.scrollIntoView({ behavior:'smooth', block:'start' });\n  document.querySelectorAll('.settings-nav a').forEach(a => a.classList.remove('active'));\n  event.currentTarget.classList.add('active');\n}",
    "function navTo(link, id) {\n  const el = document.getElementById(id);\n  if (el) el.scrollIntoView({ behavior:'smooth', block:'start' });\n  document.querySelectorAll('.settings-nav a').forEach(a => a.classList.remove('active'));\n  link.classList.add('active');\n}",
    $c
);

file_put_contents($path, $c);
echo "Done.\n";

// Verify
$t = file_get_contents($path);
$count = substr_count($t, 'scrollTo(');
echo "Remaining scrollTo( calls: $count\n";
echo "navTo calls: " . substr_count($t, 'navTo(') . "\n";
