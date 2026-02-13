# Cashierngl 24/7
![Dashboard Preview](https://github.com/aanglll/cashier-ngl/raw/main/public/assets/img/dashboard.png)

## Built With
*   [Laravel 11](https://laravel.com)
*   [PHP](https://www.php.net) (specify version, e.g., 8.2+)
*   [Composer](https://getcomposer.org)
*   [MySQL](https://www.mysql.com)

## Installation

1. Clone the Repository:
   ```bash
    git clone https://github.com/aanglll/cashierngl
    cd cashierngl
   ```

2. Configure Environment: Copy the `.env.example` file, rename it to `.env`, then open the `.env` file and configure the database connection.
   ```env
   DB_DATABASE=cashierngl
   DB_USERNAME=root
   DB_PASSWORD=
   APP_TIMEZONE=Asia/Jakarta
   ```

3. Install Dependencies:
    ```sh
    composer install
    ```

4. Generate Application Key:
    ```sh
    php artisan key:generate
    ```

5. Set Up Database: Open MySQL, create a new database named `cashierngl`, then import the `cashierngl.sql` file from the project into that database.

6. Link Storage:
    ```sh
    php artisan storage:link
    ```

7. Run the Application:
    ```sh
    php artisan serve
    ```
    The app will be available at `http://127.0.0.1:8000/`.

## Default User Roles & Credentials

| Email                 | Password      | Role             |
|----------------------|--------------|-----------------|
| angelylv7@gmail.com | password123  | Super Admin     |
| admin7@gmail.com | admin123    | Admin           |
| cashier7@gmail.com   | cashier123     | Officer         |
| storage7@gmail.com  | storage123    | Warehouse Admin |

## Features & Technologies
- **Laravel UI** for authentication
- **Spatie** for role and permission management
- **Livewire** for dynamic search functionality
- **Maatwebsite Excel** for data export to Excel
- **DOMPDF** for PDF export
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
