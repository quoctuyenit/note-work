// Hive-based replacement for the previous Drift database.
// This file provides the same data class names (BookingDay, BookingSlot, DefaultSlot)
// and an AppDatabase class exposing async methods used across the project.
// NOTE: The project must add hive & hive_flutter dependencies in pubspec.yaml:
//   hive: ^2.2.3
//   hive_flutter: ^1.1.0
//
// Also, ensure main.dart calls `await AppDatabase.init()` before runApp().

import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 0)
class BookingDay extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  bool isCompleted;

  @HiveField(3)
  bool isCollapsed;

  BookingDay({
    required this.id,
    required this.date,
    this.isCompleted = false,
    this.isCollapsed = false,
  });
}

class BookingDayAdapter extends TypeAdapter<BookingDay> {
  @override
  final int typeId = 0;

  @override
  BookingDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return BookingDay(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      isCompleted: fields[2] as bool,
      isCollapsed: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, BookingDay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isCompleted)
      ..writeByte(3)
      ..write(obj.isCollapsed);
  }
}

@HiveType(typeId: 1)
class BookingSlot extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String dayId;

  @HiveField(2)
  String time;

  @HiveField(3)
  String? customerName;

  @HiveField(4)
  String? note;

  BookingSlot({
    required this.id,
    required this.dayId,
    required this.time,
    this.customerName,
    this.note,
  });
}

class BookingSlotAdapter extends TypeAdapter<BookingSlot> {
  @override
  final int typeId = 1;

  @override
  BookingSlot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return BookingSlot(
      id: fields[0] as int,
      dayId: fields[1] as String,
      time: fields[2] as String,
      customerName: fields[3] as String?,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BookingSlot obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dayId)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.customerName)
      ..writeByte(4)
      ..write(obj.note);
  }
}

@HiveType(typeId: 2)
class DefaultSlot extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String time;

  DefaultSlot({required this.id, required this.time});
}

class DefaultSlotAdapter extends TypeAdapter<DefaultSlot> {
  @override
  final int typeId = 2;

  @override
  DefaultSlot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return DefaultSlot(
      id: fields[0] as int,
      time: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DefaultSlot obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.time);
  }
}

class AppDatabase {
  static const String _daysBox = 'booking_days';
  static const String _slotsBox = 'booking_slots';
  static const String _defaultsBox = 'default_slots';
  static const String _countersBox = 'counters_box';

  static Future<void> init() async {
    // Initialize Hive (call this once before runApp)
    await Hive.initFlutter();

    // Register adapters if not registered
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(BookingDayAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(BookingSlotAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(DefaultSlotAdapter());

    // Open boxes if not open
    if (!Hive.isBoxOpen(_daysBox)) await Hive.openBox<BookingDay>(_daysBox);
    if (!Hive.isBoxOpen(_slotsBox)) await Hive.openBox<BookingSlot>(_slotsBox);
    if (!Hive.isBoxOpen(_defaultsBox)) await Hive.openBox<DefaultSlot>(_defaultsBox);
    if (!Hive.isBoxOpen(_countersBox)) await Hive.openBox<int>(_countersBox);
  }

  // Constructor assumes boxes already opened via init()
  AppDatabase() {
    _days = Hive.box<BookingDay>(_daysBox);
    _slots = Hive.box<BookingSlot>(_slotsBox);
    _defaults = Hive.box<DefaultSlot>(_defaultsBox);
    _counters = Hive.box<int>(_countersBox);
  }

  late final Box<BookingDay> _days;
  late final Box<BookingSlot> _slots;
  late final Box<DefaultSlot> _defaults;
  late final Box<int> _counters;

  int _nextId(String key) {
    final cur = _counters.get(key, defaultValue: 0) ?? 0;
    final nxt = cur + 1;
    _counters.put(key, nxt);
    return nxt;
  }

  // BookingDays
  Future<void> insertBookingDay({required String id, required DateTime date}) async {
    final dOnly = DateTime(date.year, date.month, date.day);
    final day = BookingDay(id: id, date: dOnly);
    await _days.put(id, day);
  }

  Future<List<BookingDay>> getAllBookingDays() async {
    final list = _days.values.toList();
    list.sort((a, b) => a.date.compareTo(b.date));
    return list;
  }

  Future<BookingDay?> getDayByDate(DateTime dateOnly) async {
    try {
      return _days.values.cast<BookingDay?>().firstWhere(
          (d) => d != null && d.date.year == dateOnly.year && d.date.month == dateOnly.month && d.date.day == dateOnly.day);
    } catch (e) {
      return null;
    }
  }

  Future<BookingDay?> getDayById(String id) async {
    return _days.get(id);
  }

  Future<void> updateBookingDay(String id, {DateTime? date, bool? isCompleted, bool? isCollapsed}) async {
    final d = _days.get(id);
    if (d == null) return;
    d.date = date ?? d.date;
    d.isCompleted = isCompleted ?? d.isCompleted;
    d.isCollapsed = isCollapsed ?? d.isCollapsed;
    await d.save();
  }

  Future<void> deleteBookingDay(String id) async {
    // delete slots under the day
    final toDelete = _slots.values.where((s) => s.dayId == id).toList();
    for (final s in toDelete) {
      await _slots.delete(s.id);
    }
    await _days.delete(id);
  }

  // BookingSlots
  Future<int> insertBookingSlot({required String dayId, required String time, String? customerName, String? note}) async {
    final newId = _nextId('slot_id');
    final slot = BookingSlot(id: newId, dayId: dayId, time: time, customerName: customerName, note: note);
    // Use slot.id as key to simplify lookup by id
    await _slots.put(newId, slot);
    return newId;
  }

  Future<BookingSlot?> getSlotById(int id) async {
    return _slots.get(id);
  }

  Future<List<BookingSlot>> getSlotsByDay(String dayId) async {
    final list = _slots.values.where((s) => s.dayId == dayId).toList();
    list.sort((a, b) {
      // sort by time string as HH:mm ideally
      return a.time.compareTo(b.time);
    });
    return list;
  }

  Future<void> updateBookingSlot(int id, {String? customerName, String? note, String? time}) async {
    final s = _slots.get(id);
    if (s == null) return;
    s.customerName = customerName ?? s.customerName;
    s.note = note ?? s.note;
    s.time = time ?? s.time;
    await s.save();
  }

  Future<void> deleteSlot(int id) async {
    await _slots.delete(id);
  }

  Future<bool> slotExistsInDay({required String dayId, required String time}) async {
    final found = _slots.values.any((s) => s.dayId == dayId && s.time == time);
    return found;
  }

  Future<bool> slotExistsInDayExcludingId({required String dayId, required String time, required int excludeId}) async {
    final found = _slots.values.any((s) => s.dayId == dayId && s.time == time && s.id != excludeId);
    return found;
  }

  // DefaultSlots
  Future<int> insertDefaultSlot({required String time}) async {
    final newId = _nextId('default_slot_id');
    final ds = DefaultSlot(id: newId, time: time);
    await _defaults.put(newId, ds);
    return newId;
  }

  Future<List<DefaultSlot>> getAllDefaultSlots() async {
    final list = _defaults.values.toList();
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }

  Future<void> deleteDefaultSlot(int id) async {
    await _defaults.delete(id);
  }
}
