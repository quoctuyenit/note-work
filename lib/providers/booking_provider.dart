import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:note_work/database/app_database.dart';
import 'package:note_work/repository/booking_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final bookingRepoProvider = Provider<BookingRepository>((ref) => BookingRepository(ref.read(appDatabaseProvider)));

final defaultSlotsProvider = FutureProvider<List<DefaultSlot>>((ref) => ref.read(bookingRepoProvider).getDefaultSlots());
final inProcessingDaysProvider = FutureProvider<List<BookingDay>>((ref) => ref.read(bookingRepoProvider).getInProcessingDays());
final completedDaysProvider = FutureProvider<List<BookingDay>>((ref) => ref.read(bookingRepoProvider).getCompletedDays());

final inProcessingGroupedProvider = FutureProvider<Map<int, List<BookingDay>>>((ref) => ref.read(bookingRepoProvider).getInProcessingGroupedByMonth());
final completedGroupedProvider = FutureProvider<Map<int, Map<int, List<BookingDay>>>>((ref) => ref.read(bookingRepoProvider).getCompletedGroupedByYearMonth());

// Collapsed state: default true -> auto collapsed on load
final monthCollapsedProvider = StateProvider.family<bool, int>((ref, monthKey) => true);
final yearCollapsedProvider = StateProvider.family<bool, int>((ref, year) => true);
