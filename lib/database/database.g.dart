// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BeveragesTable extends Beverages
    with TableInfo<$BeveragesTable, Beverage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeveragesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorCodeMeta =
      const VerificationMeta('colorCode');
  @override
  late final GeneratedColumn<String> colorCode = GeneratedColumn<String>(
      'color_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 8, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _waterPercentMeta =
      const VerificationMeta('waterPercent');
  @override
  late final GeneratedColumn<int> waterPercent = GeneratedColumn<int>(
      'water_percent', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _starredMeta =
      const VerificationMeta('starred');
  @override
  late final GeneratedColumn<bool> starred = GeneratedColumn<bool>(
      'starred', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("starred" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, colorCode, waterPercent, starred];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'beverages';
  @override
  VerificationContext validateIntegrity(Insertable<Beverage> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color_code')) {
      context.handle(_colorCodeMeta,
          colorCode.isAcceptableOrUnknown(data['color_code']!, _colorCodeMeta));
    } else if (isInserting) {
      context.missing(_colorCodeMeta);
    }
    if (data.containsKey('water_percent')) {
      context.handle(
          _waterPercentMeta,
          waterPercent.isAcceptableOrUnknown(
              data['water_percent']!, _waterPercentMeta));
    } else if (isInserting) {
      context.missing(_waterPercentMeta);
    }
    if (data.containsKey('starred')) {
      context.handle(_starredMeta,
          starred.isAcceptableOrUnknown(data['starred']!, _starredMeta));
    } else if (isInserting) {
      context.missing(_starredMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Beverage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Beverage(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      colorCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_code'])!,
      waterPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}water_percent'])!,
      starred: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}starred'])!,
    );
  }

  @override
  $BeveragesTable createAlias(String alias) {
    return $BeveragesTable(attachedDatabase, alias);
  }
}

class Beverage extends DataClass implements Insertable<Beverage> {
  final int id;
  final String name;
  final String colorCode;
  final int waterPercent;
  final bool starred;
  const Beverage(
      {required this.id,
      required this.name,
      required this.colorCode,
      required this.waterPercent,
      required this.starred});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['color_code'] = Variable<String>(colorCode);
    map['water_percent'] = Variable<int>(waterPercent);
    map['starred'] = Variable<bool>(starred);
    return map;
  }

  BeveragesCompanion toCompanion(bool nullToAbsent) {
    return BeveragesCompanion(
      id: Value(id),
      name: Value(name),
      colorCode: Value(colorCode),
      waterPercent: Value(waterPercent),
      starred: Value(starred),
    );
  }

  factory Beverage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Beverage(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      colorCode: serializer.fromJson<String>(json['colorCode']),
      waterPercent: serializer.fromJson<int>(json['waterPercent']),
      starred: serializer.fromJson<bool>(json['starred']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'colorCode': serializer.toJson<String>(colorCode),
      'waterPercent': serializer.toJson<int>(waterPercent),
      'starred': serializer.toJson<bool>(starred),
    };
  }

  Beverage copyWith(
          {int? id,
          String? name,
          String? colorCode,
          int? waterPercent,
          bool? starred}) =>
      Beverage(
        id: id ?? this.id,
        name: name ?? this.name,
        colorCode: colorCode ?? this.colorCode,
        waterPercent: waterPercent ?? this.waterPercent,
        starred: starred ?? this.starred,
      );
  @override
  String toString() {
    return (StringBuffer('Beverage(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorCode: $colorCode, ')
          ..write('waterPercent: $waterPercent, ')
          ..write('starred: $starred')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, colorCode, waterPercent, starred);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Beverage &&
          other.id == this.id &&
          other.name == this.name &&
          other.colorCode == this.colorCode &&
          other.waterPercent == this.waterPercent &&
          other.starred == this.starred);
}

class BeveragesCompanion extends UpdateCompanion<Beverage> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> colorCode;
  final Value<int> waterPercent;
  final Value<bool> starred;
  const BeveragesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.colorCode = const Value.absent(),
    this.waterPercent = const Value.absent(),
    this.starred = const Value.absent(),
  });
  BeveragesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String colorCode,
    required int waterPercent,
    required bool starred,
  })  : name = Value(name),
        colorCode = Value(colorCode),
        waterPercent = Value(waterPercent),
        starred = Value(starred);
  static Insertable<Beverage> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? colorCode,
    Expression<int>? waterPercent,
    Expression<bool>? starred,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (colorCode != null) 'color_code': colorCode,
      if (waterPercent != null) 'water_percent': waterPercent,
      if (starred != null) 'starred': starred,
    });
  }

  BeveragesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? colorCode,
      Value<int>? waterPercent,
      Value<bool>? starred}) {
    return BeveragesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      colorCode: colorCode ?? this.colorCode,
      waterPercent: waterPercent ?? this.waterPercent,
      starred: starred ?? this.starred,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (colorCode.present) {
      map['color_code'] = Variable<String>(colorCode.value);
    }
    if (waterPercent.present) {
      map['water_percent'] = Variable<int>(waterPercent.value);
    }
    if (starred.present) {
      map['starred'] = Variable<bool>(starred.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeveragesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('colorCode: $colorCode, ')
          ..write('waterPercent: $waterPercent, ')
          ..write('starred: $starred')
          ..write(')'))
        .toString();
  }
}

