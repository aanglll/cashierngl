<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Supplier;

class SupplierSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $suppliers = [
            [
                'id' => 1,
                'name' => 'PT. BUNGA CEKATAN',
                'address' => 'Jl. Magelang No.KM.11, Dukuh, Tridadi, Kec. Sleman, Kabupaten Sleman, Daerah Istimewa Yogyakarta 55511',
                'phone' => '62884734590872',
            ],
            [
                'id' => 2,
                'name' => 'PT. GRAHA NUGRAHA',
                'address' => 'Jl. Danau Bogor Raya No.33, RT.01/RW.07, Tanah Baru, Kec. Bogor Utara, Kota Bogor, Jawa Barat 16144',
                'phone' => '6286379786578',
            ],
            [
                'id' => 4,
                'name' => 'PT. PLASTIK',
                'address' => "Jl. Raya Serang Km. 12,5 Desa Bitung Jaya, \nKecamatan Cikupa, Tangerang",
                'phone' => '6287736282908',
            ],
        ];

        foreach ($suppliers as $sup) {
            Supplier::updateOrCreate(['id' => $sup['id']], $sup);
        }
    }
}
