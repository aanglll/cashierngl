<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('sales', function (Blueprint $table) {
            $table->id();

            $table->foreignId('user_id')
                ->constrained('users')
                ->onUpdate('cascade')
                ->onDelete('cascade');

            $table->foreignId('customer_id')
                ->nullable()
                ->constrained('customers')
                ->onUpdate('cascade')
                ->onDelete('cascade');

            $table->decimal('discount', 10, 2)->default(0);
            $table->decimal('ppn', 10, 2)->default(0);
            $table->decimal('total_price', 10, 2);
            $table->decimal('cash_paid', 10, 2)->default(0);
            $table->decimal('cash_return', 10, 2)->default(0);

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sales');
    }
};
