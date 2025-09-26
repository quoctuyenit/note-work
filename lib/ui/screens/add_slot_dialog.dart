import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nail_schedule_app/repository/booking_repository.dart';
import 'package:nail_schedule_app/ui/widgets/time_text_formatter.dart';

class AddOrEditSlotDialog extends StatefulWidget {
  final BookingRepository repo;
  final String dayId;
  final int? slotId;
  final String? initialTime;
  final String? initialName;
  final String? initialNote;

  const AddOrEditSlotDialog({
    super.key,
    required this.repo,
    required this.dayId,
    this.slotId,
    this.initialTime,
    this.initialName,
    this.initialNote,
  });

  @override
  State<AddOrEditSlotDialog> createState() => _AddOrEditSlotDialogState();
}

class _AddOrEditSlotDialogState extends State<AddOrEditSlotDialog> {
  final timeCtl = TextEditingController();
  final nameCtl = TextEditingController();
  final noteCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeCtl.text = widget.initialTime ?? '';
    nameCtl.text = widget.initialName ?? '';
    noteCtl.text = widget.initialNote ?? '';
  }

  @override
  void dispose() {
    timeCtl.dispose();
    nameCtl.dispose();
    noteCtl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final timeRaw = timeCtl.text.trim();
    final nameRaw = nameCtl.text.trim();
    final noteRaw = noteCtl.text.trim();

    if (timeRaw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập giờ')));
      return;
    }

    try {
      if (widget.slotId == null) {
        // add new: if empty -> pass null
        await widget.repo.addSlotToDay(widget.dayId, timeRaw, customerName: nameRaw.isEmpty ? null : nameRaw, note: noteRaw.isEmpty ? null : noteRaw);
      } else {
        // edit existing: use '' to signal explicit clear; repo.updateSlot interprets '' as clear -> null
        final nameParam = nameRaw.isEmpty ? '' : nameRaw;
        final noteParam = noteRaw.isEmpty ? '' : noteRaw;
        await widget.repo.updateSlot(widget.slotId!, newTime: timeRaw, newName: nameParam, newNote: noteParam);
      }
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      final message = (e is String) ? e : e.toString();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.slotId != null;
    return AlertDialog(
      title: Text(isEdit ? 'Sửa khung giờ' : 'Thêm khung giờ'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: timeCtl,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, TimeTextFormatter()],
              decoration: const InputDecoration(labelText: 'Giờ (hh:mm) – gõ 1530 → 15:30'),
            ),
            const SizedBox(height: 8),
            TextField(controller: nameCtl, decoration: const InputDecoration(labelText: 'Tên khách (có thể bỏ trống)')),
            const SizedBox(height: 8),
            TextField(controller: noteCtl, decoration: const InputDecoration(labelText: 'Ghi chú (có thể bỏ trống)')),
          ],
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')), ElevatedButton(onPressed: _save, child: const Text('Lưu'))],
    );
  }
}
