$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Assignments - Inventory System</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600&family=DM+Mono:wght@400;500&family=Syne:wght@700;800&display=swap" rel="stylesheet">
</head>
<body>
<p>placeholder2</p>
</body>
</html>
"@
[System.IO.File]::WriteAllText("public/assignments.html", `$html, [System.Text.Encoding]::UTF8)
Write-Host "done"
