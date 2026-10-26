<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Customer;

class CustomerSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $customers = [
            [
                'id' => 1,
                'name' => 'Raka Pratama',
                'address' => 'Dusun Sukamaju, RT.02, Sukamaju, Tanjungsari, Kec. Cijeruk, Kabupaten Bogor, Jawa Barat 16740',
                'phone' => '081234567801',
            ],
            [
                'id' => 2,
                'name' => 'Nadia Azzahra',
                'address' => 'Dusun Ngadirejo, RT.03, Ngadirejo, Pujon, Kec. Pujon, Kabupaten Malang, Jawa Timur 65391',
                'phone' => '081234567802',
            ],
            [
                'id' => 3,
                'name' => 'Dimas Putra',
                'address' => 'Dusun Cikaret, RT.01, Cikaret, Cisarua, Kec. Cisarua, Kabupaten Bogor, Jawa Barat 16750',
                'phone' => '081234567803',
            ],
            [
                'id' => 5,
                'name' => 'Aulia Rahma',
                'address' => 'Dusun Talang Sari, RT.04, Talang, Kemuning, Kec. Kemuning, Kabupaten Musi Rawas, Sumatera Selatan 31661',
                'phone' => '081234567805',
            ],
            [
                'id' => 6,
                'name' => 'Salsa Nabila',
                'address' => 'Dusun Karanganyar, RT.02, Karanganyar, Kedungwuni, Kec. Kedungwuni, Kabupaten Pekalongan, Jawa Tengah 51173',
                'phone' => '081234567806',
            ],
            [
                'id' => 7,
                'name' => 'Fajar Alamsyah',
                'address' => 'Dusun Sumberjo, RT.05, Sumberjo, Talun, Kec. Talun, Kabupaten Blitar, Jawa Timur 66183',
                'phone' => '081234567807',
            ],
            [
                'id' => 8,
                'name' => 'Vira Meilani',
                'address' => 'Dusun Tegalrejo, RT.03, Tegalrejo, Gunungpati, Kec. Gunungpati, Kota Semarang, Jawa Tengah 50226',
                'phone' => '081234567808',
            ],
            [
                'id' => 9,
                'name' => 'Rendi Kurniawan',
                'address' => 'Dusun Batuputih, RT.01, Batuputih, Tanjung Bumi, Kec. Tanjung Bumi, Kabupaten Bangkalan, Jawa Timur 69155',
                'phone' => '081234567809',
            ],
            [
                'id' => 10,
                'name' => 'Citra Anjani',
                'address' => 'Dusun Sidomulyo, RT.04, Sidomulyo, Natar, Kec. Natar, Kabupaten Lampung Selatan, Lampung 35362',
                'phone' => '081234567810',
            ],
            [
                'id' => 11,
                'name' => 'Arya Saputra',
                'address' => 'Dusun Sambirejo, RT.02, Sambirejo, Mantingan, Kec. Mantingan, Kabupaten Ngawi, Jawa Timur 63257',
                'phone' => '081234567811',
            ],
            [
                'id' => 12,
                'name' => 'Ilham Fauzan',
                'address' => 'Dusun Pucangan, RT.03, Pucangan, Kartasura, Kec. Kartasura, Kabupaten Sukoharjo, Jawa Tengah 57168',
                'phone' => '081234567812',
            ],
        ];

        foreach ($customers as $cust) {
            Customer::updateOrCreate(['id' => $cust['id']], $cust);
        }
    }
}
