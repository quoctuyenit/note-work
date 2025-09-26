import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nail_schedule_app/providers/booking_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final TextEditingController _timeCtl = TextEditingController();

  @override
  void dispose() {
    _timeCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(bookingRepoProvider);
    final asyncDefaults = ref.watch(defaultSlotsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt khung giờ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            Expanded(
              child: TextField(
                controller: _timeCtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Thêm khung giờ (hhmm hoặc hh:mm)'),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final time = _timeCtl.text.trim();
                if (time.isEmpty) return;
                try {
                  await repo.addDefaultSlot(time);
                  _timeCtl.clear();
                  ref.refresh(defaultSlotsProvider);
                } catch (e) {
                  final msg = (e is String) ? e : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                }
              },
            ),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: asyncDefaults.when(
              data: (list) {
                if (list.isEmpty) return const Center(child: Text('Chưa có khung giờ mặc định'));
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (ctx, i) {
                    final s = list[i];
                    return ListTile(
                      title: Text(s.time),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await repo.deleteDefaultSlot(s.id);
                          ref.refresh(defaultSlotsProvider);
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Lỗi: $e')),
            ),
          ),
        ]),
      ),
    );
  }
}
