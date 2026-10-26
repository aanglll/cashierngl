<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('product_logs', function (Blueprint $table) {
            $table->integer('id')->autoIncrement();
            $table->integer('product_id')->nullable();
            $table->integer('category_id')->nullable();
            $table->string('product_name', 255)->nullable();
            $table->timestamp('deleted_at')->useCurrent();

            $table->unique(['product_id', 'category_id'], 'product_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('product_logs');
    }
};
