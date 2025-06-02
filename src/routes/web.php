<?php

use App\Models\User;
use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/test', function () {
    echo 'TEST';
});

Route::get('/stress-test', function() {
    $users = User::query()->inRandomOrder()->get()->filter(function ($user) {
        return in_array($user->id, [1, 2, 3, 4, 5]);
    })->toArray();

    return response()->json([
        'status' => 'success',
        'data' => $users
    ]);
});
