<?php

abstract class BaseController {
    protected function respond(array $data, int $status = 200): void {
        http_response_code($status);
        echo json_encode($data);
    }
}