class $DrinksTable extends Drinks with TableInfo<$DrinksTable, Drink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bevIDMeta = const VerificationMeta('bevID');
  @override
  late final GeneratedColumn<int> bevID = GeneratedColumn<int>(
      'bev_ID', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES beverages (id)'));
  static const VerificationMeta _volumeMeta = const VerificationMeta('volume');
  @override
  late final GeneratedColumn<int> volume = GeneratedColumn<int>(
      'volume', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _datetimeMeta =
      const VerificationMeta('datetime');
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'datetime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, bevID, volume, datetime];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drinks';
  @override
  VerificationContext validateIntegrity(Insertable<Drink> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bev_ID')) {
      context.handle(
          _bevIDMeta, bevID.isAcceptableOrUnknown(data['bev_ID']!, _bevIDMeta));
    } else if (isInserting) {
      context.missing(_bevIDMeta);
    }
    if (data.containsKey('volume')) {
      context.handle(_volumeMeta,
          volume.isAcceptableOrUnknown(data['volume']!, _volumeMeta));
    } else if (isInserting) {
      context.missing(_volumeMeta);
    }
    if (data.containsKey('datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Drink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Drink(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bevID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bev_ID'])!,
      volume: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}volume'])!,
      datetime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}datetime'])!,
    );
  }

  @override
  $DrinksTable createAlias(String alias) {
    return $DrinksTable(attachedDatabase, alias);
  }
}

