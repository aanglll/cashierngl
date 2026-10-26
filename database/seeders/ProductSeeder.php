<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Product;

class ProductSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $products = [
            [
                'id' => 2,
                'id_category' => '1',
                'product_name' => 'HP Z3700 Wireless Mouse',
                'product_units' => '1',
                'purchase_price' => 150000.00,
                'before_discount' => 170000.00,
                'discount_product' => 0,
                'selling_price' => 170000.00,
                'stock' => 15,
                'barcode' => 'IDU-H.WM',
                'description' => 'Available in a variety of colors, suitable for both professional and casual work styles.',
            ],
            [
                'id' => 3,
                'id_category' => '5',
                'product_name' => 'Kaizer KZ800 Cooling Pad',
                'product_units' => '1',
                'purchase_price' => 440000.00,
                'before_discount' => 450000.00,
                'discount_product' => 0,
                'selling_price' => 450000.00,
                'stock' => 10,
                'barcode' => 'CSU-K.CP',
                'description' => 'Kaizer KZ800 Cooling Pad Laptop 2400RPM Turbo Fan Kipas Pendingin Laptop',
            ],
            [
                'id' => 4,
                'id_category' => '1',
                'product_name' => 'UGREEN Bluetooth Adapter Bluetooth 5.0',
                'product_units' => '2',
                'purchase_price' => 55000.00,
                'before_discount' => 60000.00,
                'discount_product' => 0,
                'selling_price' => 60000.00,
                'stock' => 20,
                'barcode' => 'IDP-U.BA-5',
                'description' => 'UGREEN Bluetooth Adapter for PC USB Bluetooth 5.0 Receiver Dongle Wireless Computer Adapter for Desktop Laptop Mouse Keyboard Printer Speaker Support',
            ],
            [
                'id' => 5,
                'id_category' => '2',
                'product_name' => 'Orico Skt3 Usb Sound Card External',
                'product_units' => '1',
                'purchase_price' => 125000.00,
                'before_discount' => 130000.00,
                'discount_product' => 0,
                'selling_price' => 130000.00,
                'stock' => 8,
                'barcode' => 'ODU-O.SC',
                'description' => '1.) Material : ABS 2.) Color : Black 3.) Surface : Textured surface 4.) Output interface : USB-A*1, 3.5mm*1(microphone amp;earphone), 3.5mm earphone*1, 3.5mm microphone*1 5.) Input interface : USB2.0 6.) Cable length : 10cm',
            ],
            [
                'id' => 6,
                'id_category' => '1',
                'product_name' => 'Ugreen 10 in 1 USB C Multi Docking',
                'product_units' => '2',
                'purchase_price' => 475000.00,
                'before_discount' => 485000.00,
                'discount_product' => 0,
                'selling_price' => 485000.00,
                'stock' => 12,
                'barcode' => 'IDP-U.MD-10',
                'description' => 'Ugreen 10 in 1 USB C Multi Docking RJ45 HDMI VGA USB 3.0 PD 3.5mm Audio CardReader',
            ],
            [
                'id' => 8,
                'id_category' => '1',
                'product_name' => 'Logitech K120 USB QWERTZ Hongaria',
                'product_units' => '1',
                'purchase_price' => 110000.00,
                'before_discount' => 115000.00,
                'discount_product' => 0,
                'selling_price' => 115000.00,
                'stock' => 18,
                'barcode' => 'IDU-L.KH',
                'description' => 'Standard Keyboard Spill-resistant USB 1 Year (Local Official Distributor Warranty)',
            ],
            [
                'id' => 9,
                'id_category' => '2',
                'product_name' => 'Dell Value Monitor 18.5inch D1918H',
                'product_units' => '4',
                'purchase_price' => 1900000.00,
                'before_discount' => 2000000.00,
                'discount_product' => 0,
                'selling_price' => 2000000.00,
                'stock' => 5,
                'barcode' => 'ODP-D.VM-18',
                'description' => '5 typical (white to black, black to white)',
            ],
        ];

        foreach ($products as $prod) {
            Product::updateOrCreate(['id' => $prod['id']], $prod);
        }
    }
}
