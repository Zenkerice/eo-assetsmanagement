<?php

class Validator {
    /** @throws InvalidArgumentException */
    public static function required(array $data, array $keys): void {
        foreach ($keys as $key) {
            if (!array_key_exists($key, $data)) {
                throw new InvalidArgumentException("Field '$key' is required", 400);
            }
            $val = $data[$key];
            if ($val === null || $val === '') {
                throw new InvalidArgumentException("Field '$key' is required", 400);
            }
        }
    }
}
