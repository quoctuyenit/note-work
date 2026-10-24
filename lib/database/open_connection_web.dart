// lib/database/open_connection_web.dart
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart'; // cần cho WasmDatabase.open

LazyDatabase openConnection() {
  return LazyDatabase(() async {
    // Các file sqlite3.wasm và drift_worker.dart.js phải nằm trong folder `web/`
    // (accessible relative path từ root web). Ví dụ: web/sqlite3.wasm, web/drift_worker.dart.js
    final result = await WasmDatabase.open(
      databaseName: 'note_work_app_db', // tên db
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // Debug: Drift đã chọn backend nào, có thể in ra để kiểm tra
      print('Drift web: chosen=${result.chosenImplementation}, missing=${result.missingFeatures}');
    }

    // resolvedExecutor là QueryExecutor tương thích với Drift
    return result.resolvedExecutor;
  });
}
