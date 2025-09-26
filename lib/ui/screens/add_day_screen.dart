import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nail_schedule_app/repository/booking_repository.dart';

class AddDayScreen extends StatefulWidget {
  final BookingRepository bookingRepo;
  const AddDayScreen({super.key, required this.bookingRepo});

  @override
  State<AddDayScreen> createState() => _AddDayScreenState();
}

class _AddDayScreenState extends State<AddDayScreen> {
  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _save() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng chọn ngày')));
      return;
    }
    try {
      await widget.bookingRepo.addBookingDayWithDefaultSlots(selectedDate!);
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      final msg = (e is String) ? e : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = selectedDate != null
        ? DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(selectedDate!)
        : 'Chưa chọn';

    return Scaffold(
      appBar: AppBar(title: const Text('Thêm ngày mới')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Expanded(child: Text('Ngày: $dateStr')),
              TextButton(onPressed: _pickDate, child: const Text('Chọn ngày')),
            ]),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Lưu')),
          ],
        ),
      ),
    );
  }
}
