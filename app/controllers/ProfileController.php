<?php

declare(strict_types=1);

class ProfileController
{
    public function showPublicProfile(string $slug): void
    {
        echo "Public profile page for: " . htmlspecialchars($slug, ENT_QUOTES, 'UTF-8');
    }
}
