import 'package:uuid/uuid.dart';
import 'package:note_work/database/app_database.dart';

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
    // Expect formats like "1530" or "15:30" or "9:5" -> normalize to "HH:mm"
    final s = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (s.length < 3) {
      throw 'Giờ không hợp lệ';
    }
    final h = int.parse(s.substring(0, s.length - 2));
    final m = int.parse(s.substring(s.length - 2));
    if (h < 0 || h > 23 || m < 0 || m > 59) throw 'Giờ không hợp lệ';
    final hh = h.toString().padLeft(2, '0');
    final mm = m.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  // Default slots
  Future<List<DefaultSlot>> getDefaultSlots() => db.getAllDefaultSlots();

  Future<void> addDefaultSlot(String time) async {
    final norm = normalizeTimeInput(time);
    final all = await db.getAllDefaultSlots();
    if (all.any((e) => e.time == norm)) {
      throw 'Lỗi: Khung giờ mặc định đã tồn tại.';
    }
    await db.insertDefaultSlot(time: norm);
  }

  Future<void> deleteDefaultSlot(int id) => db.deleteDefaultSlot(id);

  // Day management
  Future<List<BookingDay>> getAllBookingDays() => db.getAllBookingDays();

  Future<Set<DateTime>> getBookedDateSet({String? excludeDayId}) async {
    final all = await db.getAllBookingDays();
    final set = <DateTime>{};
    for (final d in all) {
      if (excludeDayId == null || d.id != excludeDayId) set.add(d.date);
    }
    return set;
  }

  Future<String> addBookingDayWithDefaultSlots(DateTime date) async {
    final dOnly = _dateOnly(date);
    final today = _dateOnly(DateTime.now());
    if (dOnly.isBefore(today)) throw 'Lỗi: Không thể thêm ngày trong quá khứ.';
    if (await db.getDayByDate(dOnly) != null) throw 'Lỗi: Ngày này đã tồn tại.';

    final dayId = uuid.v4();
    await db.insertBookingDay(id: dayId, date: dOnly);
    final defaults = await db.getAllDefaultSlots();
    for (var slot in defaults) {
      await db.insertBookingSlot(dayId: dayId, time: slot.time);
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
    if (day == null) throw 'Không tìm thấy ngày.';
    await db.updateBookingDay(dayId, date: dOnly);
  }

  Future<void> toggleCollapse(String dayId) async {
    final day = await db.getDayById(dayId);
    if (day == null) return;
    await db.updateBookingDay(dayId, isCollapsed: !day.isCollapsed);
  }

  Future<void> setDayCompleted(String dayId, bool completed) async {
    final day = await db.getDayById(dayId);
    if (day == null) return;
    await db.updateBookingDay(dayId, isCompleted: completed);
  }

  Future<void> deleteDay(String dayId) async {
    // also deletes slots in db.deleteBookingDay
    await db.deleteBookingDay(dayId);
  }

  // Slot management
  Future<List<BookingSlot>> getSlotsForDay(String dayId) =>
      db.getSlotsByDay(dayId);

  Future<int> addSlotToDay(String dayId, String time,
      {String? customerName, String? note}) async {
    final normalized = normalizeTimeInput(time);
    if (await db.slotExistsInDay(dayId: dayId, time: normalized))
      throw 'Lỗi: Khung giờ này đã tồn tại trong ngày.';
    return db.insertBookingSlot(
        dayId: dayId, time: normalized, customerName: customerName, note: note);
  }

  Future<void> updateSlot(int slotId,
      {String? newTime, String? newName, String? newNote}) async {
    final slot = await db.getSlotById(slotId);
    if (slot == null) throw 'Không tìm thấy khung giờ.';
    if (newTime != null) {
      final norm = normalizeTimeInput(newTime);
      if (await db.slotExistsInDayExcludingId(
          dayId: slot.dayId, time: norm, excludeId: slotId)) {
        throw 'Lỗi: Khung giờ bị trùng.';
      }
      await db.updateBookingSlot(slotId,
          time: norm,
          customerName: newName ?? slot.customerName,
          note: newNote ?? slot.note);
    } else {
      await db.updateBookingSlot(slotId, customerName: newName, note: newNote);
    }
  }

  Future<void> removeSlot(int slotId) async {
    await db.deleteSlot(slotId);
  }

  Future<BookingSlot?> getSlotById(int id) => db.getSlotById(id);

  // Grouped lists
  Future<List<BookingDay>> getInProcessingDays() async {
    final today = _dateOnly(DateTime.now());
    final all = await db.getAllBookingDays();
    return all
        .where((d) => !d.isCompleted && !_isBefore(d.date, today))
        .toList();
  }

  Future<List<BookingDay>> getCompletedDays() async {
    final today = _dateOnly(DateTime.now());
    final all = await db.getAllBookingDays();
    return all.where((d) => d.isCompleted || _isBefore(d.date, today)).toList();
  }

  Future<Map<int, List<BookingDay>>> getInProcessingGroupedByMonth() async {
    final days = await getInProcessingDays();
    final Map<int, List<BookingDay>> out = {};
    for (final d in days) {
      final k = d.date.month;
      out.putIfAbsent(k, () => []);
      out[k]!.add(d);
    }
    return out;
  }

  Future<Map<int, Map<int, List<BookingDay>>>>
      getCompletedGroupedByYearMonth() async {
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

  //export
  Future<List<BookingDay>> exportBookingDay() => db.exportBookingDays();
  Future<List<BookingSlot>> exportBookingSlot() => db.exportBookingSlots();
  Future<List<DefaultSlot>> exportDefaultSlot() => db.exportDefaultSlots();

  //clear
  Future<void> clearAll() => db.clearAll();
  int getCounter(key) => db.getCounter(key);

  //add
  Future<void> restoreDay(day) => db.addDay(day);
  Future<void> restoreSlot(slot) => db.addSlot(slot);
  Future<void> restoreDefaultSlot(DefaultSlot slot) => db.addDefaultSlot(slot);
  Future<void> restoreCounter(String key, int value) =>
      db.setCounter(key, value);
}
