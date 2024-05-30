// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BeveragesTable extends Beverages
    with TableInfo<$BeveragesTable, Beverage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BeveragesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bevIDMeta = const VerificationMeta('bevID');
  @override
  late final GeneratedColumn<int> bevID = GeneratedColumn<int>(
      'bev_ID', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bevNameMeta =
      const VerificationMeta('bevName');
  @override
  late final GeneratedColumn<String> bevName = GeneratedColumn<String>(
      'bev_name', aliasedName, false,
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
  @override
  List<GeneratedColumn> get $columns =>
      [bevID, bevName, colorCode, waterPercent];
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
    if (data.containsKey('bev_ID')) {
      context.handle(
          _bevIDMeta, bevID.isAcceptableOrUnknown(data['bev_ID']!, _bevIDMeta));
    }
    if (data.containsKey('bev_name')) {
      context.handle(_bevNameMeta,
          bevName.isAcceptableOrUnknown(data['bev_name']!, _bevNameMeta));
    } else if (isInserting) {
      context.missing(_bevNameMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {bevID};
  @override
  Beverage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Beverage(
      bevID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bev_ID'])!,
      bevName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bev_name'])!,
      colorCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_code'])!,
      waterPercent: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}water_percent'])!,
    );
  }

  @override
  $BeveragesTable createAlias(String alias) {
    return $BeveragesTable(attachedDatabase, alias);
  }
}

class Beverage extends DataClass implements Insertable<Beverage> {
  final int bevID;
  final String bevName;
  final String colorCode;
  final int waterPercent;
  const Beverage(
      {required this.bevID,
      required this.bevName,
      required this.colorCode,
      required this.waterPercent});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bev_ID'] = Variable<int>(bevID);
    map['bev_name'] = Variable<String>(bevName);
    map['color_code'] = Variable<String>(colorCode);
    map['water_percent'] = Variable<int>(waterPercent);
    return map;
  }

  BeveragesCompanion toCompanion(bool nullToAbsent) {
    return BeveragesCompanion(
      bevID: Value(bevID),
      bevName: Value(bevName),
      colorCode: Value(colorCode),
      waterPercent: Value(waterPercent),
    );
  }

  factory Beverage.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Beverage(
      bevID: serializer.fromJson<int>(json['bevID']),
      bevName: serializer.fromJson<String>(json['bevName']),
      colorCode: serializer.fromJson<String>(json['colorCode']),
      waterPercent: serializer.fromJson<int>(json['waterPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bevID': serializer.toJson<int>(bevID),
      'bevName': serializer.toJson<String>(bevName),
      'colorCode': serializer.toJson<String>(colorCode),
      'waterPercent': serializer.toJson<int>(waterPercent),
    };
  }

  Beverage copyWith(
          {int? bevID,
          String? bevName,
          String? colorCode,
          int? waterPercent}) =>
      Beverage(
        bevID: bevID ?? this.bevID,
        bevName: bevName ?? this.bevName,
        colorCode: colorCode ?? this.colorCode,
        waterPercent: waterPercent ?? this.waterPercent,
      );
  @override
  String toString() {
    return (StringBuffer('Beverage(')
          ..write('bevID: $bevID, ')
          ..write('bevName: $bevName, ')
          ..write('colorCode: $colorCode, ')
          ..write('waterPercent: $waterPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(bevID, bevName, colorCode, waterPercent);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Beverage &&
          other.bevID == this.bevID &&
          other.bevName == this.bevName &&
          other.colorCode == this.colorCode &&
          other.waterPercent == this.waterPercent);
}

class BeveragesCompanion extends UpdateCompanion<Beverage> {
  final Value<int> bevID;
  final Value<String> bevName;
  final Value<String> colorCode;
  final Value<int> waterPercent;
  const BeveragesCompanion({
    this.bevID = const Value.absent(),
    this.bevName = const Value.absent(),
    this.colorCode = const Value.absent(),
    this.waterPercent = const Value.absent(),
  });
  BeveragesCompanion.insert({
    this.bevID = const Value.absent(),
    required String bevName,
    required String colorCode,
    required int waterPercent,
  })  : bevName = Value(bevName),
        colorCode = Value(colorCode),
        waterPercent = Value(waterPercent);
  static Insertable<Beverage> custom({
    Expression<int>? bevID,
    Expression<String>? bevName,
    Expression<String>? colorCode,
    Expression<int>? waterPercent,
  }) {
    return RawValuesInsertable({
      if (bevID != null) 'bev_ID': bevID,
      if (bevName != null) 'bev_name': bevName,
      if (colorCode != null) 'color_code': colorCode,
      if (waterPercent != null) 'water_percent': waterPercent,
    });
  }

  BeveragesCompanion copyWith(
      {Value<int>? bevID,
      Value<String>? bevName,
      Value<String>? colorCode,
      Value<int>? waterPercent}) {
    return BeveragesCompanion(
      bevID: bevID ?? this.bevID,
      bevName: bevName ?? this.bevName,
      colorCode: colorCode ?? this.colorCode,
      waterPercent: waterPercent ?? this.waterPercent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bevID.present) {
      map['bev_ID'] = Variable<int>(bevID.value);
    }
    if (bevName.present) {
      map['bev_name'] = Variable<String>(bevName.value);
    }
    if (colorCode.present) {
      map['color_code'] = Variable<String>(colorCode.value);
    }
    if (waterPercent.present) {
      map['water_percent'] = Variable<int>(waterPercent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BeveragesCompanion(')
          ..write('bevID: $bevID, ')
          ..write('bevName: $bevName, ')
          ..write('colorCode: $colorCode, ')
          ..write('waterPercent: $waterPercent')
          ..write(')'))
        .toString();
  }
}

class $DrinksTable extends Drinks with TableInfo<$DrinksTable, Drink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DrinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _drinkIDMeta =
      const VerificationMeta('drinkID');
  @override
  late final GeneratedColumn<int> drinkID = GeneratedColumn<int>(
      'drink_ID', aliasedName, false,
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
          GeneratedColumn.constraintIsAlways('REFERENCES beverages (bev_ID)'));
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
  List<GeneratedColumn> get $columns => [drinkID, bevID, volume, datetime];
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
    if (data.containsKey('drink_ID')) {
      context.handle(_drinkIDMeta,
          drinkID.isAcceptableOrUnknown(data['drink_ID']!, _drinkIDMeta));
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
  Set<GeneratedColumn> get $primaryKey => {drinkID};
  @override
  Drink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Drink(
      drinkID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}drink_ID'])!,
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
  final int drinkID;
  final int bevID;
  final int volume;
  final DateTime datetime;
  const Drink(
      {required this.drinkID,
      required this.bevID,
      required this.volume,
      required this.datetime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['drink_ID'] = Variable<int>(drinkID);
    map['bev_ID'] = Variable<int>(bevID);
    map['volume'] = Variable<int>(volume);
    map['datetime'] = Variable<DateTime>(datetime);
    return map;
  }

  DrinksCompanion toCompanion(bool nullToAbsent) {
    return DrinksCompanion(
      drinkID: Value(drinkID),
      bevID: Value(bevID),
      volume: Value(volume),
      datetime: Value(datetime),
    );
  }

  factory Drink.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Drink(
      drinkID: serializer.fromJson<int>(json['drinkID']),
      bevID: serializer.fromJson<int>(json['bevID']),
      volume: serializer.fromJson<int>(json['volume']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'drinkID': serializer.toJson<int>(drinkID),
      'bevID': serializer.toJson<int>(bevID),
      'volume': serializer.toJson<int>(volume),
      'datetime': serializer.toJson<DateTime>(datetime),
    };
  }

  Drink copyWith({int? drinkID, int? bevID, int? volume, DateTime? datetime}) =>
      Drink(
        drinkID: drinkID ?? this.drinkID,
        bevID: bevID ?? this.bevID,
        volume: volume ?? this.volume,
        datetime: datetime ?? this.datetime,
      );
  @override
  String toString() {
    return (StringBuffer('Drink(')
          ..write('drinkID: $drinkID, ')
          ..write('bevID: $bevID, ')
          ..write('volume: $volume, ')
          ..write('datetime: $datetime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(drinkID, bevID, volume, datetime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Drink &&
          other.drinkID == this.drinkID &&
          other.bevID == this.bevID &&
          other.volume == this.volume &&
          other.datetime == this.datetime);
}

class DrinksCompanion extends UpdateCompanion<Drink> {
  final Value<int> drinkID;
  final Value<int> bevID;
  final Value<int> volume;
  final Value<DateTime> datetime;
  const DrinksCompanion({
    this.drinkID = const Value.absent(),
    this.bevID = const Value.absent(),
    this.volume = const Value.absent(),
    this.datetime = const Value.absent(),
  });
  DrinksCompanion.insert({
    this.drinkID = const Value.absent(),
    required int bevID,
    required int volume,
    required DateTime datetime,
  })  : bevID = Value(bevID),
        volume = Value(volume),
        datetime = Value(datetime);
  static Insertable<Drink> custom({
    Expression<int>? drinkID,
    Expression<int>? bevID,
    Expression<int>? volume,
    Expression<DateTime>? datetime,
  }) {
    return RawValuesInsertable({
      if (drinkID != null) 'drink_ID': drinkID,
      if (bevID != null) 'bev_ID': bevID,
      if (volume != null) 'volume': volume,
      if (datetime != null) 'datetime': datetime,
    });
  }

  DrinksCompanion copyWith(
      {Value<int>? drinkID,
      Value<int>? bevID,
      Value<int>? volume,
      Value<DateTime>? datetime}) {
    return DrinksCompanion(
      drinkID: drinkID ?? this.drinkID,
      bevID: bevID ?? this.bevID,
      volume: volume ?? this.volume,
      datetime: datetime ?? this.datetime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (drinkID.present) {
      map['drink_ID'] = Variable<int>(drinkID.value);
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
          ..write('drinkID: $drinkID, ')
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
  static const VerificationMeta _activityIDMeta =
      const VerificationMeta('activityID');
  @override
  late final GeneratedColumn<int> activityID = GeneratedColumn<int>(
      'activity_ID', aliasedName, false,
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
  List<GeneratedColumn> get $columns =>
      [activityID, category, met, description];
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
    if (data.containsKey('activity_ID')) {
      context.handle(
          _activityIDMeta,
          activityID.isAcceptableOrUnknown(
              data['activity_ID']!, _activityIDMeta));
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
  Set<GeneratedColumn> get $primaryKey => {activityID};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      activityID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activity_ID'])!,
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
  final int activityID;
  final String category;
  final double met;
  final String description;
  const Activity(
      {required this.activityID,
      required this.category,
      required this.met,
      required this.description});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['activity_ID'] = Variable<int>(activityID);
    map['category'] = Variable<String>(category);
    map['MET'] = Variable<double>(met);
    map['description'] = Variable<String>(description);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      activityID: Value(activityID),
      category: Value(category),
      met: Value(met),
      description: Value(description),
    );
  }

  factory Activity.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      activityID: serializer.fromJson<int>(json['activityID']),
      category: serializer.fromJson<String>(json['category']),
      met: serializer.fromJson<double>(json['met']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'activityID': serializer.toJson<int>(activityID),
      'category': serializer.toJson<String>(category),
      'met': serializer.toJson<double>(met),
      'description': serializer.toJson<String>(description),
    };
  }

  Activity copyWith(
          {int? activityID,
          String? category,
          double? met,
          String? description}) =>
      Activity(
        activityID: activityID ?? this.activityID,
        category: category ?? this.category,
        met: met ?? this.met,
        description: description ?? this.description,
      );
  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('activityID: $activityID, ')
          ..write('category: $category, ')
          ..write('met: $met, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(activityID, category, met, description);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.activityID == this.activityID &&
          other.category == this.category &&
          other.met == this.met &&
          other.description == this.description);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<int> activityID;
  final Value<String> category;
  final Value<double> met;
  final Value<String> description;
  const ActivitiesCompanion({
    this.activityID = const Value.absent(),
    this.category = const Value.absent(),
    this.met = const Value.absent(),
    this.description = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.activityID = const Value.absent(),
    required String category,
    required double met,
    required String description,
  })  : category = Value(category),
        met = Value(met),
        description = Value(description);
  static Insertable<Activity> custom({
    Expression<int>? activityID,
    Expression<String>? category,
    Expression<double>? met,
    Expression<String>? description,
  }) {
    return RawValuesInsertable({
      if (activityID != null) 'activity_ID': activityID,
      if (category != null) 'category': category,
      if (met != null) 'MET': met,
      if (description != null) 'description': description,
    });
  }

  ActivitiesCompanion copyWith(
      {Value<int>? activityID,
      Value<String>? category,
      Value<double>? met,
      Value<String>? description}) {
    return ActivitiesCompanion(
      activityID: activityID ?? this.activityID,
      category: category ?? this.category,
      met: met ?? this.met,
      description: description ?? this.description,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (activityID.present) {
      map['activity_ID'] = Variable<int>(activityID.value);
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
          ..write('activityID: $activityID, ')
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
  static const VerificationMeta _workoutIDMeta =
      const VerificationMeta('workoutID');
  @override
  late final GeneratedColumn<int> workoutID = GeneratedColumn<int>(
      'workout_ID', aliasedName, false,
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
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES activities (activity_ID)'));
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
  @override
  List<GeneratedColumn> get $columns =>
      [workoutID, activityID, datetime, duration];
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
    if (data.containsKey('workout_ID')) {
      context.handle(_workoutIDMeta,
          workoutID.isAcceptableOrUnknown(data['workout_ID']!, _workoutIDMeta));
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {workoutID};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      workoutID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}workout_ID'])!,
      activityID: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}activity_ID'])!,
      datetime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}datetime'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration'])!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final int workoutID;
  final int activityID;
  final DateTime datetime;
  final int duration;
  const Workout(
      {required this.workoutID,
      required this.activityID,
      required this.datetime,
      required this.duration});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['workout_ID'] = Variable<int>(workoutID);
    map['activity_ID'] = Variable<int>(activityID);
    map['datetime'] = Variable<DateTime>(datetime);
    map['duration'] = Variable<int>(duration);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      workoutID: Value(workoutID),
      activityID: Value(activityID),
      datetime: Value(datetime),
      duration: Value(duration),
    );
  }

  factory Workout.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      workoutID: serializer.fromJson<int>(json['workoutID']),
      activityID: serializer.fromJson<int>(json['activityID']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
      duration: serializer.fromJson<int>(json['duration']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'workoutID': serializer.toJson<int>(workoutID),
      'activityID': serializer.toJson<int>(activityID),
      'datetime': serializer.toJson<DateTime>(datetime),
      'duration': serializer.toJson<int>(duration),
    };
  }

  Workout copyWith(
          {int? workoutID,
          int? activityID,
          DateTime? datetime,
          int? duration}) =>
      Workout(
        workoutID: workoutID ?? this.workoutID,
        activityID: activityID ?? this.activityID,
        datetime: datetime ?? this.datetime,
        duration: duration ?? this.duration,
      );
  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('workoutID: $workoutID, ')
          ..write('activityID: $activityID, ')
          ..write('datetime: $datetime, ')
          ..write('duration: $duration')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(workoutID, activityID, datetime, duration);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.workoutID == this.workoutID &&
          other.activityID == this.activityID &&
          other.datetime == this.datetime &&
          other.duration == this.duration);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<int> workoutID;
  final Value<int> activityID;
  final Value<DateTime> datetime;
  final Value<int> duration;
  const WorkoutsCompanion({
    this.workoutID = const Value.absent(),
    this.activityID = const Value.absent(),
    this.datetime = const Value.absent(),
    this.duration = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.workoutID = const Value.absent(),
    required int activityID,
    required DateTime datetime,
    required int duration,
  })  : activityID = Value(activityID),
        datetime = Value(datetime),
        duration = Value(duration);
  static Insertable<Workout> custom({
    Expression<int>? workoutID,
    Expression<int>? activityID,
    Expression<DateTime>? datetime,
    Expression<int>? duration,
  }) {
    return RawValuesInsertable({
      if (workoutID != null) 'workout_ID': workoutID,
      if (activityID != null) 'activity_ID': activityID,
      if (datetime != null) 'datetime': datetime,
      if (duration != null) 'duration': duration,
    });
  }

  WorkoutsCompanion copyWith(
      {Value<int>? workoutID,
      Value<int>? activityID,
      Value<DateTime>? datetime,
      Value<int>? duration}) {
    return WorkoutsCompanion(
      workoutID: workoutID ?? this.workoutID,
      activityID: activityID ?? this.activityID,
      datetime: datetime ?? this.datetime,
      duration: duration ?? this.duration,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (workoutID.present) {
      map['workout_ID'] = Variable<int>(workoutID.value);
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('workoutID: $workoutID, ')
          ..write('activityID: $activityID, ')
          ..write('datetime: $datetime, ')
          ..write('duration: $duration')
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