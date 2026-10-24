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
    final counters = {
      'default_slot_id': await repo.getCounter('default_slot_id'),
      'slot_id': await repo.getCounter('slot_id'),
    };
    final backupData = {
      'booking_days': days.map((d) => d.toJson()).toList(),
      'booking_slots': slots.map((d) => d.toJson()).toList(),
      'default_slots': defaults.map((d) => d.toJson()).toList(),
      'counters': counters,
    };
    return jsonEncode(backupData);
  }

  /// Import from JSON and restore data
  Future<void> importFromJson(String jsonContent) async {
    final data = jsonDecode(jsonContent);
    await repo.clearAll();

    // Restore booking_days
    for (var raw in data['booking_days']) {
      await repo.restoreDay(BookingDay.fromJson(raw));
    }
    // Restore booking_slots
    for (var raw in data['booking_slots']) {
      await repo.restoreSlot(BookingSlot.fromJson(raw));
    }
    // Restore default_slots
    for (var raw in data['default_slots']) {
      await repo.restoreDefaultSlot(DefaultSlot.fromJson(raw));
    }

    // Restore counters (if any)
    if (data['counters'] != null) {
      final counters = Map<String, int>.from(data['counters']);
      for (var k in counters.keys) {
        await repo.restoreCounter(k, counters[k]!);
      }
    }
  }

  /// Public method to export and save file
  Future<void> backup(BuildContext context) async {
    final jsonString = await exportToJson();
    if (kIsWeb) {
      _downloadJsonWeb(jsonString);
    } else {
      await _saveJsonFileMobile(jsonString);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã tạo file backup thành công!')),
    );
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
  Future<void> restore(BuildContext context) async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
    if (result == null) return; // user canceled
    final fileBytes = result.files.single.bytes;
    if (fileBytes != null) {
      final jsonString = utf8.decode(fileBytes);
      await importFromJson(jsonString);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phục hồi dữ liệu thành công!')),
      );
    }
  }
}
