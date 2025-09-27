import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/providers/booking_provider.dart';
import 'package:note_work/ui/screens/settings_screen.dart';
import 'package:note_work/ui/tabs/complete_tab.dart';
import 'package:note_work/ui/tabs/in_processing_tab.dart';
import 'package:note_work/ui/widgets/search_customer_delegate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(bookingRepoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nail Schedule'),
        actions: [
          IconButton(
            tooltip: 'Tìm khách',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch(
                context: context,
                delegate: SearchCustomerDelegate(repo),
              );
              // result không cần dùng; delegate tự hiển thị
            },
          ),
          IconButton(
            tooltip: 'Cài đặt khung giờ',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              )
                  .then((_) {
                ref.refresh(inProcessingDaysProvider);
                ref.refresh(completedDaysProvider);
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'In Processing'),
            Tab(text: 'Complete'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          InProcessingTab(),
          CompleteTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Thêm ngày'),
        onPressed: () async {
          final existingDays = await repo.getAllBookingDays();
          final existingDates = existingDays
              .map((d) => DateTime(d.date.year, d.date.month, d.date.day))
              .toSet();

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          // tìm initialDate hợp lệ
          DateTime initialDate = today;
          while (existingDates.contains(initialDate)) {
            initialDate = initialDate.add(const Duration(days: 1));
          }

          final picked = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: today,
            lastDate: DateTime(2100),
            selectableDayPredicate: (day) {
              final normalized = DateTime(day.year, day.month, day.day);

              if (normalized.isBefore(today)) return false;
              if (existingDates.contains(normalized)) return false;

              return true;
            },
          );

          if (picked != null) {
            await repo.addBookingDayWithDefaultSlots(picked);

            // refresh lại data sau khi thêm
            ref.refresh(inProcessingDaysProvider);
            ref.refresh(completedDaysProvider);

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thêm ngày thành công')),
            );
          }
        },
      ),
    );
  }
}
