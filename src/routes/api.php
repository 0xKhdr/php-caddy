<?php

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::get('/stress-test', function() {
    $users = User::query()->inRandomOrder()->limit(20)->get()->filter(function ($user) {
        return in_array($user->id, [1, 2, 3, 4, 5]);
    })->toArray();

    return response()->json([
        'status' => 'success',
        'data' => $users
    ]);
});
