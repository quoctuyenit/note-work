// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BookingDaysTable extends BookingDays
    with TableInfo<$BookingDaysTable, BookingDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookingDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isCollapsedMeta =
      const VerificationMeta('isCollapsed');
  @override
  late final GeneratedColumn<bool> isCollapsed = GeneratedColumn<bool>(
      'is_collapsed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_collapsed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, date, isCompleted, isCollapsed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'booking_days';
  @override
  VerificationContext validateIntegrity(Insertable<BookingDay> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('is_collapsed')) {
      context.handle(
          _isCollapsedMeta,
          isCollapsed.isAcceptableOrUnknown(
              data['is_collapsed']!, _isCollapsedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookingDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookingDay(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      isCollapsed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_collapsed'])!,
    );
  }

  @override
  $BookingDaysTable createAlias(String alias) {
    return $BookingDaysTable(attachedDatabase, alias);
  }
}

class BookingDay extends DataClass implements Insertable<BookingDay> {
  final String id;
  final DateTime date;
  final bool isCompleted;
  final bool isCollapsed;
  const BookingDay(
      {required this.id,
      required this.date,
      required this.isCompleted,
      required this.isCollapsed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_collapsed'] = Variable<bool>(isCollapsed);
    return map;
  }

  BookingDaysCompanion toCompanion(bool nullToAbsent) {
    return BookingDaysCompanion(
      id: Value(id),
      date: Value(date),
      isCompleted: Value(isCompleted),
      isCollapsed: Value(isCollapsed),
    );
  }

  factory BookingDay.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookingDay(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isCollapsed: serializer.fromJson<bool>(json['isCollapsed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isCollapsed': serializer.toJson<bool>(isCollapsed),
    };
  }

  BookingDay copyWith(
          {String? id, DateTime? date, bool? isCompleted, bool? isCollapsed}) =>
      BookingDay(
        id: id ?? this.id,
        date: date ?? this.date,
        isCompleted: isCompleted ?? this.isCompleted,
        isCollapsed: isCollapsed ?? this.isCollapsed,
      );
  BookingDay copyWithCompanion(BookingDaysCompanion data) {
    return BookingDay(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      isCollapsed:
          data.isCollapsed.present ? data.isCollapsed.value : this.isCollapsed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookingDay(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isCollapsed: $isCollapsed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, isCompleted, isCollapsed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookingDay &&
          other.id == this.id &&
          other.date == this.date &&
          other.isCompleted == this.isCompleted &&
          other.isCollapsed == this.isCollapsed);
}

class BookingDaysCompanion extends UpdateCompanion<BookingDay> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<bool> isCompleted;
  final Value<bool> isCollapsed;
  final Value<int> rowid;
  const BookingDaysCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isCollapsed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookingDaysCompanion.insert({
    required String id,
    required DateTime date,
    this.isCompleted = const Value.absent(),
    this.isCollapsed = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        date = Value(date);
  static Insertable<BookingDay> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<bool>? isCompleted,
    Expression<bool>? isCollapsed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isCollapsed != null) 'is_collapsed': isCollapsed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookingDaysCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? date,
      Value<bool>? isCompleted,
      Value<bool>? isCollapsed,
      Value<int>? rowid}) {
    return BookingDaysCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isCollapsed.present) {
      map['is_collapsed'] = Variable<bool>(isCollapsed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookingDaysCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isCollapsed: $isCollapsed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookingSlotsTable extends BookingSlots
    with TableInfo<$BookingSlotsTable, BookingSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookingSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _dayIdMeta = const VerificationMeta('dayId');
  @override
  late final GeneratedColumn<String> dayId = GeneratedColumn<String>(
      'day_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES booking_days (id)'));
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _customerNameMeta =
      const VerificationMeta('customerName');
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
      'customer_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, dayId, time, customerName, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'booking_slots';
  @override
  VerificationContext validateIntegrity(Insertable<BookingSlot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_id')) {
      context.handle(
          _dayIdMeta, dayId.isAcceptableOrUnknown(data['day_id']!, _dayIdMeta));
    } else if (isInserting) {
      context.missing(_dayIdMeta);
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('customer_name')) {
      context.handle(
          _customerNameMeta,
          customerName.isAcceptableOrUnknown(
              data['customer_name']!, _customerNameMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookingSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookingSlot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      dayId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}day_id'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
      customerName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_name']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $BookingSlotsTable createAlias(String alias) {
    return $BookingSlotsTable(attachedDatabase, alias);
  }
}

class BookingSlot extends DataClass implements Insertable<BookingSlot> {
  final int id;
  final String dayId;
  final String time;
  final String? customerName;
  final String? note;
  const BookingSlot(
      {required this.id,
      required this.dayId,
      required this.time,
      this.customerName,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_id'] = Variable<String>(dayId);
    map['time'] = Variable<String>(time);
    if (!nullToAbsent || customerName != null) {
      map['customer_name'] = Variable<String>(customerName);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  BookingSlotsCompanion toCompanion(bool nullToAbsent) {
    return BookingSlotsCompanion(
      id: Value(id),
      dayId: Value(dayId),
      time: Value(time),
      customerName: customerName == null && nullToAbsent
          ? const Value.absent()
          : Value(customerName),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory BookingSlot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookingSlot(
      id: serializer.fromJson<int>(json['id']),
      dayId: serializer.fromJson<String>(json['dayId']),
      time: serializer.fromJson<String>(json['time']),
      customerName: serializer.fromJson<String?>(json['customerName']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayId': serializer.toJson<String>(dayId),
      'time': serializer.toJson<String>(time),
      'customerName': serializer.toJson<String?>(customerName),
      'note': serializer.toJson<String?>(note),
    };
  }

  BookingSlot copyWith(
          {int? id,
          String? dayId,
          String? time,
          Value<String?> customerName = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      BookingSlot(
        id: id ?? this.id,
        dayId: dayId ?? this.dayId,
        time: time ?? this.time,
        customerName:
            customerName.present ? customerName.value : this.customerName,
        note: note.present ? note.value : this.note,
      );
  BookingSlot copyWithCompanion(BookingSlotsCompanion data) {
    return BookingSlot(
      id: data.id.present ? data.id.value : this.id,
      dayId: data.dayId.present ? data.dayId.value : this.dayId,
      time: data.time.present ? data.time.value : this.time,
      customerName: data.customerName.present
          ? data.customerName.value
          : this.customerName,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookingSlot(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('time: $time, ')
          ..write('customerName: $customerName, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dayId, time, customerName, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookingSlot &&
          other.id == this.id &&
          other.dayId == this.dayId &&
          other.time == this.time &&
          other.customerName == this.customerName &&
          other.note == this.note);
}

class BookingSlotsCompanion extends UpdateCompanion<BookingSlot> {
  final Value<int> id;
  final Value<String> dayId;
  final Value<String> time;
  final Value<String?> customerName;
  final Value<String?> note;
  const BookingSlotsCompanion({
    this.id = const Value.absent(),
    this.dayId = const Value.absent(),
    this.time = const Value.absent(),
    this.customerName = const Value.absent(),
    this.note = const Value.absent(),
  });
  BookingSlotsCompanion.insert({
    this.id = const Value.absent(),
    required String dayId,
    required String time,
    this.customerName = const Value.absent(),
    this.note = const Value.absent(),
  })  : dayId = Value(dayId),
        time = Value(time);
  static Insertable<BookingSlot> custom({
    Expression<int>? id,
    Expression<String>? dayId,
    Expression<String>? time,
    Expression<String>? customerName,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayId != null) 'day_id': dayId,
      if (time != null) 'time': time,
      if (customerName != null) 'customer_name': customerName,
      if (note != null) 'note': note,
    });
  }

  BookingSlotsCompanion copyWith(
      {Value<int>? id,
      Value<String>? dayId,
      Value<String>? time,
      Value<String?>? customerName,
      Value<String?>? note}) {
    return BookingSlotsCompanion(
      id: id ?? this.id,
      dayId: dayId ?? this.dayId,
      time: time ?? this.time,
      customerName: customerName ?? this.customerName,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayId.present) {
      map['day_id'] = Variable<String>(dayId.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookingSlotsCompanion(')
          ..write('id: $id, ')
          ..write('dayId: $dayId, ')
          ..write('time: $time, ')
          ..write('customerName: $customerName, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $DefaultSlotsTable extends DefaultSlots
    with TableInfo<$DefaultSlotsTable, DefaultSlot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DefaultSlotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<String> time = GeneratedColumn<String>(
      'time', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, time];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'default_slots';
  @override
  VerificationContext validateIntegrity(Insertable<DefaultSlot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('time')) {
      context.handle(
          _timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DefaultSlot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DefaultSlot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      time: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}time'])!,
    );
  }

  @override
  $DefaultSlotsTable createAlias(String alias) {
    return $DefaultSlotsTable(attachedDatabase, alias);
  }
}

class DefaultSlot extends DataClass implements Insertable<DefaultSlot> {
  final int id;
  final String time;
  const DefaultSlot({required this.id, required this.time});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['time'] = Variable<String>(time);
    return map;
  }

  DefaultSlotsCompanion toCompanion(bool nullToAbsent) {
    return DefaultSlotsCompanion(
      id: Value(id),
      time: Value(time),
    );
  }

  factory DefaultSlot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DefaultSlot(
      id: serializer.fromJson<int>(json['id']),
      time: serializer.fromJson<String>(json['time']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'time': serializer.toJson<String>(time),
    };
  }

  DefaultSlot copyWith({int? id, String? time}) => DefaultSlot(
        id: id ?? this.id,
        time: time ?? this.time,
      );
  DefaultSlot copyWithCompanion(DefaultSlotsCompanion data) {
    return DefaultSlot(
      id: data.id.present ? data.id.value : this.id,
      time: data.time.present ? data.time.value : this.time,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DefaultSlot(')
          ..write('id: $id, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, time);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DefaultSlot && other.id == this.id && other.time == this.time);
}

class DefaultSlotsCompanion extends UpdateCompanion<DefaultSlot> {
  final Value<int> id;
  final Value<String> time;
  const DefaultSlotsCompanion({
    this.id = const Value.absent(),
    this.time = const Value.absent(),
  });
  DefaultSlotsCompanion.insert({
    this.id = const Value.absent(),
    required String time,
  }) : time = Value(time);
  static Insertable<DefaultSlot> custom({
    Expression<int>? id,
    Expression<String>? time,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (time != null) 'time': time,
    });
  }

  DefaultSlotsCompanion copyWith({Value<int>? id, Value<String>? time}) {
    return DefaultSlotsCompanion(
      id: id ?? this.id,
      time: time ?? this.time,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (time.present) {
      map['time'] = Variable<String>(time.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DefaultSlotsCompanion(')
          ..write('id: $id, ')
          ..write('time: $time')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BookingDaysTable bookingDays = $BookingDaysTable(this);
  late final $BookingSlotsTable bookingSlots = $BookingSlotsTable(this);
  late final $DefaultSlotsTable defaultSlots = $DefaultSlotsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [bookingDays, bookingSlots, defaultSlots];
}

typedef $$BookingDaysTableCreateCompanionBuilder = BookingDaysCompanion
    Function({
  required String id,
  required DateTime date,
  Value<bool> isCompleted,
  Value<bool> isCollapsed,
  Value<int> rowid,
});
typedef $$BookingDaysTableUpdateCompanionBuilder = BookingDaysCompanion
    Function({
  Value<String> id,
  Value<DateTime> date,
  Value<bool> isCompleted,
  Value<bool> isCollapsed,
  Value<int> rowid,
});

final class $$BookingDaysTableReferences
    extends BaseReferences<_$AppDatabase, $BookingDaysTable, BookingDay> {
  $$BookingDaysTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BookingSlotsTable, List<BookingSlot>>
      _bookingSlotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.bookingSlots,
          aliasName:
              $_aliasNameGenerator(db.bookingDays.id, db.bookingSlots.dayId));

  $$BookingSlotsTableProcessedTableManager get bookingSlotsRefs {
    final manager = $$BookingSlotsTableTableManager($_db, $_db.bookingSlots)
        .filter((f) => f.dayId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookingSlotsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$BookingDaysTableFilterComposer
    extends Composer<_$AppDatabase, $BookingDaysTable> {
  $$BookingDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCollapsed => $composableBuilder(
      column: $table.isCollapsed, builder: (column) => ColumnFilters(column));

  Expression<bool> bookingSlotsRefs(
      Expression<bool> Function($$BookingSlotsTableFilterComposer f) f) {
    final $$BookingSlotsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookingSlots,
        getReferencedColumn: (t) => t.dayId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingSlotsTableFilterComposer(
              $db: $db,
              $table: $db.bookingSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BookingDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $BookingDaysTable> {
  $$BookingDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCollapsed => $composableBuilder(
      column: $table.isCollapsed, builder: (column) => ColumnOrderings(column));
}

class $$BookingDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookingDaysTable> {
  $$BookingDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<bool> get isCollapsed => $composableBuilder(
      column: $table.isCollapsed, builder: (column) => column);

  Expression<T> bookingSlotsRefs<T extends Object>(
      Expression<T> Function($$BookingSlotsTableAnnotationComposer a) f) {
    final $$BookingSlotsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.bookingSlots,
        getReferencedColumn: (t) => t.dayId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingSlotsTableAnnotationComposer(
              $db: $db,
              $table: $db.bookingSlots,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$BookingDaysTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookingDaysTable,
    BookingDay,
    $$BookingDaysTableFilterComposer,
    $$BookingDaysTableOrderingComposer,
    $$BookingDaysTableAnnotationComposer,
    $$BookingDaysTableCreateCompanionBuilder,
    $$BookingDaysTableUpdateCompanionBuilder,
    (BookingDay, $$BookingDaysTableReferences),
    BookingDay,
    PrefetchHooks Function({bool bookingSlotsRefs})> {
  $$BookingDaysTableTableManager(_$AppDatabase db, $BookingDaysTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookingDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookingDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookingDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<bool> isCollapsed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookingDaysCompanion(
            id: id,
            date: date,
            isCompleted: isCompleted,
            isCollapsed: isCollapsed,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime date,
            Value<bool> isCompleted = const Value.absent(),
            Value<bool> isCollapsed = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BookingDaysCompanion.insert(
            id: id,
            date: date,
            isCompleted: isCompleted,
            isCollapsed: isCollapsed,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BookingDaysTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({bookingSlotsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (bookingSlotsRefs) db.bookingSlots],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (bookingSlotsRefs)
                    await $_getPrefetchedData<BookingDay, $BookingDaysTable,
                            BookingSlot>(
                        currentTable: table,
                        referencedTable: $$BookingDaysTableReferences
                            ._bookingSlotsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$BookingDaysTableReferences(db, table, p0)
                                .bookingSlotsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.dayId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$BookingDaysTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookingDaysTable,
    BookingDay,
    $$BookingDaysTableFilterComposer,
    $$BookingDaysTableOrderingComposer,
    $$BookingDaysTableAnnotationComposer,
    $$BookingDaysTableCreateCompanionBuilder,
    $$BookingDaysTableUpdateCompanionBuilder,
    (BookingDay, $$BookingDaysTableReferences),
    BookingDay,
    PrefetchHooks Function({bool bookingSlotsRefs})>;
typedef $$BookingSlotsTableCreateCompanionBuilder = BookingSlotsCompanion
    Function({
  Value<int> id,
  required String dayId,
  required String time,
  Value<String?> customerName,
  Value<String?> note,
});
typedef $$BookingSlotsTableUpdateCompanionBuilder = BookingSlotsCompanion
    Function({
  Value<int> id,
  Value<String> dayId,
  Value<String> time,
  Value<String?> customerName,
  Value<String?> note,
});

final class $$BookingSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $BookingSlotsTable, BookingSlot> {
  $$BookingSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BookingDaysTable _dayIdTable(_$AppDatabase db) =>
      db.bookingDays.createAlias(
          $_aliasNameGenerator(db.bookingSlots.dayId, db.bookingDays.id));

  $$BookingDaysTableProcessedTableManager get dayId {
    final $_column = $_itemColumn<String>('day_id')!;

    final manager = $$BookingDaysTableTableManager($_db, $_db.bookingDays)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$BookingSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $BookingSlotsTable> {
  $$BookingSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  $$BookingDaysTableFilterComposer get dayId {
    final $$BookingDaysTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayId,
        referencedTable: $db.bookingDays,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingDaysTableFilterComposer(
              $db: $db,
              $table: $db.bookingDays,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookingSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $BookingSlotsTable> {
  $$BookingSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get customerName => $composableBuilder(
      column: $table.customerName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  $$BookingDaysTableOrderingComposer get dayId {
    final $$BookingDaysTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayId,
        referencedTable: $db.bookingDays,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingDaysTableOrderingComposer(
              $db: $db,
              $table: $db.bookingDays,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookingSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookingSlotsTable> {
  $$BookingSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
      column: $table.customerName, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$BookingDaysTableAnnotationComposer get dayId {
    final $$BookingDaysTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.dayId,
        referencedTable: $db.bookingDays,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$BookingDaysTableAnnotationComposer(
              $db: $db,
              $table: $db.bookingDays,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$BookingSlotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookingSlotsTable,
    BookingSlot,
    $$BookingSlotsTableFilterComposer,
    $$BookingSlotsTableOrderingComposer,
    $$BookingSlotsTableAnnotationComposer,
    $$BookingSlotsTableCreateCompanionBuilder,
    $$BookingSlotsTableUpdateCompanionBuilder,
    (BookingSlot, $$BookingSlotsTableReferences),
    BookingSlot,
    PrefetchHooks Function({bool dayId})> {
  $$BookingSlotsTableTableManager(_$AppDatabase db, $BookingSlotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookingSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookingSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookingSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> dayId = const Value.absent(),
            Value<String> time = const Value.absent(),
            Value<String?> customerName = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              BookingSlotsCompanion(
            id: id,
            dayId: dayId,
            time: time,
            customerName: customerName,
            note: note,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String dayId,
            required String time,
            Value<String?> customerName = const Value.absent(),
            Value<String?> note = const Value.absent(),
          }) =>
              BookingSlotsCompanion.insert(
            id: id,
            dayId: dayId,
            time: time,
            customerName: customerName,
            note: note,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$BookingSlotsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({dayId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (dayId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.dayId,
                    referencedTable:
                        $$BookingSlotsTableReferences._dayIdTable(db),
                    referencedColumn:
                        $$BookingSlotsTableReferences._dayIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$BookingSlotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BookingSlotsTable,
    BookingSlot,
    $$BookingSlotsTableFilterComposer,
    $$BookingSlotsTableOrderingComposer,
    $$BookingSlotsTableAnnotationComposer,
    $$BookingSlotsTableCreateCompanionBuilder,
    $$BookingSlotsTableUpdateCompanionBuilder,
    (BookingSlot, $$BookingSlotsTableReferences),
    BookingSlot,
    PrefetchHooks Function({bool dayId})>;
typedef $$DefaultSlotsTableCreateCompanionBuilder = DefaultSlotsCompanion
    Function({
  Value<int> id,
  required String time,
});
typedef $$DefaultSlotsTableUpdateCompanionBuilder = DefaultSlotsCompanion
    Function({
  Value<int> id,
  Value<String> time,
});

class $$DefaultSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $DefaultSlotsTable> {
  $$DefaultSlotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnFilters(column));
}

class $$DefaultSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $DefaultSlotsTable> {
  $$DefaultSlotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get time => $composableBuilder(
      column: $table.time, builder: (column) => ColumnOrderings(column));
}

class $$DefaultSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DefaultSlotsTable> {
  $$DefaultSlotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get time =>
      $composableBuilder(column: $table.time, builder: (column) => column);
}

class $$DefaultSlotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DefaultSlotsTable,
    DefaultSlot,
    $$DefaultSlotsTableFilterComposer,
    $$DefaultSlotsTableOrderingComposer,
    $$DefaultSlotsTableAnnotationComposer,
    $$DefaultSlotsTableCreateCompanionBuilder,
    $$DefaultSlotsTableUpdateCompanionBuilder,
    (
      DefaultSlot,
      BaseReferences<_$AppDatabase, $DefaultSlotsTable, DefaultSlot>
    ),
    DefaultSlot,
    PrefetchHooks Function()> {
  $$DefaultSlotsTableTableManager(_$AppDatabase db, $DefaultSlotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DefaultSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DefaultSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DefaultSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> time = const Value.absent(),
          }) =>
              DefaultSlotsCompanion(
            id: id,
            time: time,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String time,
          }) =>
              DefaultSlotsCompanion.insert(
            id: id,
            time: time,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DefaultSlotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DefaultSlotsTable,
    DefaultSlot,
    $$DefaultSlotsTableFilterComposer,
    $$DefaultSlotsTableOrderingComposer,
    $$DefaultSlotsTableAnnotationComposer,
    $$DefaultSlotsTableCreateCompanionBuilder,
    $$DefaultSlotsTableUpdateCompanionBuilder,
    (
      DefaultSlot,
      BaseReferences<_$AppDatabase, $DefaultSlotsTable, DefaultSlot>
    ),
    DefaultSlot,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BookingDaysTableTableManager get bookingDays =>
      $$BookingDaysTableTableManager(_db, _db.bookingDays);
  $$BookingSlotsTableTableManager get bookingSlots =>
      $$BookingSlotsTableTableManager(_db, _db.bookingSlots);
  $$DefaultSlotsTableTableManager get defaultSlots =>
      $$DefaultSlotsTableTableManager(_db, _db.defaultSlots);
}
