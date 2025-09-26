import 'package:uuid/uuid.dart';
import 'package:nail_schedule_app/database/app_database.dart';
import 'package:drift/drift.dart';

class BookingRepository {
  final AppDatabase db;
  final uuid = const Uuid();

  BookingRepository(this.db);

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
  bool _isBefore(DateTime a, DateTime b) {
    final da = _dateOnly(a), dbb = _dateOnly(b);
    return da.isBefore(dbb);
  }

  String normalizeTimeInput(String raw) {
    var t = raw.replaceAll(':', '').trim();
    if (t.isEmpty) return '00:00';
    if (t.length == 1) t = '${t}000';
    if (t.length == 2) t = '${t}00';
    if (t.length == 3) t = '0$t';
    if (t.length > 4) t = t.substring(0, 4);
    final hh = t.substring(0, 2);
    final mm = t.substring(2, 4);
    return '${hh.padLeft(2, '0')}:${mm.padLeft(2, '0')}';
  }

  // Basic reads
  Future<List<BookingDay>> getAllBookingDays() => db.getAllBookingDays();
  Future<BookingDay> getDayById(String id) => db.getDayById(id);
  Future<List<BookingSlot>> getSlotsForDay(String dayId) => db.getSlotsByDay(dayId);
  Future<List<DefaultSlot>> getDefaultSlots() => db.getAllDefaultSlots();

  Future<Set<DateTime>> getBookedDateSet({String? excludeDayId}) async {
    final all = await db.getAllBookingDays();
    final set = <DateTime>{};
    for (final d in all) {
      if (excludeDayId != null && d.id == excludeDayId) continue;
      set.add(_dateOnly(d.date));
    }
    return set;
  }

  // Default slots
  Future<void> addDefaultSlot(String time) async {
    final norm = normalizeTimeInput(time);
    final existing = await db.getAllDefaultSlots();
    if (existing.any((e) => e.time == norm)) {
      throw 'Lỗi: Khung giờ mặc định đã tồn tại.';
    }
    await db.insertDefaultSlot(DefaultSlotsCompanion.insert(time: norm));
  }

  Future<void> deleteDefaultSlot(int id) async {
    await db.deleteDefaultSlot(id);
  }

  // Day management
  Future<bool> dayExists(DateTime date) async {
    final d = await db.getDayByDate(_dateOnly(date));
    return d != null;
  }

  Future<String> addBookingDayWithDefaultSlots(DateTime date) async {
    final dOnly = _dateOnly(date);
    final today = _dateOnly(DateTime.now());
    if (dOnly.isBefore(today)) throw 'Lỗi: Không thể thêm ngày trong quá khứ.';
    if (await dayExists(dOnly)) throw 'Lỗi: Ngày này đã tồn tại.';

    final dayId = uuid.v4();
    await db.insertBookingDay(BookingDaysCompanion.insert(id: dayId, date: dOnly));
    final defaults = await db.getAllDefaultSlots();
    for (var slot in defaults) {
      await db.insertBookingSlot(BookingSlotsCompanion.insert(dayId: dayId, time: slot.time));
    }
    return dayId;
  }

  Future<String> createDayWithCustomSlots(
    DateTime date,
    List<({String time, String? name, String? note})> slots,
  ) async {
    final dOnly = _dateOnly(date);
    final today = _dateOnly(DateTime.now());
    if (dOnly.isBefore(today)) throw 'Lỗi: Không thể thêm ngày trong quá khứ.';
    if (await dayExists(dOnly)) throw 'Lỗi: Ngày này đã tồn tại.';

    final seen = <String>{};
    for (final s in slots) {
      final norm = normalizeTimeInput(s.time);
      if (seen.contains(norm)) throw 'Lỗi: Khung giờ $norm bị trùng trong danh sách.';
      seen.add(norm);
    }

    final dayId = uuid.v4();
    await db.insertBookingDay(BookingDaysCompanion.insert(id: dayId, date: dOnly));
    for (final s in slots) {
      final norm = normalizeTimeInput(s.time);
      await db.insertBookingSlot(BookingSlotsCompanion.insert(
        dayId: dayId,
        time: norm,
        customerName: s.name != null ? Value(s.name!) : const Value.absent(),
        note: s.note != null ? Value(s.note!) : const Value.absent(),
      ));
    }
    return dayId;
  }

  Future<void> updateDayDate(String dayId, DateTime newDate) async {
    final dOnly = _dateOnly(newDate);
    final today = _dateOnly(DateTime.now());
    if (dOnly.isBefore(today)) throw 'Lỗi: Không thể đổi sang ngày quá khứ.';
    final exists = await db.getDayByDate(dOnly);
    if (exists != null && exists.id != dayId) throw 'Lỗi: Ngày này đã tồn tại.';
    final day = await db.getDayById(dayId);

    final updated = BookingDay(id: day.id, date: dOnly, isCompleted: day.isCompleted, isCollapsed: day.isCollapsed);
    await db.updateBookingDay(updated);
  }

  Future<void> deleteDay(String dayId) async {
    final slots = await db.getSlotsByDay(dayId);
    for (final s in slots) {
      await db.deleteSlot(s.id);
    }
    await db.deleteBookingDay(dayId);
  }

