import 'package:drift/drift.dart';
import 'open_connection.dart';

part 'app_database.g.dart';

class BookingDays extends Table {
  TextColumn get id => text()(); // UUID
  DateTimeColumn get date => dateTime()(); // Ngày (00:00)
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isCollapsed => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class BookingSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get dayId => text().references(BookingDays, #id)();
  TextColumn get time => text()(); // "HH:mm"
  TextColumn get customerName => text().nullable()();
  TextColumn get note => text().nullable()();
}

class DefaultSlots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get time => text()();
}

@DriftDatabase(tables: [BookingDays, BookingSlots, DefaultSlots])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  // bump schema version
  @override
  int get schemaVersion => 1;

  // migration: thêm cột note cho bookingSlots nếu nâng version
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(bookingSlots, bookingSlots.note);
          }
        },
      );

  // BookingDays
  Future<void> insertBookingDay(BookingDaysCompanion entry) =>
      into(bookingDays).insert(entry);

  Future<List<BookingDay>> getAllBookingDays() =>
      (select(bookingDays)..orderBy([(t) => OrderingTerm(expression: t.date)]))
          .get();

  Future<BookingDay?> getDayByDate(DateTime dateOnly) async {
    final all = await getAllBookingDays();
    final dOnly = DateTime(dateOnly.year, dateOnly.month, dateOnly.day);
    for (final d in all) {
      final x = DateTime(d.date.year, d.date.month, d.date.day);
      if (x == dOnly) return d;
    }
    return null;
  }

  Future<BookingDay> getDayById(String id) =>
      (select(bookingDays)..where((t) => t.id.equals(id))).getSingle();

  Future<void> updateBookingDay(BookingDay entry) =>
      update(bookingDays).replace(entry);

  Future<void> deleteBookingDay(String id) =>
      (delete(bookingDays)..where((t) => t.id.equals(id))).go();

  // BookingSlots
  Future<int> insertBookingSlot(BookingSlotsCompanion entry) =>
      into(bookingSlots).insert(entry);

  Future<List<BookingSlot>> getSlotsByDay(String dayId) => (select(bookingSlots)
        ..where((t) => t.dayId.equals(dayId))
        ..orderBy([(t) => OrderingTerm(expression: t.time)]))
      .get();

  Future<BookingSlot> getSlotById(int id) =>
      (select(bookingSlots)..where((t) => t.id.equals(id))).getSingle();

  Future<void> updateBookingSlot(BookingSlot entry) =>
      update(bookingSlots).replace(entry);

  Future<void> deleteSlot(int id) =>
      (delete(bookingSlots)..where((t) => t.id.equals(id))).go();

  // check slot exists in day (add)
  Future<bool> slotExistsInDay(
      {required String dayId, required String time}) async {
    final q = await (select(bookingSlots)
          ..where((t) => t.dayId.equals(dayId) & t.time.equals(time)))
        .get();
    return q.isNotEmpty;
  }

  // check slot exists excluding an id (for edit)
  Future<bool> slotExistsInDayExcludingId({
    required String dayId,
    required String time,
    required int excludeId,
  }) async {
    final q = await (select(bookingSlots)
          ..where((t) =>
              t.dayId.equals(dayId) &
              t.time.equals(time) &
              t.id.isNotValue(excludeId)))
        .get();
    return q.isNotEmpty;
  }

  // DefaultSlots
  Future<int> insertDefaultSlot(DefaultSlotsCompanion entry) =>
      into(defaultSlots).insert(entry);

  Future<List<DefaultSlot>> getAllDefaultSlots() =>
      (select(defaultSlots)..orderBy([(t) => OrderingTerm(expression: t.time)]))
          .get();

  Future<void> deleteDefaultSlot(int id) =>
      (delete(defaultSlots)..where((t) => t.id.equals(id))).go();
}
