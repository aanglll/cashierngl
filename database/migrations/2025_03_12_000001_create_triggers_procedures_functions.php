<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // 1. Drop if exists
        DB::unprepared("DROP TRIGGER IF EXISTS `log_product_deletion`");
        DB::unprepared("DROP PROCEDURE IF EXISTS `GetCustomerSales`");
        DB::unprepared("DROP PROCEDURE IF EXISTS `InsertStock`");
        DB::unprepared("DROP FUNCTION IF EXISTS `GetTotalProfit`");

        // 2. Trigger log_product_deletion
        DB::unprepared("
            CREATE TRIGGER `log_product_deletion` BEFORE DELETE ON `products` FOR EACH ROW BEGIN
                INSERT INTO product_logs (product_id, category_id, product_name)
                VALUES (OLD.id, OLD.id_category, OLD.product_name);
            END
        ");

        // 3. Stored Procedure GetCustomerSales
        DB::unprepared("
            CREATE PROCEDURE `GetCustomerSales` (IN `p_customer_id` INT)   BEGIN
                SELECT 
                    customer_id, 
                    COUNT(id) AS total_transactions,
                    SUM(total_price) AS total_spent
                FROM sales
                WHERE customer_id = p_customer_id
                GROUP BY customer_id;
            END
        ");

        // 4. Stored Procedure InsertStock
        DB::unprepared("
            CREATE PROCEDURE `InsertStock` (IN `p_product_id` VARCHAR(255), IN `p_stock_in` VARCHAR(255), IN `p_stock_out` VARCHAR(255), IN `p_current_stock` VARCHAR(255), IN `p_source` VARCHAR(255))   BEGIN
                DECLARE v_product_id BIGINT;
                DECLARE v_stock_in INT;
                DECLARE v_stock_out INT;
                DECLARE v_current_stock INT;

                DECLARE exit HANDLER FOR SQLEXCEPTION
                BEGIN
                    ROLLBACK;
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Transaction rolled back due to an error';
                END;

                START TRANSACTION;

                SET v_product_id = CAST(p_product_id AS UNSIGNED);
                SET v_stock_in = CAST(p_stock_in AS SIGNED);
                SET v_stock_out = CAST(p_stock_out AS SIGNED);
                SET v_current_stock = CAST(p_current_stock AS SIGNED);

                IF v_product_id IS NULL OR v_stock_in IS NULL OR v_stock_out IS NULL OR v_current_stock IS NULL
                   OR p_product_id REGEXP '[^0-9]' OR p_stock_in REGEXP '[^0-9]' 
                   OR p_stock_out REGEXP '[^0-9]' OR p_current_stock REGEXP '[^0-9]' THEN
                    ROLLBACK;
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid input: Only integer values allowed';
                END IF;

                INSERT INTO stocks (product_id, stock_in, stock_out, current_stock, source, created_at, updated_at)
                VALUES (v_product_id, v_stock_in, v_stock_out, v_current_stock, p_source, NOW(), NOW());

                COMMIT;
            END
        ");

        // 5. Function GetTotalProfit
        DB::unprepared("
            CREATE FUNCTION `GetTotalProfit` (`year_param` INT, `month_param` INT) RETURNS DECIMAL(15,2) DETERMINISTIC BEGIN
                DECLARE total_sales DECIMAL(15,2);
                DECLARE total_purchases DECIMAL(15,2);
                DECLARE profit DECIMAL(15,2);

                SELECT COALESCE(SUM(total_price), 0) 
                INTO total_sales 
                FROM sales 
                WHERE YEAR(created_at) = year_param AND MONTH(created_at) = month_param;

                SELECT COALESCE(SUM(total_price), 0) 
                INTO total_purchases 
                FROM purchases 
                WHERE YEAR(created_at) = year_param AND MONTH(created_at) = month_param;

                SET profit = total_sales - total_purchases;

                RETURN profit;
            END
        ");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::unprepared("DROP TRIGGER IF EXISTS `log_product_deletion`");
        DB::unprepared("DROP PROCEDURE IF EXISTS `GetCustomerSales`");
        DB::unprepared("DROP PROCEDURE IF EXISTS `InsertStock`");
        DB::unprepared("DROP FUNCTION IF EXISTS `GetTotalProfit`");
    }
};
