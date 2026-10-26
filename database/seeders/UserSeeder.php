<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $users = [
            [
                'id' => 1,
                'name' => 'angel',
                'email' => 'angelylv7@gmail.com',
                'password' => Hash::make('password123'),
                'user_priv' => 'superadmin',
                'address' => 'France',
                'phone' => '086534567890',
                'status' => 'active',
                'role' => 'superadmin',
            ],
            [
                'id' => 3,
                'name' => 'cashier',
                'email' => 'cashier7@gmail.com',
                'password' => Hash::make('cashier123'),
                'user_priv' => 'officer',
                'address' => 'Ukrain',
                'phone' => '088973623212',
                'status' => 'active',
                'role' => 'officer',
            ],
            [
                'id' => 4,
                'name' => 'admin',
                'email' => 'admin7@gmail.com',
                'password' => Hash::make('admin123'),
                'user_priv' => 'admin',
                'address' => 'Egypt',
                'phone' => '098654578990',
                'status' => 'active',
                'role' => 'admin',
            ],
            [
                'id' => 7,
                'name' => 'storage',
                'email' => 'storage7@gmail.com',
                'password' => Hash::make('storage123'),
                'user_priv' => 'warehouse admin',
                'address' => 'Itali',
                'phone' => '68273635611',
                'status' => 'active',
                'role' => 'warehouse admin',
            ],
        ];

        foreach ($users as $userData) {
            $role = $userData['role'];
            unset($userData['role']);

            $user = User::updateOrCreate(['id' => $userData['id']], $userData);
            $user->syncRoles([$role]);
        }
    }
}
