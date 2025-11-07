import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/providers/booking_provider.dart';
import 'package:note_work/ui/tabs/backup_data_tab.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _timeCtl = TextEditingController();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timeCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(bookingRepoProvider);
    final asyncDefaults = ref.watch(defaultSlotsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Khung giờ'),
            Tab(text: 'Data Control'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _timeCtl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Thêm khung giờ (hhmm hoặc hh:mm)',
                    ),
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
                      final msg = (e is String)
                          ? e
                          : e.toString().replaceFirst('Exception: ', 'Lỗi: ');
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(msg)));
                    }
                  },
                ),
              ]),
              const SizedBox(height: 12),
              Expanded(
                child: asyncDefaults.when(
                  data: (list) {
                    if (list.isEmpty) {
                      return const Center(child: Text('Chưa có khung giờ mặc định'));
                    }
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

          // Tab 2: Backup / Restore
          const BackupDataTab(),
        ],
      ),
    );
  }
}
