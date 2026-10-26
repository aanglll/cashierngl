<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('products', function (Blueprint $table) {
            $table->bigIncrements('id'); // id -> bigint(20) unsigned
            $table->string('id_category', 255); // id_category -> varchar(255)
            $table->string('product_name', 255); // product_name -> varchar(255)
            $table->string('product_units')->nullable(); // product_units -> nullable karena tipe data tidak disebutkan
            $table->decimal('purchase_price', 10, 2); // purchase_price -> decimal(10,2)
            $table->decimal('before_discount', 10, 2)->nullable(); // before_discount -> decimal(10,2)
            $table->integer('discount_product')->nullable(); // discount_product -> int(20)
            $table->decimal('selling_price', 10, 2); // selling_price -> decimal(10,2)
            $table->smallInteger('stock')->default(0); // stock -> smallint(6) default 0
            $table->string('barcode', 15); // barcode -> varchar(15)
            $table->text('description')->nullable(); // description -> tipe text
            $table->timestamps(); // created_at dan updated_at
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('products');
    }
};
