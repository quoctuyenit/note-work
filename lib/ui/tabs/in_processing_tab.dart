import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nail_schedule_app/providers/booking_provider.dart';
import 'package:nail_schedule_app/ui/widgets/day_item.dart';
import 'package:nail_schedule_app/database/app_database.dart';

class InProcessingTab extends ConsumerWidget {
  const InProcessingTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(inProcessingDaysProvider);
    final repo = ref.read(bookingRepoProvider);

    void reloadAll() {
      ref.refresh(inProcessingDaysProvider);
      ref.refresh(inProcessingGroupedProvider);
      ref.refresh(completedDaysProvider);
      ref.refresh(completedGroupedProvider);
    }

    return daysAsync.when(
      data: (days) {
        if (days.isEmpty) return const Center(child: Text('Không có lịch hẹn'));
        final currentYear = DateTime.now().year;
        final mixedYears = days.any((d) => d.date.year != currentYear);

        if (!mixedYears) {
          // group by month only
          final Map<int, List<BookingDay>> grouped = {};
          for (final d in days) {
            grouped.putIfAbsent(d.date.month, () => []);
            grouped[d.date.month]!.add(d);
          }
          final months = grouped.keys.toList()..sort((a, b) => b.compareTo(a)); // newest month first
          return ListView.builder(
            itemCount: months.length,
            itemBuilder: (ctx, idx) {
              final month = months[idx];
              final daysInMonth = grouped[month]!;
              final collapsed = ref.watch(monthCollapsedProvider(month));
              return ExpansionTile(
                initiallyExpanded: !collapsed,
                title: Text('Tháng $month'),
                onExpansionChanged: (val) => ref.read(monthCollapsedProvider(month).notifier).state = !val,
                children: daysInMonth.map((d) {
                  return FutureBuilder<List<BookingSlot>>(
                    future: repo.getSlotsForDay(d.id),
                    builder: (c, snap) {
                      final slots = snap.data ?? <BookingSlot>[];
                      return DayItem(day: d, slots: slots, isCompleteTab: false, onChanged: reloadAll);
                    },
                  );
                }).toList(),
              );
            },
          );
        } else {
          // group by year -> month
          final Map<int, Map<int, List<BookingDay>>> grouped = {};
          for (final d in days) {
            final y = d.date.year;
            final m = d.date.month;
            grouped.putIfAbsent(y, () => {});
            grouped[y]!.putIfAbsent(m, () => []);
            grouped[y]![m]!.add(d);
          }
          final years = grouped.keys.toList()..sort((a, b) => b.compareTo(a)); // latest year first
          return ListView.builder(
            itemCount: years.length,
            itemBuilder: (ctx, yi) {
              final y = years[yi];
              final monthsMap = grouped[y]!;
              final collapsedYear = ref.watch(yearCollapsedProvider(y));
              final monthKeys = monthsMap.keys.toList()..sort((a, b) => b.compareTo(a));
              return ExpansionTile(
                initiallyExpanded: !collapsedYear,
                title: Text('Năm $y'),
                onExpansionChanged: (val) => ref.read(yearCollapsedProvider(y).notifier).state = !val,
                children: monthKeys.map((month) {
                  final daysInMonth = monthsMap[month]!;
                  final monthKey = y * 100 + month;
                  final collapsedMonth = ref.watch(monthCollapsedProvider(monthKey));
                  return ExpansionTile(
                    initiallyExpanded: !collapsedMonth,
                    title: Text('Tháng $month'),
                    onExpansionChanged: (val) => ref.read(monthCollapsedProvider(monthKey).notifier).state = !val,
                    children: daysInMonth.map((d) {
                      return FutureBuilder<List<BookingSlot>>(
                        future: repo.getSlotsForDay(d.id),
                        builder: (c, snap) {
                          final slots = snap.data ?? <BookingSlot>[];
                          return DayItem(day: d, slots: slots, isCompleteTab: false, onChanged: reloadAll);
                        },
                      );
                    }).toList(),
                  );
                }).toList(),
              );
            },
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Lỗi: $e')),
    );
  }
}
