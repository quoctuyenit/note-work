import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/providers/booking_provider.dart';
import 'package:note_work/ui/screens/settings_screen.dart';
import 'package:note_work/ui/tabs/complete_tab.dart';
import 'package:note_work/ui/tabs/in_processing_tab.dart';
import 'package:note_work/ui/tabs/sales_tab.dart';
import 'package:note_work/ui/widgets/search_customer_delegate.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  late final ValueNotifier<Offset?> _fabPositionNotifier = ValueNotifier<Offset?>(null);
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() {
      if (!_tab.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tab.dispose();
    _fabPositionNotifier.dispose();
    super.dispose();
  }

  Future<void> _onAddPressed() async {
    final repo = ref.read(bookingRepoProvider);
    if (_tab.index == 2) {
      // Thêm doanh số (cho phép chọn ngày quá khứ/hiện tại/tương lai)
      final booked = await repo.getSalesDateSet();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      DateTime initialDate = today;
      while (booked.contains(initialDate)) {
        initialDate = initialDate.add(const Duration(days: 1));
      }

      final picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(2020),
        lastDate: DateTime(2100),
        selectableDayPredicate: (dt) {
          final dd = DateTime(dt.year, dt.month, dt.day);
          return !booked.contains(dd);
        },
      );

      if (picked != null) {
        await repo.addSalesDay(picked);
        ref.refresh(salesDaysProvider);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thêm doanh số thành công')),
        );
      }
    } else {
      // Thêm ngày lịch hẹn
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(bookingRepoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Note work'),
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
            tooltip: 'Cài đặt',
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context)
                  .push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              )
                  .then((_) {
                ref.refresh(inProcessingDaysProvider);
                ref.refresh(completedDaysProvider);
                ref.refresh(employeesProvider);
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'In Processing'),
            Tab(text: 'Complete'),
            Tab(text: 'Doanh số'),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          const double fabSize = 56.0;
          const double margin = 16.0;
          final double maxX =
              (constraints.maxWidth - fabSize - margin).clamp(margin, double.infinity);
          final double maxY =
              (constraints.maxHeight - fabSize - margin).clamp(margin, double.infinity);

          return Stack(
            children: [
              TabBarView(
                controller: _tab,
                children: const [
                  InProcessingTab(),
                  CompleteTab(),
                  SalesTab(),
                ],
              ),
              ValueListenableBuilder<Offset?>(
                valueListenable: _fabPositionNotifier,
                builder: (context, pos, child) {
                  final currentPos = pos ?? Offset(maxX, maxY);
                  final clampedPos = Offset(
                    currentPos.dx.clamp(margin, maxX),
                    currentPos.dy.clamp(margin, maxY),
                  );

                  return Positioned(
                    left: clampedPos.dx,
                    top: clampedPos.dy,
                    child: child!,
                  );
                },
                child: GestureDetector(
                  onPanStart: (_) => _isDragging = true,
                  onPanUpdate: (details) {
                    final current = _fabPositionNotifier.value ?? Offset(maxX, maxY);
                    _fabPositionNotifier.value = Offset(
                      (current.dx + details.delta.dx).clamp(margin, maxX),
                      (current.dy + details.delta.dy).clamp(margin, maxY),
                    );
                  },
                  onPanEnd: (_) {
                    Future.delayed(const Duration(milliseconds: 150), () {
                      if (mounted) _isDragging = false;
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      tooltip: _tab.index == 2 ? 'Thêm doanh số' : 'Thêm ngày',
                      child: const Icon(Icons.add),
                      onPressed: () {
                        if (_isDragging) return;
                        _onAddPressed();
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
