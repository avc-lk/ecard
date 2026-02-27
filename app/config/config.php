<?php

declare(strict_types=1);

return [
    'app_name' => getenv('APP_NAME') ?: 'ECard QR Platform',
    'app_env' => getenv('APP_ENV') ?: 'development',
    'app_url' => getenv('APP_URL') ?: 'http://localhost:8000',
];
