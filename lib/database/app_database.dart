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

  factory BookingDay.fromJson(Map<String, dynamic> json) {
    return BookingDay(
      id: json['id'],
      date: DateTime.parse(json['date']),
      isCompleted: json['isCompleted'],
      isCollapsed: json['isCollapsed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'isCompleted': isCompleted,
      'isCollapsed': isCollapsed,
    };
  }
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

  factory BookingSlot.fromJson(Map<String, dynamic> json) {
    return BookingSlot(
      id: json['id'],
      dayId: json['dayId'],
      time: json['time'],
      customerName: json['customerName'],
      note: json['note'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayId': dayId,
      'time': time,
      'customerName': customerName,
      'note': note,
    };
  }
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

  factory DefaultSlot.fromJson(Map<String, dynamic> json) {
    return DefaultSlot(
      id: json['id'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
    };
  }
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

@HiveType(typeId: 3)
class Employee extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  Employee({required this.id, required this.name});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 3;

  @override
  Employee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Employee(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }
}

@HiveType(typeId: 4)
class SalesDay extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  bool isCollapsed;

  SalesDay({
    required this.id,
    required this.date,
    this.isCollapsed = false,
  });

  factory SalesDay.fromJson(Map<String, dynamic> json) {
    return SalesDay(
      id: json['id'],
      date: DateTime.parse(json['date']),
      isCollapsed: json['isCollapsed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'isCollapsed': isCollapsed,
    };
  }
}

class SalesDayAdapter extends TypeAdapter<SalesDay> {
  @override
  final int typeId = 4;

  @override
  SalesDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return SalesDay(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      isCollapsed: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SalesDay obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.isCollapsed);
  }
}

@HiveType(typeId: 5)
class EmployeeSale extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String dayId;

  @HiveField(2)
  int employeeId;

  @HiveField(3)
  String employeeName;

  @HiveField(4)
  double amount;

  @HiveField(5)
  String? note;

  @HiveField(6)
  String category;

  @HiveField(7)
  int? categoryId;

  EmployeeSale({
    required this.id,
    required this.dayId,
    required this.employeeId,
    required this.employeeName,
    required this.amount,
    this.note,
    this.category = 'Nail',
    this.categoryId,
  });

  factory EmployeeSale.fromJson(Map<String, dynamic> json) {
    return EmployeeSale(
      id: json['id'],
      dayId: json['dayId'],
      employeeId: json['employeeId'] ?? 0,
      employeeName: json['employeeName'] ?? '',
      amount: (json['amount'] as num).toDouble(),
      note: json['note'],
      category: json['category'] ?? 'Nail',
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayId': dayId,
      'employeeId': employeeId,
      'employeeName': employeeName,
      'amount': amount,
      'note': note,
      'category': category,
      'categoryId': categoryId,
    };
  }
}

class EmployeeSaleAdapter extends TypeAdapter<EmployeeSale> {
  @override
  final int typeId = 5;

  @override
  EmployeeSale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return EmployeeSale(
      id: fields[0] as int,
      dayId: fields[1] as String,
      employeeId: fields[2] as int,
      employeeName: fields[3] as String,
      amount: (fields[4] as num).toDouble(),
      note: fields[5] as String?,
      category: (fields[6] as String?) ?? 'Nail',
      categoryId: fields[7] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, EmployeeSale obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dayId)
      ..writeByte(2)
      ..write(obj.employeeId)
      ..writeByte(3)
      ..write(obj.employeeName)
      ..writeByte(4)
      ..write(obj.amount)
      ..writeByte(5)
      ..write(obj.note)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.categoryId);
  }
}

@HiveType(typeId: 6)
class SaleCategory extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  bool isDefault;

  SaleCategory({
    required this.id,
    required this.name,
    this.isDefault = false,
  });

  factory SaleCategory.fromJson(Map<String, dynamic> json) {
    return SaleCategory(
      id: json['id'],
      name: json['name'],
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault,
    };
  }
}

class SaleCategoryAdapter extends TypeAdapter<SaleCategory> {
  @override
  final int typeId = 6;

  @override
  SaleCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return SaleCategory(
      id: fields[0] as int,
      name: fields[1] as String,
      isDefault: (fields[2] as bool?) ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, SaleCategory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isDefault);
  }
}

class AppDatabase {
  static const String _daysBox = 'booking_days';
  static const String _slotsBox = 'booking_slots';
  static const String _defaultsBox = 'default_slots';
  static const String _employeesBox = 'employees';
  static const String _categoriesBox = 'sale_categories';
  static const String _salesDaysBox = 'sales_days';
  static const String _salesRecordsBox = 'sales_records';
  static const String _countersBox = 'counters_box';

