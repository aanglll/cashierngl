# Cashier-ngl - Laravel 11

Cashier-ngl is a web-based cashier application built with Laravel 11, PHP 8.2, and various essential packages to provide seamless management of sales, purchases, inventory, and user roles.

## Requirements
- PHP 8.2
- XAMPP
- VS Code
- Composer
- Laravel 11
- MySQL (phpMyAdmin)

## Installation Guide

### Step 1: Download the Project
1. Visit [GitHub Repository](https://github.com/aanglll/cashier-ngl4).
2. Click **Download ZIP**.
3. Extract the downloaded file to your preferred directory.

### Step 2: Configure Environment
1. Copy the `.env.example` file and rename it to `.env`.
2. Open the `.env` file and set up the database connection:
   ```env
   DB_DATABASE=kasirngll
   DB_USERNAME=root
   DB_PASSWORD=
   APP_TIMEZONE=Asia/Jakarta
   ```

### Step 3: Install Dependencies
Run the following command in the project directory:
```sh
composer install
```

### Step 4: Generate Application Key
```sh
php artisan key:generate
```

### Step 5: Set Up Database
1. Open [phpMyAdmin](http://localhost/phpmyadmin/).
2. Create a new database named `kasirngll`.
3. Click **Import** and select the `kasirngll.sql` file from the project.

### Step 6: Link Storage
```sh
php artisan storage:link
```

### Step 7: Run the Application
Start the Laravel development server:
```sh
php artisan serve
```
Access the application at `http://127.0.0.1:8000/`.

## Default User Roles & Credentials
The application has predefined user roles with the following credentials:

| Email                 | Password      | Role             |
|----------------------|--------------|-----------------|
| putratzy7@gmail.com | password123  | Super Admin     |
| slametzy7@gmail.com | slamet123    | Admin           |
| lngzty7@gmail.com   | merah101     | Officer         |
| gudang55@gmail.com  | gudang123    | Warehouse Admin |

## Features & Technologies
- **Laravel UI** for authentication
- **Spatie** for role and permission management
- **Livewire** for dynamic search functionality
- **Maatwebsite Excel** for data export to Excel
- **DOMPDF** for PDF export
- **Bootstrap** for UI styling
- **AdminKit Template** ([Demo](https://demo-basic.adminkit.io/))
- **Database Optimization:** Functions, Stored Procedures, Triggers, Joins, Commit & Rollback

## Available Menus
- Dashboard
- Sales
- Purchases
- Stock Management
- Products
- Product Categories
- Product Units
- Suppliers
- Customers
- Settings
- Users
- Role & Permissions

## License
This project is open-source and free to use for educational and commercial purposes.

---
For any issues or contributions, feel free to create a pull request or open an issue on GitHub.

