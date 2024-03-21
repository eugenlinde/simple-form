<?php

use App\Http\Controllers\FormController;
use Illuminate\Support\Facades\Route;

Route::get('/', [FormController::class, 'index']);
Route::get('/forms/{uuid}', [FormController::class, 'getForm']);
Route::post('/save', [FormController::class, 'save'])->name('saveForm');
Route::post('/forms/update/{uuid}', [FormController::class, 'update'])->name('updateForm');
