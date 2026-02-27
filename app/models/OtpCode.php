<?php

declare(strict_types=1);

class OtpCode
{
    public int $id;
    public int $userId;
    public string $purpose;
    public string $expiresAt;
}
