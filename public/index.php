<?php

declare(strict_types=1);

$routes = require __DIR__ . '/../routes/web.php';

?><!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ECard QR Platform</title>
    <link rel="stylesheet" href="/assets/css/style.css">
</head>
<body>
    <main class="container">
        <h1>ECard QR Platform Starter</h1>
        <p>Mobile-first QR profile SaaS scaffold using PHP + SQL + HTML/CSS/JS.</p>

        <section class="card">
            <h2>Initial Deliverables</h2>
            <ul>
                <li>System file structure scaffold</li>
                <li>Database schema for multi-role SaaS</li>
                <li>Starter routes and UI shell</li>
            </ul>
        </section>

        <section class="card">
            <h2>Routes (starter)</h2>
            <pre><?= htmlspecialchars(print_r($routes, true), ENT_QUOTES, 'UTF-8'); ?></pre>
        </section>
    </main>

    <script src="/assets/js/app.js"></script>
</body>
</html>