class Drink extends DataClass implements Insertable<Drink> {
  final int id;
  final int bevID;
  final int volume;
  final DateTime datetime;
  const Drink(
      {required this.id,
      required this.bevID,
      required this.volume,
      required this.datetime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bev_ID'] = Variable<int>(bevID);
    map['volume'] = Variable<int>(volume);
    map['datetime'] = Variable<DateTime>(datetime);
    return map;
  }

  DrinksCompanion toCompanion(bool nullToAbsent) {
    return DrinksCompanion(
      id: Value(id),
      bevID: Value(bevID),
      volume: Value(volume),
      datetime: Value(datetime),
    );
  }

  factory Drink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Drink(
      id: serializer.fromJson<int>(json['id']),
      bevID: serializer.fromJson<int>(json['bevID']),
      volume: serializer.fromJson<int>(json['volume']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bevID': serializer.toJson<int>(bevID),
      'volume': serializer.toJson<int>(volume),
      'datetime': serializer.toJson<DateTime>(datetime),
    };
  }

  Drink copyWith({int? id, int? bevID, int? volume, DateTime? datetime}) =>
      Drink(
        id: id ?? this.id,
        bevID: bevID ?? this.bevID,
        volume: volume ?? this.volume,
        datetime: datetime ?? this.datetime,
      );
  @override
  String toString() {
    return (StringBuffer('Drink(')
          ..write('id: $id, ')
          ..write('bevID: $bevID, ')
          ..write('volume: $volume, ')
          ..write('datetime: $datetime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bevID, volume, datetime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Drink &&
          other.id == this.id &&
          other.bevID == this.bevID &&
          other.volume == this.volume &&
          other.datetime == this.datetime);
}

class DrinksCompanion extends UpdateCompanion<Drink> {
  final Value<int> id;
  final Value<int> bevID;
  final Value<int> volume;
  final Value<DateTime> datetime;
  const DrinksCompanion({
    this.id = const Value.absent(),
    this.bevID = const Value.absent(),
    this.volume = const Value.absent(),
    this.datetime = const Value.absent(),
  });
  DrinksCompanion.insert({
    this.id = const Value.absent(),
    required int bevID,
    required int volume,
    required DateTime datetime,
  })  : bevID = Value(bevID),
        volume = Value(volume),
        datetime = Value(datetime);
  static Insertable<Drink> custom({
    Expression<int>? id,
    Expression<int>? bevID,
    Expression<int>? volume,
    Expression<DateTime>? datetime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bevID != null) 'bev_ID': bevID,
      if (volume != null) 'volume': volume,
      if (datetime != null) 'datetime': datetime,
    });
  }

  DrinksCompanion copyWith(
      {Value<int>? id,
      Value<int>? bevID,
      Value<int>? volume,
      Value<DateTime>? datetime}) {
    return DrinksCompanion(
      id: id ?? this.id,
      bevID: bevID ?? this.bevID,
      volume: volume ?? this.volume,
      datetime: datetime ?? this.datetime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bevID.present) {
      map['bev_ID'] = Variable<int>(bevID.value);
    }
    if (volume.present) {
      map['volume'] = Variable<int>(volume.value);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrinksCompanion(')
          ..write('id: $id, ')
          ..write('bevID: $bevID, ')
          ..write('volume: $volume, ')
          ..write('datetime: $datetime')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 25),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _metMeta = const VerificationMeta('met');
  @override
  late final GeneratedColumn<double> met = GeneratedColumn<double>(
      'MET', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, category, met, description];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(Insertable<Activity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('MET')) {
      context.handle(
          _metMeta, met.isAcceptableOrUnknown(data['MET']!, _metMeta));
    } else if (isInserting) {
      context.missing(_metMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      met: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}MET'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class Activity extends DataClass implements Insertable<Activity> {
  final int id;
  final String category;
  final double met;
  final String description;
  const Activity(
      {required this.id,
      required this.category,
      required this.met,
      required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['MET'] = Variable<double>(met);
    map['description'] = Variable<String>(description);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      category: Value(category),
      met: Value(met),
      description: Value(description),
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      met: serializer.fromJson<double>(json['met']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'met': serializer.toJson<double>(met),
      'description': serializer.toJson<String>(description),
    };
  }

  Activity copyWith(
          {int? id, String? category, double? met, String? description}) =>
      Activity(
        id: id ?? this.id,
        category: category ?? this.category,
        met: met ?? this.met,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('met: $met, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, category, met, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.category == this.category &&
          other.met == this.met &&
          other.description == this.description);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> id;
  final Value<String> category;
  final Value<double> met;
  final Value<String> description;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.met = const Value.absent(),
    this.description = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required double met,
    required String description,
  })  : category = Value(category),
        met = Value(met),
        description = Value(description);
  static Insertable<Activity> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<double>? met,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (met != null) 'MET': met,
      if (description != null) 'description': description,
    });
  }

  ActivitiesCompanion copyWith(
      {Value<int>? id,
      Value<String>? category,
      Value<double>? met,
      Value<String>? description}) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      met: met ?? this.met,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (met.present) {
      map['MET'] = Variable<double>(met.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('met: $met, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _activityIDMeta =
      const VerificationMeta('activityID');
  @override
  late final GeneratedColumn<int> activityID = GeneratedColumn<int>(
      'activity_ID', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES activities (id)'));
  static const VerificationMeta _datetimeMeta =
      const VerificationMeta('datetime');
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'datetime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<int> duration = GeneratedColumn<int>(
      'duration', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _waterLossMeta =
      const VerificationMeta('waterLoss');
  @override
  late final GeneratedColumn<int> waterLoss = GeneratedColumn<int>(
      'water_loss', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, activityID, datetime, duration, waterLoss];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(Insertable<Workout> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('activity_ID')) {
      context.handle(
          _activityIDMeta,
          activityID.isAcceptableOrUnknown(
              data['activity_ID']!, _activityIDMeta));
    } else if (isInserting) {
      context.missing(_activityIDMeta);
    }
    if (data.containsKey('datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('water_loss')) {
      context.handle(_waterLossMeta,
          waterLoss.isAcceptableOrUnknown(data['water_loss']!, _waterLossMeta));
    } else if (isInserting) {
      context.missing(_waterLossMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      activityID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activity_ID'])!,
      datetime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}datetime'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
      waterLoss: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}water_loss'])!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final int id;
  final int activityID;
  final DateTime datetime;
  final int duration;
  final int waterLoss;
  const Workout(
      {required this.id,
      required this.activityID,
      required this.datetime,
      required this.duration,
      required this.waterLoss});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['activity_ID'] = Variable<int>(activityID);
    map['datetime'] = Variable<DateTime>(datetime);
    map['duration'] = Variable<int>(duration);
    map['water_loss'] = Variable<int>(waterLoss);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      activityID: Value(activityID),
      datetime: Value(datetime),
      duration: Value(duration),
      waterLoss: Value(waterLoss),
    );
  }

  factory Workout.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<int>(json['id']),
      activityID: serializer.fromJson<int>(json['activityID']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
      duration: serializer.fromJson<int>(json['duration']),
      waterLoss: serializer.fromJson<int>(json['waterLoss']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'activityID': serializer.toJson<int>(activityID),
      'datetime': serializer.toJson<DateTime>(datetime),
      'duration': serializer.toJson<int>(duration),
      'waterLoss': serializer.toJson<int>(waterLoss),
    };
  }

  Workout copyWith(
          {int? id,
          int? activityID,
          DateTime? datetime,
          int? duration,
          int? waterLoss}) =>
      Workout(
        id: id ?? this.id,
        activityID: activityID ?? this.activityID,
        datetime: datetime ?? this.datetime,
        duration: duration ?? this.duration,
        waterLoss: waterLoss ?? this.waterLoss,
      );
  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('activityID: $activityID, ')
          ..write('datetime: $datetime, ')
          ..write('duration: $duration, ')
          ..write('waterLoss: $waterLoss')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, activityID, datetime, duration, waterLoss);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.activityID == this.activityID &&
          other.datetime == this.datetime &&
          other.duration == this.duration &&
          other.waterLoss == this.waterLoss);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<int> id;
  final Value<int> activityID;
  final Value<DateTime> datetime;
  final Value<int> duration;
  final Value<int> waterLoss;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.activityID = const Value.absent(),
    this.datetime = const Value.absent(),
    this.duration = const Value.absent(),
    this.waterLoss = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required int activityID,
    required DateTime datetime,
    required int duration,
    required int waterLoss,
  })  : activityID = Value(activityID),
        datetime = Value(datetime),
        duration = Value(duration),
        waterLoss = Value(waterLoss);
  static Insertable<Workout> custom({
    Expression<int>? id,
    Expression<int>? activityID,
    Expression<DateTime>? datetime,
    Expression<int>? duration,
    Expression<int>? waterLoss,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activityID != null) 'activity_ID': activityID,
      if (datetime != null) 'datetime': datetime,
      if (duration != null) 'duration': duration,
      if (waterLoss != null) 'water_loss': waterLoss,
    });
  }

  WorkoutsCompanion copyWith(
      {Value<int>? id,
      Value<int>? activityID,
      Value<DateTime>? datetime,
      Value<int>? duration,
      Value<int>? waterLoss}) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      activityID: activityID ?? this.activityID,
      datetime: datetime ?? this.datetime,
      duration: duration ?? this.duration,
      waterLoss: waterLoss ?? this.waterLoss,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (activityID.present) {
      map['activity_ID'] = Variable<int>(activityID.value);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (duration.present) {
      map['duration'] = Variable<int>(duration.value);
    }
    if (waterLoss.present) {
      map['water_loss'] = Variable<int>(waterLoss.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('activityID: $activityID, ')
          ..write('datetime: $datetime, ')
          ..write('duration: $duration, ')
          ..write('waterLoss: $waterLoss')
          ..write(')'))
        .toString();
  }
}

