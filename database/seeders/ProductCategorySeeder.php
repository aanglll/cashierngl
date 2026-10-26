<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\ProductCategory;

class ProductCategorySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $categories = [
            [
                'id' => 1,
                'nama' => 'Input Devices',
                'status' => 'active',
            ],
            [
                'id' => 2,
                'nama' => 'Output Devices',
                'status' => 'active',
            ],
            [
                'id' => 5,
                'nama' => 'Cooling System',
                'status' => 'active',
            ],
        ];

        foreach ($categories as $cat) {
            ProductCategory::updateOrCreate(['id' => $cat['id']], $cat);
        }
    }
}
