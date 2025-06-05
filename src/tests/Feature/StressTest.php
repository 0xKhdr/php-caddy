<?php

use function Pest\Stressless\stress;

it('benchmark', function () {
    $result = stress('http://php.localhost')->dump();
});
