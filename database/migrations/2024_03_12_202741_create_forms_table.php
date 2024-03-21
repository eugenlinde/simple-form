<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('forms', function (Blueprint $table) {
            $table->id();
            $table->uuid()->nullable()->unique();
            $table->string('name');
            $table->boolean('agreed');
            $table->timestamps();
        });

        DB::unprepared('
            CREATE TRIGGER forms_before_insert
            BEFORE INSERT ON forms
            FOR EACH ROW
            BEGIN
                IF NEW.uuid IS NULL THEN
                    SET NEW.uuid = UUID();
                END IF;
            END;
        ');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('forms');
    }
};
