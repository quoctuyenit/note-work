import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:file_saver/file_saver.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:note_work/repository/booking_repository.dart';
import 'package:note_work/database/app_database.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class BackupService {
  final BookingRepository repo;

  BackupService(this.repo);

  /// Export all data into a JSON string
  Future<String> exportToJson() async {
    final days = await repo.exportBookingDay();
    final slots = await repo.exportBookingSlot();
    final defaults = await repo.exportDefaultSlot();
    final employees = await repo.exportEmployees();
    final categories = await repo.exportSaleCategories();
    final salesDays = await repo.exportSalesDay();
    final salesRecords = await repo.exportEmployeeSale();
    final counters = {
      'default_slot_id': await repo.getCounter('default_slot_id'),
      'slot_id': await repo.getCounter('slot_id'),
      'employee_id': await repo.getCounter('employee_id'),
      'sale_category_id': await repo.getCounter('sale_category_id'),
      'sale_id': await repo.getCounter('sale_id'),
    };
    final backupData = {
      'booking_days': days.map((d) => d.toJson()).toList(),
      'booking_slots': slots.map((d) => d.toJson()).toList(),
      'default_slots': defaults.map((d) => d.toJson()).toList(),
      'employees': employees.map((e) => e.toJson()).toList(),
      'sale_categories': categories.map((c) => c.toJson()).toList(),
      'sales_days': salesDays.map((d) => d.toJson()).toList(),
      'sales_records': salesRecords.map((r) => r.toJson()).toList(),
      'counters': counters,
    };
    return jsonEncode(backupData);
  }

  /// Import from JSON and restore data
  Future<void> importFromJson(String jsonContent) async {
    final dynamic data = jsonDecode(jsonContent);
    if (data is! Map) {
      throw const FormatException('Dữ liệu JSON không đúng định dạng');
    }

    await repo.clearAll();

    // Restore booking_days
    if (data['booking_days'] != null) {
      for (var raw in data['booking_days']) {
        await repo.restoreDay(BookingDay.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    // Restore booking_slots
    if (data['booking_slots'] != null) {
      for (var raw in data['booking_slots']) {
        await repo.restoreSlot(BookingSlot.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    // Restore default_slots
    if (data['default_slots'] != null) {
      for (var raw in data['default_slots']) {
        await repo.restoreDefaultSlot(DefaultSlot.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    // Restore employees
    if (data['employees'] != null) {
      for (var raw in data['employees']) {
        await repo.restoreEmployee(Employee.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    // Restore sale_categories
    if (data['sale_categories'] != null) {
      for (var raw in data['sale_categories']) {
        await repo.restoreSaleCategory(SaleCategory.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    // Đảm bảo luôn có ít nhất loại mặc định "Nail"
    final curCats = await repo.getSaleCategories();
    if (curCats.isEmpty) {
      await repo.addSaleCategory('Nail');
    }

    // Restore sales_days
    if (data['sales_days'] != null) {
      for (var raw in data['sales_days']) {
        await repo.restoreSalesDay(SalesDay.fromJson(Map<String, dynamic>.from(raw)));
      }
    }
    // Restore sales_records
    if (data['sales_records'] != null) {
      for (var raw in data['sales_records']) {
        await repo.restoreEmployeeSale(EmployeeSale.fromJson(Map<String, dynamic>.from(raw)));
      }
    }

    // Restore counters (if any)
    if (data['counters'] != null) {
      final counters = Map<String, dynamic>.from(data['counters']);
      for (var k in counters.keys) {
        final val = counters[k];
        if (val is int) {
          await repo.restoreCounter(k, val);
        }
      }
    }
  }

  /// Public method to export and save file
  Future<void> backup(BuildContext context) async {
    try {
      final jsonString = await exportToJson();
      if (kIsWeb) {
        _downloadJsonWeb(jsonString);
      } else {
        await _saveJsonFileMobile(jsonString);
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã tạo file backup thành công!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi sao lưu dữ liệu: $e')),
        );
      }
    }
  }

  /// Backup on Web
  void _downloadJsonWeb(String jsonContent) {
    final bytes = utf8.encode(jsonContent);
    final blob = html.Blob([bytes], 'application/json');

    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute(
          "download", "booking_backup_${DateTime.now().toIso8601String()}.json")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  /// Save backup file on Mobile/Desktop
  Future<void> _saveJsonFileMobile(String jsonContent) async {
    final Uint8List bytes = Uint8List.fromList(jsonContent.codeUnits);
    await FileSaver.instance.saveFile(
      name: 'booking_backup_${DateTime.now().toIso8601String()}',
      bytes: bytes,
      ext: 'json',
      mimeType: MimeType.json,
    );
  }

  /// Let user pick a JSON file and import its content
  Future<void> restore(BuildContext context, {VoidCallback? onRestored}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return; // user canceled

      final fileBytes = result.files.single.bytes;
      if (fileBytes != null) {
        final jsonString = utf8.decode(fileBytes);
        await importFromJson(jsonString);
        onRestored?.call();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phục hồi dữ liệu thành công!')),
          );
        }
      } else {
        throw Exception('Không thể đọc dữ liệu file đã chọn.');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi phục hồi dữ liệu: $e')),
        );
      }
    }
  }
}
