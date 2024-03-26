<?php

namespace App\Providers;

use App\Rules\ExistsInDatabase;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        $this->app->bind(ExistsInDatabase::class, function () {
            return new ExistsInDatabase('sectors', 'id');
        });
    }
}
