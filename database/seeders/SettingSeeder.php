<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Setting;

class SettingSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Setting::updateOrCreate(
            ['id' => 1],
            [
                'site_name' => 'Cashierngl 24/7',
                'site_logo' => 'settings/3q13npzApx6ySWJIaHVxHUPz7DOX5NhCYSqr6uZq.png',
                'favicon' => 'settings/CH1SvvzCAEqMB7dEAUNICyCbYtqnrU4Ia6UZ8ecj.png',
                'site_title' => 'Cashierngl 24/7',
                'receipt_header' => '<br>We appreciate your visit! Here is your receipt for today\'s purchase. Have a great day!',
                'receipt_footer' => 'Thank you for shopping with us! We look forward to serving you again.',
            ]
        );
    }
}
