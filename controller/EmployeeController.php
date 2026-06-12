<?php
require_once __DIR__ . '/BaseController.php';
require_once __DIR__ . '/../model/EmployeeModel.php';

class EmployeeController extends BaseController {
    private EmployeeModel $model;

    public function __construct() {
        $this->model = new EmployeeModel();
    }

    public function handle(string $method, ?int $id, array $body, array $query): void {
        // GET /api/employees?stations=1  — distinct station list
        if ($method === 'GET' && !$id && isset($query['stations'])) {
            $this->respond(['success' => true, 'data' => $this->model->getStations()]);
            return;
        }

        // POST /api/employees?action=import  — bulk CSV import
        if ($method === 'POST' && !$id && ($query['action'] ?? '') === 'import') {
            $this->handleImport();
            return;
        }

        match ($method) {
            'GET'    => $id ? $this->show($id)         : $this->index($query),
            'POST'   => $this->store($body),
            'PUT'    => $this->update($id, $body),
            'DELETE' => $this->destroy($id),
            default  => $this->respond(['error' => 'Method not allowed'], 405),
        };
    }

    private function index(array $query): void {
        $station = $query['station'] ?? '';
        $this->respond(['success' => true, 'data' => $this->model->findAll($station)]);
    }

    private function show(int $id): void {
        $emp = $this->model->findById($id);
        if (!$emp) { $this->respond(['error' => 'Employee not found'], 404); return; }
        $this->respond(['success' => true, 'data' => $emp]);
    }

    private function store(array $body): void {
        $name = trim($body['name'] ?? '');
        if ($name === '') { $this->respond(['error' => 'Name is required'], 400); return; }
        $id  = $this->model->create($body);
        $emp = $this->model->findById($id);
        $this->respond(['success' => true, 'data' => $emp], 201);
    }

    private function update(?int $id, array $body): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $this->model->update($id, $body);
        $this->respond(['success' => true, 'data' => $this->model->findById($id)]);
    }

    private function destroy(?int $id): void {
        if (!$id) { $this->respond(['error' => 'ID required'], 400); return; }
        $this->model->delete($id);
        $this->respond(['success' => true, 'message' => 'Employee deleted']);
    }

    /** Handle multipart CSV upload */
    private function handleImport(): void {
        if (!isset($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) {
            $this->respond(['error' => 'No valid file uploaded'], 400);
            return;
        }

        $tmpPath = $_FILES['file']['tmp_name'];
        $handle  = fopen($tmpPath, 'r');
        if (!$handle) { $this->respond(['error' => 'Cannot read uploaded file'], 500); return; }

        // Read header row, normalise column names
        $rawHeader = fgetcsv($handle);
        if (!$rawHeader) { fclose($handle); $this->respond(['error' => 'Empty CSV file'], 400); return; }

        $header = array_map(fn($h) => strtolower(trim(preg_replace('/[^a-z0-9_]/i', '_', $h))), $rawHeader);

        // Accept flexible column name aliases
        $nameCol     = $this->findCol($header, ['name', 'full_name', 'employee_name', 'employee']);
        $stationCol  = $this->findCol($header, ['station', 'department', 'section']);
        $seatCol     = $this->findCol($header, ['seat_number', 'seat', 'seat_no', 'seatno', 'seat_num']);
        $locationCol = $this->findCol($header, ['location_name', 'location', 'site', 'branch', 'office']);

        if ($nameCol === -1) {
            fclose($handle);
            $this->respond(['error' => 'CSV must have a "name" column (also accepts: full_name, employee_name)'], 400);
            return;
        }

        $rows = [];
        while (($line = fgetcsv($handle)) !== false) {
            if (count(array_filter($line, fn($c) => trim($c) !== '')) === 0) continue; // skip blank rows
            $rows[] = [
                'name'          => $nameCol     !== -1 ? ($line[$nameCol]     ?? '') : '',
                'station'       => $stationCol  !== -1 ? ($line[$stationCol]  ?? '') : '',
                'seat_number'   => $seatCol     !== -1 ? ($line[$seatCol]     ?? '') : '',
                'location_name' => $locationCol !== -1 ? ($line[$locationCol] ?? '') : '',
            ];
        }
        fclose($handle);

        if (!$rows) { $this->respond(['error' => 'No data rows found in CSV'], 400); return; }

        $result = $this->model->bulkUpsert($rows);
        $this->respond([
            'success' => true,
            'message' => "Import complete: {$result['inserted']} added, {$result['updated']} updated, {$result['skipped']} skipped.",
            'data'    => $result,
        ]);
    }

    /** Find index of first matching column name from a list of aliases */
    private function findCol(array $header, array $aliases): int {
        foreach ($aliases as $alias) {
            $idx = array_search($alias, $header, true);
            if ($idx !== false) return (int)$idx;
        }
        return -1;
    }

}
