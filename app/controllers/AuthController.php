<?php

declare(strict_types=1);

class AuthController
{
    public function showLogin(): void
    {
        require __DIR__ . '/../views/auth/login.php';
    }

    public function showRegister(): void
    {
        require __DIR__ . '/../views/auth/register.php';
    }
}
