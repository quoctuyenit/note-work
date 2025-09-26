import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nail_schedule_app/providers/booking_provider.dart';
import 'package:nail_schedule_app/ui/widgets/day_item.dart';
import 'package:nail_schedule_app/database/app_database.dart';

class CompleteTab extends ConsumerWidget {
  const CompleteTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedAsync = ref.watch(completedGroupedProvider);
    final repo = ref.read(bookingRepoProvider);

    void reloadAll() {
      ref.refresh(completedGroupedProvider);
      ref.refresh(completedDaysProvider);
      ref.refresh(inProcessingGroupedProvider);
      ref.refresh(inProcessingDaysProvider);
    }

    return groupedAsync.when(
      data: (map) {
        if (map.isEmpty) return const Center(child: Text('Chưa có mục hoàn tất'));
        final years = map.keys.toList()..sort((a, b) => b.compareTo(a));
        return ListView.builder(
          itemCount: years.length,
          itemBuilder: (ctx, yi) {
            final y = years[yi];
            final monthsMap = map[y]!;
            final collapsedYear = ref.watch(yearCollapsedProvider(y));
            final monthKeys = monthsMap.keys.toList()..sort((a, b) => b.compareTo(a));
            return ExpansionTile(
              initiallyExpanded: !collapsedYear,
              title: Text('Năm $y'),
              onExpansionChanged: (val) => ref.read(yearCollapsedProvider(y).notifier).state = !val,
              children: monthKeys.map((month) {
                final days = monthsMap[month]!;
                final monthKey = y * 100 + month;
                final collapsedMonth = ref.watch(monthCollapsedProvider(monthKey));
                return ExpansionTile(
                  initiallyExpanded: !collapsedMonth,
                  title: Text('Tháng $month'),
                  onExpansionChanged: (val) => ref.read(monthCollapsedProvider(monthKey).notifier).state = !val,
                  children: days.map((d) {
                    return FutureBuilder<List<BookingSlot>>(
                      future: repo.getSlotsForDay(d.id),
                      builder: (c, snap) {
                        final slots = snap.data ?? <BookingSlot>[];
                        return DayItem(day: d, slots: slots, isCompleteTab: true, onChanged: reloadAll);
                      },
                    );
                  }).toList(),
                );
              }).toList(),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Lỗi: $e')),
    );
  }
}
