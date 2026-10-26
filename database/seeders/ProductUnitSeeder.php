<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\ProductUnit;

class ProductUnitSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $units = [
            [
                'id' => 1,
                'name' => 'Unit',
                'status' => 'active',
            ],
            [
                'id' => 2,
                'name' => 'PCS',
                'status' => 'active',
            ],
            [
                'id' => 4,
                'name' => 'Packet',
                'status' => 'active',
            ],
        ];

        foreach ($units as $unit) {
            ProductUnit::updateOrCreate(['id' => $unit['id']], $unit);
        }
    }
}