  static Future<void> init() async {
    // Initialize Hive (call this once before runApp)
    await Hive.initFlutter();

    // Register adapters if not registered
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(BookingDayAdapter());
    if (!Hive.isAdapterRegistered(1))
      Hive.registerAdapter(BookingSlotAdapter());
    if (!Hive.isAdapterRegistered(2))
      Hive.registerAdapter(DefaultSlotAdapter());
    if (!Hive.isAdapterRegistered(3))
      Hive.registerAdapter(EmployeeAdapter());
    if (!Hive.isAdapterRegistered(4))
      Hive.registerAdapter(SalesDayAdapter());
    if (!Hive.isAdapterRegistered(5))
      Hive.registerAdapter(EmployeeSaleAdapter());
    if (!Hive.isAdapterRegistered(6))
      Hive.registerAdapter(SaleCategoryAdapter());

    // Open boxes if not open
    if (!Hive.isBoxOpen(_daysBox)) await Hive.openBox<BookingDay>(_daysBox);
    if (!Hive.isBoxOpen(_slotsBox)) await Hive.openBox<BookingSlot>(_slotsBox);
    if (!Hive.isBoxOpen(_defaultsBox))
      await Hive.openBox<DefaultSlot>(_defaultsBox);
    if (!Hive.isBoxOpen(_employeesBox))
      await Hive.openBox<Employee>(_employeesBox);
    if (!Hive.isBoxOpen(_categoriesBox))
      await Hive.openBox<SaleCategory>(_categoriesBox);
    if (!Hive.isBoxOpen(_salesDaysBox))
      await Hive.openBox<SalesDay>(_salesDaysBox);
    if (!Hive.isBoxOpen(_salesRecordsBox))
      await Hive.openBox<EmployeeSale>(_salesRecordsBox);
    if (!Hive.isBoxOpen(_countersBox)) await Hive.openBox<int>(_countersBox);

    // Khởi tạo loại doanh số mặc định "Nail" nếu chưa có
    final catBox = Hive.box<SaleCategory>(_categoriesBox);
    if (catBox.isEmpty) {
      await catBox.put(1, SaleCategory(id: 1, name: 'Nail', isDefault: true));
      final counters = Hive.box<int>(_countersBox);
      final curCatId = counters.get('sale_category_id', defaultValue: 0) ?? 0;
      if (curCatId < 1) {
        await counters.put('sale_category_id', 1);
      }
    }

    // Tự động gán category = 'Nail' cho các bản ghi doanh số cũ chưa có category
    final salesBox = Hive.box<EmployeeSale>(_salesRecordsBox);
    for (final sale in salesBox.values) {
      bool changed = false;
      if (sale.category.isEmpty) {
        sale.category = 'Nail';
        changed = true;
      }
      if (sale.categoryId == null && sale.category.toLowerCase() == 'nail') {
        sale.categoryId = 1;
        changed = true;
      }
      if (changed) {
        await sale.save();
      }
    }
  }

  // Constructor assumes boxes already opened via init()
  AppDatabase() {
    _days = Hive.box<BookingDay>(_daysBox);
    _slots = Hive.box<BookingSlot>(_slotsBox);
    _defaults = Hive.box<DefaultSlot>(_defaultsBox);
    _employees = Hive.box<Employee>(_employeesBox);
    _categories = Hive.box<SaleCategory>(_categoriesBox);
    _salesDays = Hive.box<SalesDay>(_salesDaysBox);
    _salesRecords = Hive.box<EmployeeSale>(_salesRecordsBox);
    _counters = Hive.box<int>(_countersBox);
  }

  late final Box<BookingDay> _days;
  late final Box<BookingSlot> _slots;
  late final Box<DefaultSlot> _defaults;
  late final Box<Employee> _employees;
  late final Box<SaleCategory> _categories;
  late final Box<SalesDay> _salesDays;
  late final Box<EmployeeSale> _salesRecords;
  late final Box<int> _counters;

  int _nextId(String key) {
    final cur = _counters.get(key, defaultValue: 0) ?? 0;
    final nxt = cur + 1;
    _counters.put(key, nxt);
    return nxt;
  }

