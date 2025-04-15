<?php

declare(strict_types=1);

namespace App\Enums;

enum ContactTypeEnum: string
{
    case DELIVERY = 'delivery';
    case RECEIVER = 'receiver';

    /**
     *@return array<int, string>
     */
    public static function values(): array
    {
        return array_map(fn($case) => $case->value, self::cases());
    }
}
