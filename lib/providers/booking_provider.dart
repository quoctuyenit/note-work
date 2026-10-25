import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/database/app_database.dart';
import 'package:note_work/models/sales_summary.dart';
import 'package:note_work/repository/booking_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final bookingRepoProvider = Provider<BookingRepository>((ref) => BookingRepository(ref.read(appDatabaseProvider)));

final defaultSlotsProvider = FutureProvider<List<DefaultSlot>>((ref) => ref.read(bookingRepoProvider).getDefaultSlots());
final employeesProvider = FutureProvider<List<Employee>>((ref) => ref.read(bookingRepoProvider).getEmployees());
final inProcessingDaysProvider = FutureProvider<List<BookingDay>>((ref) => ref.read(bookingRepoProvider).getInProcessingDays());
final completedDaysProvider = FutureProvider<List<BookingDay>>((ref) => ref.read(bookingRepoProvider).getCompletedDays());

final inProcessingGroupedProvider = FutureProvider<Map<int, List<BookingDay>>>((ref) => ref.read(bookingRepoProvider).getInProcessingGroupedByMonth());
final completedGroupedProvider = FutureProvider<Map<int, Map<int, List<BookingDay>>>>((ref) => ref.read(bookingRepoProvider).getCompletedGroupedByYearMonth());

// Collapsed state: default true -> auto collapsed on load
final monthCollapsedProvider = StateProvider.family<bool, int>((ref, monthKey) => true);
final yearCollapsedProvider = StateProvider.family<bool, int>((ref, year) => true);

final salesDaysProvider = FutureProvider<List<SalesDay>>((ref) => ref.read(bookingRepoProvider).getAllSalesDays());
final salesMonthCollapsedProvider = StateProvider.family<bool, int>((ref, monthKey) => true);
final salesYearCollapsedProvider = StateProvider.family<bool, int>((ref, year) => true);

class SalesSummaryFilter {
  final int year;
  final int? month;

  const SalesSummaryFilter({required this.year, this.month});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesSummaryFilter &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;
}

final salesSummaryProvider =
    FutureProvider.family<SalesPeriodSummary, SalesSummaryFilter>((ref, filter) {
  final repo = ref.read(bookingRepoProvider);
  return repo.getSalesSummary(year: filter.year, month: filter.month);
});
