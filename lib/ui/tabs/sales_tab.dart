import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/database/app_database.dart';
import 'package:note_work/providers/booking_provider.dart';
import 'package:note_work/ui/widgets/sales_day_item.dart';

class SalesTab extends ConsumerWidget {
  const SalesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysAsync = ref.watch(salesDaysProvider);
    final repo = ref.read(bookingRepoProvider);

    void reloadAll() {
      ref.refresh(salesDaysProvider);
    }

    return daysAsync.when(
      data: (days) {
        if (days.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.point_of_sale_outlined,
                    size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'Chưa có dữ liệu',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    final booked = await repo.getSalesDateSet();

                    final picked = await showDatePicker(
                      context: context,
                      initialDate: today,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                      selectableDayPredicate: (dt) {
                        final dd = DateTime(dt.year, dt.month, dt.day);
                        return !booked.contains(dd);
                      },
                    );

                    if (picked != null) {
                      await repo.addSalesDay(picked);
                      reloadAll();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Thêm dữ liệu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        final currentYear = DateTime.now().year;
        final mixedYears = days.any((d) => d.date.year != currentYear);

        if (!mixedYears) {
          // Nhóm theo Tháng
          final Map<int, List<SalesDay>> grouped = {};
          for (final d in days) {
            grouped.putIfAbsent(d.date.month, () => []);
            grouped[d.date.month]!.add(d);
          }
          final months = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: months.length,
            itemBuilder: (ctx, idx) {
              final month = months[idx];
              final daysInMonth = grouped[month]!;
              final collapsed = ref.watch(salesMonthCollapsedProvider(month));

              return ExpansionTile(
                initiallyExpanded: !collapsed,
                title: Text(
                  'Tháng $month',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onExpansionChanged: (val) => ref
                    .read(salesMonthCollapsedProvider(month).notifier)
                    .state = !val,
                children: daysInMonth.map((d) {
                  return FutureBuilder<List<EmployeeSale>>(
                    future: repo.getSalesForDay(d.id),
                    builder: (c, snap) {
                      final sales = snap.data ?? <EmployeeSale>[];
                      return SalesDayItem(
                        day: d,
                        sales: sales,
                        repo: repo,
                        onChanged: reloadAll,
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        } else {
          // Nhóm theo Năm -> Tháng
          final Map<int, Map<int, List<SalesDay>>> grouped = {};
          for (final d in days) {
            final y = d.date.year;
            final m = d.date.month;
            grouped.putIfAbsent(y, () => {});
            grouped[y]!.putIfAbsent(m, () => []);
            grouped[y]![m]!.add(d);
          }
          final years = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: years.length,
            itemBuilder: (ctx, yi) {
              final y = years[yi];
              final monthsMap = grouped[y]!;
              final collapsedYear = ref.watch(salesYearCollapsedProvider(y));
              final monthKeys = monthsMap.keys.toList()
                ..sort((a, b) => b.compareTo(a));

              return ExpansionTile(
                initiallyExpanded: !collapsedYear,
                title: Text(
                  'Năm $y',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                onExpansionChanged: (val) => ref
                    .read(salesYearCollapsedProvider(y).notifier)
                    .state = !val,
                children: monthKeys.map((month) {
                  final daysInMonth = monthsMap[month]!;
                  final monthKey = y * 100 + month;
                  final collapsedMonth =
                      ref.watch(salesMonthCollapsedProvider(monthKey));

                  return ExpansionTile(
                    initiallyExpanded: !collapsedMonth,
                    title: Text(
                      'Tháng $month',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onExpansionChanged: (val) => ref
                        .read(salesMonthCollapsedProvider(monthKey).notifier)
                        .state = !val,
                    children: daysInMonth.map((d) {
                      return FutureBuilder<List<EmployeeSale>>(
                        future: repo.getSalesForDay(d.id),
                        builder: (c, snap) {
                          final sales = snap.data ?? <EmployeeSale>[];
                          return SalesDayItem(
                            day: d,
                            sales: sales,
                            repo: repo,
                            onChanged: reloadAll,
                          );
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