class $WaterGoalsTable extends WaterGoals
    with TableInfo<$WaterGoalsTable, WaterGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalVolumeMeta =
      const VerificationMeta('totalVolume');
  @override
  late final GeneratedColumn<int> totalVolume = GeneratedColumn<int>(
      'total_volume', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _consumedVolumeMeta =
      const VerificationMeta('consumedVolume');
  @override
  late final GeneratedColumn<int> consumedVolume = GeneratedColumn<int>(
      'consumed_volume', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _reminderGapMeta =
      const VerificationMeta('reminderGap');
  @override
  late final GeneratedColumn<int> reminderGap = GeneratedColumn<int>(
      'reminder_gap', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [date, totalVolume, consumedVolume, reminderGap];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_goals';
  @override
  VerificationContext validateIntegrity(Insertable<WaterGoal> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_volume')) {
      context.handle(
          _totalVolumeMeta,
          totalVolume.isAcceptableOrUnknown(
              data['total_volume']!, _totalVolumeMeta));
    } else if (isInserting) {
      context.missing(_totalVolumeMeta);
    }
    if (data.containsKey('consumed_volume')) {
      context.handle(
          _consumedVolumeMeta,
          consumedVolume.isAcceptableOrUnknown(
              data['consumed_volume']!, _consumedVolumeMeta));
    } else if (isInserting) {
      context.missing(_consumedVolumeMeta);
    }
    if (data.containsKey('reminder_gap')) {
      context.handle(
          _reminderGapMeta,
          reminderGap.isAcceptableOrUnknown(
              data['reminder_gap']!, _reminderGapMeta));
    } else if (isInserting) {
      context.missing(_reminderGapMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  WaterGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterGoal(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalVolume: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}total_volume'])!,
      consumedVolume: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}consumed_volume'])!,
      reminderGap: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reminder_gap'])!,
    );
  }

  @override
  $WaterGoalsTable createAlias(String alias) {
    return $WaterGoalsTable(attachedDatabase, alias);
  }
}

class WaterGoal extends DataClass implements Insertable<WaterGoal> {
  final DateTime date;
  final int totalVolume;
  final int consumedVolume;
  final int reminderGap;
  const WaterGoal(
      {required this.date,
      required this.totalVolume,
      required this.consumedVolume,
      required this.reminderGap});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['total_volume'] = Variable<int>(totalVolume);
    map['consumed_volume'] = Variable<int>(consumedVolume);
    map['reminder_gap'] = Variable<int>(reminderGap);
    return map;
  }

  WaterGoalsCompanion toCompanion(bool nullToAbsent) {
    return WaterGoalsCompanion(
      date: Value(date),
      totalVolume: Value(totalVolume),
      consumedVolume: Value(consumedVolume),
      reminderGap: Value(reminderGap),
    );
  }

  factory WaterGoal.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterGoal(
      date: serializer.fromJson<DateTime>(json['date']),
      totalVolume: serializer.fromJson<int>(json['totalVolume']),
      consumedVolume: serializer.fromJson<int>(json['consumedVolume']),
      reminderGap: serializer.fromJson<int>(json['reminderGap']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'totalVolume': serializer.toJson<int>(totalVolume),
      'consumedVolume': serializer.toJson<int>(consumedVolume),
      'reminderGap': serializer.toJson<int>(reminderGap),
    };
  }

  WaterGoal copyWith(
          {DateTime? date,
          int? totalVolume,
          int? consumedVolume,
          int? reminderGap}) =>
      WaterGoal(
        date: date ?? this.date,
        totalVolume: totalVolume ?? this.totalVolume,
        consumedVolume: consumedVolume ?? this.consumedVolume,
        reminderGap: reminderGap ?? this.reminderGap,
      );
  @override
  String toString() {
    return (StringBuffer('WaterGoal(')
          ..write('date: $date, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('consumedVolume: $consumedVolume, ')
          ..write('reminderGap: $reminderGap')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(date, totalVolume, consumedVolume, reminderGap);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterGoal &&
          other.date == this.date &&
          other.totalVolume == this.totalVolume &&
          other.consumedVolume == this.consumedVolume &&
          other.reminderGap == this.reminderGap);
}

class WaterGoalsCompanion extends UpdateCompanion<WaterGoal> {
  final Value<DateTime> date;
  final Value<int> totalVolume;
  final Value<int> consumedVolume;
  final Value<int> reminderGap;
  final Value<int> rowid;
  const WaterGoalsCompanion({
    this.date = const Value.absent(),
    this.totalVolume = const Value.absent(),
    this.consumedVolume = const Value.absent(),
    this.reminderGap = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaterGoalsCompanion.insert({
    required DateTime date,
    required int totalVolume,
    required int consumedVolume,
    required int reminderGap,
    this.rowid = const Value.absent(),
  })  : date = Value(date),
        totalVolume = Value(totalVolume),
        consumedVolume = Value(consumedVolume),
        reminderGap = Value(reminderGap);
  static Insertable<WaterGoal> custom({
    Expression<DateTime>? date,
    Expression<int>? totalVolume,
    Expression<int>? consumedVolume,
    Expression<int>? reminderGap,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (totalVolume != null) 'total_volume': totalVolume,
      if (consumedVolume != null) 'consumed_volume': consumedVolume,
      if (reminderGap != null) 'reminder_gap': reminderGap,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaterGoalsCompanion copyWith(
      {Value<DateTime>? date,
      Value<int>? totalVolume,
      Value<int>? consumedVolume,
      Value<int>? reminderGap,
      Value<int>? rowid}) {
    return WaterGoalsCompanion(
      date: date ?? this.date,
      totalVolume: totalVolume ?? this.totalVolume,
      consumedVolume: consumedVolume ?? this.consumedVolume,
      reminderGap: reminderGap ?? this.reminderGap,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalVolume.present) {
      map['total_volume'] = Variable<int>(totalVolume.value);
    }
    if (consumedVolume.present) {
      map['consumed_volume'] = Variable<int>(consumedVolume.value);
    }
    if (reminderGap.present) {
      map['reminder_gap'] = Variable<int>(reminderGap.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterGoalsCompanion(')
          ..write('date: $date, ')
          ..write('totalVolume: $totalVolume, ')
          ..write('consumedVolume: $consumedVolume, ')
          ..write('reminderGap: $reminderGap, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  _$DatabaseManager get managers => _$DatabaseManager(this);
  late final $BeveragesTable beverages = $BeveragesTable(this);
  late final $DrinksTable drinks = $DrinksTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WaterGoalsTable waterGoals = $WaterGoalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [beverages, drinks, activities, workouts, waterGoals];
}

typedef $$BeveragesTableInsertCompanionBuilder = BeveragesCompanion Function({
  Value<int> id,
  required String name,
  required String colorCode,
  required int waterPercent,
  required bool starred,
});
typedef $$BeveragesTableUpdateCompanionBuilder = BeveragesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> colorCode,
  Value<int> waterPercent,
  Value<bool> starred,
});

class $$BeveragesTableTableManager extends RootTableManager<
    _$Database,
    $BeveragesTable,
    Beverage,
    $$BeveragesTableFilterComposer,
    $$BeveragesTableOrderingComposer,
    $$BeveragesTableProcessedTableManager,
    $$BeveragesTableInsertCompanionBuilder,
    $$BeveragesTableUpdateCompanionBuilder> {
  $$BeveragesTableTableManager(_$Database db, $BeveragesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BeveragesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BeveragesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$BeveragesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> colorCode = const Value.absent(),
            Value<int> waterPercent = const Value.absent(),
            Value<bool> starred = const Value.absent(),
          }) =>
              BeveragesCompanion(
            id: id,
            name: name,
            colorCode: colorCode,
            waterPercent: waterPercent,
            starred: starred,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String colorCode,
            required int waterPercent,
            required bool starred,
          }) =>
              BeveragesCompanion.insert(
            id: id,
            name: name,
            colorCode: colorCode,
            waterPercent: waterPercent,
            starred: starred,
          ),
        ));
}

class $$BeveragesTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $BeveragesTable,
    Beverage,
    $$BeveragesTableFilterComposer,
    $$BeveragesTableOrderingComposer,
    $$BeveragesTableProcessedTableManager,
    $$BeveragesTableInsertCompanionBuilder,
    $$BeveragesTableUpdateCompanionBuilder> {
  $$BeveragesTableProcessedTableManager(super.$state);
}

class $$BeveragesTableFilterComposer
    extends FilterComposer<_$Database, $BeveragesTable> {
  $$BeveragesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get colorCode => $state.composableBuilder(
      column: $state.table.colorCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get waterPercent => $state.composableBuilder(
      column: $state.table.waterPercent,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get starred => $state.composableBuilder(
      column: $state.table.starred,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter drinksRefs(
      ComposableFilter Function($$DrinksTableFilterComposer f) f) {
    final $$DrinksTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.drinks,
        getReferencedColumn: (t) => t.bevID,
        builder: (joinBuilder, parentComposers) => $$DrinksTableFilterComposer(
            ComposerState(
                $state.db, $state.db.drinks, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$BeveragesTableOrderingComposer
    extends OrderingComposer<_$Database, $BeveragesTable> {
  $$BeveragesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get colorCode => $state.composableBuilder(
      column: $state.table.colorCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get waterPercent => $state.composableBuilder(
      column: $state.table.waterPercent,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get starred => $state.composableBuilder(
      column: $state.table.starred,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$DrinksTableInsertCompanionBuilder = DrinksCompanion Function({
  Value<int> id,
  required int bevID,
  required int volume,
  required DateTime datetime,
});
typedef $$DrinksTableUpdateCompanionBuilder = DrinksCompanion Function({
  Value<int> id,
  Value<int> bevID,
  Value<int> volume,
  Value<DateTime> datetime,
});

class $$DrinksTableTableManager extends RootTableManager<
    _$Database,
    $DrinksTable,
    Drink,
    $$DrinksTableFilterComposer,
    $$DrinksTableOrderingComposer,
    $$DrinksTableProcessedTableManager,
    $$DrinksTableInsertCompanionBuilder,
    $$DrinksTableUpdateCompanionBuilder> {
  $$DrinksTableTableManager(_$Database db, $DrinksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$DrinksTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$DrinksTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) => $$DrinksTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> bevID = const Value.absent(),
            Value<int> volume = const Value.absent(),
            Value<DateTime> datetime = const Value.absent(),
          }) =>
              DrinksCompanion(
            id: id,
            bevID: bevID,
            volume: volume,
            datetime: datetime,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int bevID,
            required int volume,
            required DateTime datetime,
          }) =>
              DrinksCompanion.insert(
            id: id,
            bevID: bevID,
            volume: volume,
            datetime: datetime,
          ),
        ));
}

class $$DrinksTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $DrinksTable,
    Drink,
    $$DrinksTableFilterComposer,
    $$DrinksTableOrderingComposer,
    $$DrinksTableProcessedTableManager,
    $$DrinksTableInsertCompanionBuilder,
    $$DrinksTableUpdateCompanionBuilder> {
  $$DrinksTableProcessedTableManager(super.$state);
}

class $$DrinksTableFilterComposer
    extends FilterComposer<_$Database, $DrinksTable> {
  $$DrinksTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get volume => $state.composableBuilder(
      column: $state.table.volume,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get datetime => $state.composableBuilder(
      column: $state.table.datetime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$BeveragesTableFilterComposer get bevID {
    final $$BeveragesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bevID,
        referencedTable: $state.db.beverages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$BeveragesTableFilterComposer(ComposerState(
                $state.db, $state.db.beverages, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$DrinksTableOrderingComposer
    extends OrderingComposer<_$Database, $DrinksTable> {
  $$DrinksTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get volume => $state.composableBuilder(
      column: $state.table.volume,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get datetime => $state.composableBuilder(
      column: $state.table.datetime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$BeveragesTableOrderingComposer get bevID {
    final $$BeveragesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bevID,
        referencedTable: $state.db.beverages,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$BeveragesTableOrderingComposer(ComposerState(
                $state.db, $state.db.beverages, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$ActivitiesTableInsertCompanionBuilder = ActivitiesCompanion Function({
  Value<int> id,
  required String category,
  required double met,
  required String description,
});
typedef $$ActivitiesTableUpdateCompanionBuilder = ActivitiesCompanion Function({
  Value<int> id,
  Value<String> category,
  Value<double> met,
  Value<String> description,
});

class $$ActivitiesTableTableManager extends RootTableManager<
    _$Database,
    $ActivitiesTable,
    Activity,
    $$ActivitiesTableFilterComposer,
    $$ActivitiesTableOrderingComposer,
    $$ActivitiesTableProcessedTableManager,
    $$ActivitiesTableInsertCompanionBuilder,
    $$ActivitiesTableUpdateCompanionBuilder> {
  $$ActivitiesTableTableManager(_$Database db, $ActivitiesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ActivitiesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ActivitiesTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$ActivitiesTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> met = const Value.absent(),
            Value<String> description = const Value.absent(),
          }) =>
              ActivitiesCompanion(
            id: id,
            category: category,
            met: met,
            description: description,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required String category,
            required double met,
            required String description,
          }) =>
              ActivitiesCompanion.insert(
            id: id,
            category: category,
            met: met,
            description: description,
          ),
        ));
}

class $$ActivitiesTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $ActivitiesTable,
    Activity,
    $$ActivitiesTableFilterComposer,
    $$ActivitiesTableOrderingComposer,
    $$ActivitiesTableProcessedTableManager,
    $$ActivitiesTableInsertCompanionBuilder,
    $$ActivitiesTableUpdateCompanionBuilder> {
  $$ActivitiesTableProcessedTableManager(super.$state);
}

class $$ActivitiesTableFilterComposer
    extends FilterComposer<_$Database, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get met => $state.composableBuilder(
      column: $state.table.met,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter workoutsRefs(
      ComposableFilter Function($$WorkoutsTableFilterComposer f) f) {
    final $$WorkoutsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.workouts,
        getReferencedColumn: (t) => t.activityID,
        builder: (joinBuilder, parentComposers) =>
            $$WorkoutsTableFilterComposer(ComposerState(
                $state.db, $state.db.workouts, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$ActivitiesTableOrderingComposer
    extends OrderingComposer<_$Database, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get met => $state.composableBuilder(
      column: $state.table.met,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$WorkoutsTableInsertCompanionBuilder = WorkoutsCompanion Function({
  Value<int> id,
  required int activityID,
  required DateTime datetime,
  required int duration,
  required int waterLoss,
});
typedef $$WorkoutsTableUpdateCompanionBuilder = WorkoutsCompanion Function({
  Value<int> id,
  Value<int> activityID,
  Value<DateTime> datetime,
  Value<int> duration,
  Value<int> waterLoss,
});

class $$WorkoutsTableTableManager extends RootTableManager<
    _$Database,
    $WorkoutsTable,
    Workout,
    $$WorkoutsTableFilterComposer,
    $$WorkoutsTableOrderingComposer,
    $$WorkoutsTableProcessedTableManager,
    $$WorkoutsTableInsertCompanionBuilder,
    $$WorkoutsTableUpdateCompanionBuilder> {
  $$WorkoutsTableTableManager(_$Database db, $WorkoutsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$WorkoutsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$WorkoutsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$WorkoutsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            Value<int> activityID = const Value.absent(),
            Value<DateTime> datetime = const Value.absent(),
            Value<int> duration = const Value.absent(),
            Value<int> waterLoss = const Value.absent(),
          }) =>
              WorkoutsCompanion(
            id: id,
            activityID: activityID,
            datetime: datetime,
            duration: duration,
            waterLoss: waterLoss,
          ),
          getInsertCompanionBuilder: ({
            Value<int> id = const Value.absent(),
            required int activityID,
            required DateTime datetime,
            required int duration,
            required int waterLoss,
          }) =>
              WorkoutsCompanion.insert(
            id: id,
            activityID: activityID,
            datetime: datetime,
            duration: duration,
            waterLoss: waterLoss,
          ),
        ));
}

class $$WorkoutsTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $WorkoutsTable,
    Workout,
    $$WorkoutsTableFilterComposer,
    $$WorkoutsTableOrderingComposer,
    $$WorkoutsTableProcessedTableManager,
    $$WorkoutsTableInsertCompanionBuilder,
    $$WorkoutsTableUpdateCompanionBuilder> {
  $$WorkoutsTableProcessedTableManager(super.$state);
}

class $$WorkoutsTableFilterComposer
    extends FilterComposer<_$Database, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get datetime => $state.composableBuilder(
      column: $state.table.datetime,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get duration => $state.composableBuilder(
      column: $state.table.duration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get waterLoss => $state.composableBuilder(
      column: $state.table.waterLoss,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$ActivitiesTableFilterComposer get activityID {
    final $$ActivitiesTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.activityID,
        referencedTable: $state.db.activities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ActivitiesTableFilterComposer(ComposerState($state.db,
                $state.db.activities, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$WorkoutsTableOrderingComposer
    extends OrderingComposer<_$Database, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get datetime => $state.composableBuilder(
      column: $state.table.datetime,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get duration => $state.composableBuilder(
      column: $state.table.duration,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get waterLoss => $state.composableBuilder(
      column: $state.table.waterLoss,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$ActivitiesTableOrderingComposer get activityID {
    final $$ActivitiesTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.activityID,
        referencedTable: $state.db.activities,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$ActivitiesTableOrderingComposer(ComposerState($state.db,
                $state.db.activities, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$WaterGoalsTableInsertCompanionBuilder = WaterGoalsCompanion Function({
  required DateTime date,
  required int totalVolume,
  required int consumedVolume,
  required int reminderGap,
  Value<int> rowid,
});
typedef $$WaterGoalsTableUpdateCompanionBuilder = WaterGoalsCompanion Function({
  Value<DateTime> date,
  Value<int> totalVolume,
  Value<int> consumedVolume,
  Value<int> reminderGap,
  Value<int> rowid,
});

class $$WaterGoalsTableTableManager extends RootTableManager<
    _$Database,
    $WaterGoalsTable,
    WaterGoal,
    $$WaterGoalsTableFilterComposer,
    $$WaterGoalsTableOrderingComposer,
    $$WaterGoalsTableProcessedTableManager,
    $$WaterGoalsTableInsertCompanionBuilder,
    $$WaterGoalsTableUpdateCompanionBuilder> {
  $$WaterGoalsTableTableManager(_$Database db, $WaterGoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$WaterGoalsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$WaterGoalsTableOrderingComposer(ComposerState(db, table)),
          getChildManagerBuilder: (p) =>
              $$WaterGoalsTableProcessedTableManager(p),
          getUpdateCompanionBuilder: ({
            Value<DateTime> date = const Value.absent(),
            Value<int> totalVolume = const Value.absent(),
            Value<int> consumedVolume = const Value.absent(),
            Value<int> reminderGap = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WaterGoalsCompanion(
            date: date,
            totalVolume: totalVolume,
            consumedVolume: consumedVolume,
            reminderGap: reminderGap,
            rowid: rowid,
          ),
          getInsertCompanionBuilder: ({
            required DateTime date,
            required int totalVolume,
            required int consumedVolume,
            required int reminderGap,
            Value<int> rowid = const Value.absent(),
          }) =>
              WaterGoalsCompanion.insert(
            date: date,
            totalVolume: totalVolume,
            consumedVolume: consumedVolume,
            reminderGap: reminderGap,
            rowid: rowid,
          ),
        ));
}

class $$WaterGoalsTableProcessedTableManager extends ProcessedTableManager<
    _$Database,
    $WaterGoalsTable,
    WaterGoal,
    $$WaterGoalsTableFilterComposer,
    $$WaterGoalsTableOrderingComposer,
    $$WaterGoalsTableProcessedTableManager,
    $$WaterGoalsTableInsertCompanionBuilder,
    $$WaterGoalsTableUpdateCompanionBuilder> {
  $$WaterGoalsTableProcessedTableManager(super.$state);
}

class $$WaterGoalsTableFilterComposer
    extends FilterComposer<_$Database, $WaterGoalsTable> {
  $$WaterGoalsTableFilterComposer(super.$state);
  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get totalVolume => $state.composableBuilder(
      column: $state.table.totalVolume,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get consumedVolume => $state.composableBuilder(
      column: $state.table.consumedVolume,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get reminderGap => $state.composableBuilder(
      column: $state.table.reminderGap,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$WaterGoalsTableOrderingComposer
    extends OrderingComposer<_$Database, $WaterGoalsTable> {
  $$WaterGoalsTableOrderingComposer(super.$state);
  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get totalVolume => $state.composableBuilder(
      column: $state.table.totalVolume,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get consumedVolume => $state.composableBuilder(
      column: $state.table.consumedVolume,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get reminderGap => $state.composableBuilder(
      column: $state.table.reminderGap,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class _$DatabaseManager {
  final _$Database _db;
  _$DatabaseManager(this._db);
  $$BeveragesTableTableManager get beverages =>
      $$BeveragesTableTableManager(_db, _db.beverages);
  $$DrinksTableTableManager get drinks =>
      $$DrinksTableTableManager(_db, _db.drinks);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WaterGoalsTableTableManager get waterGoals =>
      $$WaterGoalsTableTableManager(_db, _db.waterGoals);
}
