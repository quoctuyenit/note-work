import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/providers/booking_provider.dart';
import 'package:note_work/services/backup_service.dart';

class BackupDataTab extends ConsumerWidget  {
  const BackupDataTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingRepo = ref.read(bookingRepoProvider);
    final backupService = BackupService(bookingRepo);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              '⚙️ Sao lưu & Phục hồi dữ liệu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => backupService.backup(context),
              icon: const Icon(Icons.download),
              label: const Text('Xuất file backup'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 48),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => backupService.restore(context),
              icon: const Icon(Icons.upload),
              label: const Text('Khôi phục từ file'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 48),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chú ý: Chức năng này cho phép bạn sao lưu, hoặc khôi phục toàn bộ dữ liệu lịch, slot và cài đặt.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
