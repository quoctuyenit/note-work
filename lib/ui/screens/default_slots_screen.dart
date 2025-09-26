import 'package:flutter/material.dart';
import 'package:nail_schedule_app/repository/booking_repository.dart';
import 'package:nail_schedule_app/database/app_database.dart';

class DefaultSlotsScreen extends StatefulWidget {
  final BookingRepository bookingRepo;

  const DefaultSlotsScreen({super.key, required this.bookingRepo});

  @override
  State<DefaultSlotsScreen> createState() => _DefaultSlotsScreenState();
}

class _DefaultSlotsScreenState extends State<DefaultSlotsScreen> {
  List<DefaultSlot> slots = [];
  final TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    final data = await widget.bookingRepo.getDefaultSlots();
    setState(() {
      slots = data;
    });
  }

  Future<void> _addSlot() async {
    final time = timeController.text.trim();
    if (time.isEmpty) return;

    await widget.bookingRepo.addDefaultSlot(time);
    timeController.clear();
    _loadSlots();
  }

  Future<void> _deleteSlot(int id) async {
    await widget.bookingRepo.deleteDefaultSlot(id);
    _loadSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khung giờ mặc định')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Nhập thời gian
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      labelText: 'Thời gian (ví dụ: 10:00)',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addSlot,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Danh sách slot
            Expanded(
              child: ListView.builder(
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return ListTile(
                    title: Text(slot.time),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteSlot(slot.id),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
