<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('sales_details', function (Blueprint $table) {
            $table->id();

            $table->foreignId('sales_id')
                ->constrained('sales')
                ->onUpdate('cascade')
                ->onDelete('cascade');

            $table->foreignId('product_id')
                ->constrained('products')
                ->onUpdate('cascade')
                ->onDelete('cascade');

            $table->decimal('before_discount', 10, 2)->nullable();
            $table->integer('discount_product')->nullable();
            $table->decimal('selling_price', 10, 2);
            $table->integer('qty')->length(11);
            $table->decimal('sub_total', 10, 2);

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sales_details');
    }
};
