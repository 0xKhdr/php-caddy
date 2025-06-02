<?php

use function Pest\Stressless\stress;

it('benchmark', function () {
    $result = stress('http://php.caddy.localhost:80')->dump();
});
