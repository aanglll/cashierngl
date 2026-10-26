<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RoleAndPermissionSeeder extends Seeder
{
    public function run()
    {
        $productPermissions = ['create products', 'edit products', 'delete products', 'view products'];

        $productCategoryPermissions = ['create product categories', 'edit product categories', 'delete product categories', 'view product categories'];

        $productUnitPermissions = ['create product units', 'edit product units', 'delete product units', 'view product units'];

        $customerPermissions = ['create customers', 'edit customers', 'delete customers', 'view customers'];

        $supplierPermissions = ['create suppliers', 'edit suppliers', 'delete suppliers', 'view suppliers'];

        $userPermissions = ['create users', 'edit users', 'delete users', 'view users'];

        $rolePermissions = ['create role', 'edit role', 'delete role', 'view role'];

        $salePermissions = ['create sales', 'delete sales', 'view sales'];

        $purchasePermissions = ['create purchases', 'delete purchases', 'view purchases'];

        $stockPermissions = ['view stocks', 'delete stocks'];

        $dashboardPermissions = ['view dashboards'];

        $settingPermissions = ['edit settings', 'view settings'];

        foreach (array_merge($productPermissions, $productCategoryPermissions, $productUnitPermissions, $customerPermissions, $userPermissions, $rolePermissions, $supplierPermissions, $salePermissions, $purchasePermissions, $stockPermissions, $dashboardPermissions, $settingPermissions) as $permission) {
            if (!Permission::where('name', $permission)->exists()) {
                Permission::create(['name' => $permission]);
            }
        }

        $roleSuperAdmin = Role::firstOrCreate(['name' => 'superadmin']);
        $roleAdmin = Role::firstOrCreate(['name' => 'admin']);
        $roleOfficer = Role::firstOrCreate(['name' => 'officer']);
        $roleWarehouseAdmin = Role::firstOrCreate(['name' => 'warehouse admin']);

        $roleSuperAdmin->syncPermissions(array_merge($productPermissions, $productCategoryPermissions, $productUnitPermissions, $customerPermissions, $userPermissions, $rolePermissions, $supplierPermissions, $dashboardPermissions, $settingPermissions, $salePermissions, $purchasePermissions, $stockPermissions));

        $roleAdmin->syncPermissions(array_merge($productPermissions, $productCategoryPermissions, $productUnitPermissions, $customerPermissions, $userPermissions, $rolePermissions, $supplierPermissions, $dashboardPermissions, $settingPermissions, $salePermissions, $purchasePermissions, $stockPermissions));

        $officerPermissions = array_diff($customerPermissions, ['delete customers']);
        $roleOfficer->syncPermissions(array_merge($officerPermissions, ['view products'], ['create sales']));

        $productPermissionsForWarehouseAdmin = ['view products'];
        $productCategoryPermissionsForWarehouseAdmin = ['view product categories'];
        $supplierWarehouseAdminPermissions = array_diff($supplierPermissions, ['delete suppliers']);
        $roleWarehouseAdmin->syncPermissions(array_merge($productPermissionsForWarehouseAdmin, $productCategoryPermissionsForWarehouseAdmin, $supplierWarehouseAdminPermissions, ['create purchases']));
    }
}
