<?php

declare(strict_types=1);

function base_url(string $path = ''): string
{
    $appUrl = getenv('APP_URL') ?: 'http://localhost:8000';
    return rtrim($appUrl, '/') . '/' . ltrim($path, '/');
}
