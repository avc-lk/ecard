<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?= htmlspecialchars($title ?? 'ECard QR Platform', ENT_QUOTES, 'UTF-8'); ?></title>
    <link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>
    <?= $content ?? ''; ?>
    <script src="/assets/js/app.js"></script>
</body>
</html>