  Future<void> setDayCompleted(String dayId, bool completed) async {
    final day = await db.getDayById(dayId);
    final updated = BookingDay(id: day.id, date: day.date, isCompleted: completed, isCollapsed: day.isCollapsed);
    await db.updateBookingDay(updated);
  }

  Future<void> toggleCollapse(String dayId) async {
    final day = await db.getDayById(dayId);
    final updated = BookingDay(id: day.id, date: day.date, isCompleted: day.isCompleted, isCollapsed: !day.isCollapsed);
    await db.updateBookingDay(updated);
  }

  Future<void> autoCompletePastDays() async {
    final today = _dateOnly(DateTime.now());
    final all = await db.getAllBookingDays();
    for (var d in all) {
      if (_isBefore(d.date, today) && !d.isCompleted) {
        final updated = BookingDay(id: d.id, date: d.date, isCompleted: true, isCollapsed: d.isCollapsed);
        await db.updateBookingDay(updated);
      }
    }
  }

  // Slot management
  Future<int> addSlotToDay(String dayId, String time, {String? customerName, String? note}) async {
    final normalized = normalizeTimeInput(time);
    if (await slotExists(dayId, normalized)) throw 'Lỗi: Khung giờ này đã tồn tại trong ngày.';
    return db.insertBookingSlot(BookingSlotsCompanion.insert(
      dayId: dayId,
      time: normalized,
      customerName: customerName != null ? Value(customerName) : const Value.absent(),
      note: note != null ? Value(note) : const Value.absent(),
    ));
  }

  /// Update slot: if newName/newNote provided -> update them.
  /// Special rule: if newName/newNote is provided as empty string (''), treat as explicit "clear" -> set null.
  Future<void> updateSlot(int slotId, {String? newTime, String? newName, String? newNote}) async {
    final slot = await db.getSlotById(slotId);
    final timeToUse = newTime != null ? normalizeTimeInput(newTime) : slot.time;

    if (await slotExistsExcluding(slot.dayId, timeToUse, slotId)) {
      throw 'Lỗi: Khung giờ này đã tồn tại trong ngày.';
    }

    String? nameToUse;
    if (newName != null) {
      final t = newName.trim();
      nameToUse = t.isEmpty ? null : t;
    } else {
      nameToUse = slot.customerName;
    }

    String? noteToUse;
    if (newNote != null) {
      final t = newNote.trim();
      noteToUse = t.isEmpty ? null : t;
    } else {
      noteToUse = slot.note;
    }

    final updated = BookingSlot(id: slot.id, dayId: slot.dayId, time: timeToUse, customerName: nameToUse, note: noteToUse);
    await db.updateBookingSlot(updated);
  }

  Future<void> updateSlotTime(int slotId, String newTime) => updateSlot(slotId, newTime: newTime);
  Future<void> updateSlotCustomer(int slotId, String? name) => updateSlot(slotId, newName: name);

  Future<void> removeSlot(int slotId) => db.deleteSlot(slotId);

  Future<bool> slotExists(String dayId, String time) => db.slotExistsInDay(dayId: dayId, time: time);
  Future<bool> slotExistsExcluding(String dayId, String time, int excludeId) =>
      db.slotExistsInDayExcludingId(dayId: dayId, time: time, excludeId: excludeId);

  // Search
  Future<List<Map<String, dynamic>>> searchByCustomer(String keyword) async {
    final allDays = await db.getAllBookingDays();
    final results = <Map<String, dynamic>>[];
    for (final d in allDays) {
      final slots = await db.getSlotsByDay(d.id);
      for (final s in slots) {
        final name = s.customerName ?? '';
        if (name.toLowerCase().contains(keyword.toLowerCase())) {
          results.add({'slot': s, 'day': d});
        }
      }
    }
    return results;
  }

  // Grouped data
  Future<List<BookingDay>> getInProcessingDays() async {
    final today = _dateOnly(DateTime.now());
    final all = await db.getAllBookingDays();
    return all.where((d) => !d.isCompleted && !_isBefore(d.date, today)).toList();
  }

  Future<List<BookingDay>> getCompletedDays() async {
    final today = _dateOnly(DateTime.now());
    final all = await db.getAllBookingDays();
    return all.where((d) => d.isCompleted || _isBefore(d.date, today)).toList();
  }

  Future<Map<int, List<BookingDay>>> getInProcessingGroupedByMonth() async {
    final days = await getInProcessingDays();
    final Map<int, List<BookingDay>> grouped = {};
    for (final d in days) {
      grouped.putIfAbsent(d.date.month, () => []);
      grouped[d.date.month]!.add(d);
    }
    return grouped;
  }

  Future<Map<int, Map<int, List<BookingDay>>>> getCompletedGroupedByYearMonth() async {
    final days = await getCompletedDays();
    final Map<int, Map<int, List<BookingDay>>> out = {};
    for (final d in days) {
      final y = d.date.year;
      final m = d.date.month;
      out.putIfAbsent(y, () => {});
      out[y]!.putIfAbsent(m, () => []);
      out[y]![m]!.add(d);
    }
    return out;
  }
}