  // BookingDays
  Future<void> insertBookingDay(
      {required String id, required DateTime date}) async {
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
      return _days.values.cast<BookingDay?>().firstWhere((d) =>
          d != null &&
          d.date.year == dateOnly.year &&
          d.date.month == dateOnly.month &&
          d.date.day == dateOnly.day);
    } catch (e) {
      return null;
    }
  }

  Future<BookingDay?> getDayById(String id) async {
    return _days.get(id);
  }

  Future<void> updateBookingDay(String id,
      {DateTime? date, bool? isCompleted, bool? isCollapsed}) async {
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
  Future<int> insertBookingSlot(
      {required String dayId,
      required String time,
      String? customerName,
      String? note}) async {
    final newId = _nextId('slot_id');
    final slot = BookingSlot(
        id: newId,
        dayId: dayId,
        time: time,
        customerName: customerName,
        note: note);
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

  Future<void> updateBookingSlot(int id,
      {String? customerName, String? note, String? time}) async {
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

  Future<bool> slotExistsInDay(
      {required String dayId, required String time}) async {
    final found = _slots.values.any((s) => s.dayId == dayId && s.time == time);
    return found;
  }

  Future<bool> slotExistsInDayExcludingId(
      {required String dayId,
      required String time,
      required int excludeId}) async {
    final found = _slots.values
        .any((s) => s.dayId == dayId && s.time == time && s.id != excludeId);
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

  // Employees
  Future<int> insertEmployee({required String name}) async {
    final newId = _nextId('employee_id');
    final emp = Employee(id: newId, name: name);
    await _employees.put(newId, emp);
    return newId;
  }

  Future<List<Employee>> getAllEmployees() async {
    final list = _employees.values.toList();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  Future<void> deleteEmployee(int id) async {
    await _employees.delete(id);
  }

  Future<void> updateEmployee(int id, {required String name}) async {
    final emp = _employees.get(id);
    if (emp == null) return;
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw 'Lỗi: Tên nhân viên không được để trống.';
    emp.name = trimmed;
    await emp.save();

    // Đồng bộ tên nhân viên trong toàn bộ các bản ghi doanh số liên quan
    final records =
        _salesRecords.values.where((s) => s.employeeId == id).toList();
    for (final s in records) {
      s.employeeName = trimmed;
      await s.save();
    }
  }

  // SaleCategories
  Future<int> insertSaleCategory(
      {required String name, bool isDefault = false}) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw 'Lỗi: Tên loại doanh số không được để trống.';
    final existing = _categories.values
        .any((c) => c.name.toLowerCase() == trimmed.toLowerCase());
    if (existing) throw 'Lỗi: Loại doanh số "$trimmed" đã tồn tại.';

    final newId = _nextId('sale_category_id');
    final cat = SaleCategory(id: newId, name: trimmed, isDefault: isDefault);
    await _categories.put(newId, cat);
    return newId;
  }

  Future<List<SaleCategory>> getAllSaleCategories() async {
    final list = _categories.values.toList();
    list.sort((a, b) {
      if (a.isDefault && !b.isDefault) return -1;
      if (!a.isDefault && b.isDefault) return 1;
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return list;
  }

  Future<void> updateSaleCategory(int id, {required String name}) async {
    final cat = _categories.get(id);
    if (cat == null) return;
    final trimmed = name.trim();
    if (trimmed.isEmpty) throw 'Lỗi: Tên loại doanh số không được để trống.';

    final duplicate = _categories.values.any((c) =>
        c.id != id && c.name.toLowerCase() == trimmed.toLowerCase());
    if (duplicate) throw 'Lỗi: Loại doanh số "$trimmed" đã tồn tại.';

    final oldName = cat.name;
    cat.name = trimmed;
    await cat.save();

    // Đồng bộ tên loại doanh số trong tất cả bản ghi doanh số liên quan
    final records = _salesRecords.values
        .where((s) => s.categoryId == id || s.category == oldName)
        .toList();
    for (final s in records) {
      s.categoryId = id;
      s.category = trimmed;
      await s.save();
    }
  }

  Future<void> deleteSaleCategory(int id) async {
    final cat = _categories.get(id);
    if (cat == null) return;
    if (cat.isDefault || cat.name.toLowerCase() == 'nail') {
      throw 'Lỗi: Không thể xóa loại doanh số mặc định (Nail).';
    }

    SaleCategory? defaultCat;
    try {
      defaultCat = _categories.values.firstWhere((c) => c.isDefault);
    } catch (_) {
      try {
        defaultCat = _categories.values
            .firstWhere((c) => c.name.toLowerCase() == 'nail');
      } catch (_) {
        defaultCat = null;
      }
    }
    final fallbackName = defaultCat?.name ?? 'Nail';
    final fallbackId = defaultCat?.id ?? 1;

    final records = _salesRecords.values
        .where((s) => s.categoryId == id || s.category == cat.name)
        .toList();
    for (final s in records) {
      s.category = fallbackName;
      s.categoryId = fallbackId;
      await s.save();
    }

    await _categories.delete(id);
  }

  Future<SaleCategory?> getSaleCategoryById(int id) async => _categories.get(id);

  // SalesDays
  Future<void> insertSalesDay({required String id, required DateTime date}) async {
    final dOnly = DateTime(date.year, date.month, date.day);
    final day = SalesDay(id: id, date: dOnly);
    await _salesDays.put(id, day);
  }

  Future<List<SalesDay>> getAllSalesDays() async {
    final list = _salesDays.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date)); // mới nhất lên trước
    return list;
  }

  Future<SalesDay?> getSalesDayByDate(DateTime dateOnly) async {
    try {
      return _salesDays.values.cast<SalesDay?>().firstWhere((d) =>
          d != null &&
          d.date.year == dateOnly.year &&
          d.date.month == dateOnly.month &&
          d.date.day == dateOnly.day);
    } catch (e) {
      return null;
    }
  }

  Future<SalesDay?> getSalesDayById(String id) async {
    return _salesDays.get(id);
  }

  Future<void> updateSalesDay(String id, {DateTime? date, bool? isCollapsed}) async {
    final d = _salesDays.get(id);
    if (d == null) return;
    d.date = date ?? d.date;
    d.isCollapsed = isCollapsed ?? d.isCollapsed;
    await d.save();
  }

  Future<void> deleteSalesDay(String id) async {
    final toDelete = _salesRecords.values.where((s) => s.dayId == id).toList();
    for (final s in toDelete) {
      await _salesRecords.delete(s.id);
    }
    await _salesDays.delete(id);
  }

  // EmployeeSale
  Future<int> insertEmployeeSale({
    required String dayId,
    required int employeeId,
    required String employeeName,
    required double amount,
    String? note,
    String category = 'Nail',
    int? categoryId,
  }) async {
    final newId = _nextId('sale_id');
    final sale = EmployeeSale(
      id: newId,
      dayId: dayId,
      employeeId: employeeId,
      employeeName: employeeName,
      amount: amount,
      note: note,
      category: category,
      categoryId: categoryId,
    );
    await _salesRecords.put(newId, sale);
    return newId;
  }

  Future<List<EmployeeSale>> getSalesByDay(String dayId) async {
    final list = _salesRecords.values.where((s) => s.dayId == dayId).toList();
    list.sort((a, b) => a.employeeName.toLowerCase().compareTo(b.employeeName.toLowerCase()));
    return list;
  }

  Future<void> updateEmployeeSale(
    int id, {
    required int employeeId,
    required String employeeName,
    required double amount,
    String? note,
    String? category,
    int? categoryId,
  }) async {
    final s = _salesRecords.get(id);
    if (s == null) return;
    s.employeeId = employeeId;
    s.employeeName = employeeName;
    s.amount = amount;
    s.note = note;
    if (category != null) s.category = category;
    if (categoryId != null) s.categoryId = categoryId;
    await s.save();
  }

  Future<void> deleteEmployeeSale(int id) async {
    await _salesRecords.delete(id);
  }

  //export data
  Future<List<BookingDay>> exportBookingDays() async {
    return _days.values.toList();
  }

  Future<List<BookingSlot>> exportBookingSlots() async {
    return _slots.values.toList();
  }

  Future<List<DefaultSlot>> exportDefaultSlots() async {
    return _defaults.values.toList();
  }

  Future<List<Employee>> exportEmployees() async {
    return _employees.values.toList();
  }

  Future<List<SaleCategory>> exportSaleCategories() async {
    return _categories.values.toList();
  }

  Future<List<SalesDay>> exportSalesDays() async {
    return _salesDays.values.toList();
  }

  Future<List<EmployeeSale>> exportEmployeeSales() async {
    return _salesRecords.values.toList();
  }

  int getCounter(String key) => _counters.get(key, defaultValue: 0) ?? 0;

  //clear all
  Future<void> clearAll() async {
    await _days.clear();
    await _slots.clear();
    await _defaults.clear();
    await _employees.clear();
    await _categories.clear();
    await _salesDays.clear();
    await _salesRecords.clear();
    await _counters.clear();
  }

  //add
  Future<void> addDay(BookingDay day) async {
    return createOrUpdate(_days, day);
  }

  Future<void> addSlot(BookingSlot slot) async {
    return createOrUpdate(_slots, slot);
  }

  Future<void> addDefaultSlot(DefaultSlot slot) async {
    return createOrUpdate(_defaults, slot);
  }

  Future<void> addEmployee(Employee emp) async {
    return createOrUpdate(_employees, emp);
  }

  Future<void> addSaleCategory(SaleCategory cat) async {
    return createOrUpdate(_categories, cat);
  }

  Future<void> addSalesDay(SalesDay day) async {
    return createOrUpdate(_salesDays, day);
  }

  Future<void> addEmployeeSale(EmployeeSale sale) async {
    return createOrUpdate(_salesRecords, sale);
  }

  Future<void> setCounter(String key, int value) async =>
      _counters.put(key, value);

  Future<void> createOrUpdate(box, data) async {
    if (data.id != null) {
      await box.put(data.id, data);
    } else {
      await box.add(data);
    }
  }
}
