// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<double> height = GeneratedColumn<double>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentWeightMeta = const VerificationMeta(
    'currentWeight',
  );
  @override
  late final GeneratedColumn<double> currentWeight = GeneratedColumn<double>(
    'current_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalMeta = const VerificationMeta('goal');
  @override
  late final GeneratedColumn<String> goal = GeneratedColumn<String>(
    'goal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalRateMeta = const VerificationMeta(
    'goalRate',
  );
  @override
  late final GeneratedColumn<double> goalRate = GeneratedColumn<double>(
    'goal_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    age,
    gender,
    height,
    currentWeight,
    activityLevel,
    goal,
    goalRate,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    } else if (isInserting) {
      context.missing(_genderMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    if (data.containsKey('current_weight')) {
      context.handle(
        _currentWeightMeta,
        currentWeight.isAcceptableOrUnknown(
          data['current_weight']!,
          _currentWeightMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentWeightMeta);
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityLevelMeta);
    }
    if (data.containsKey('goal')) {
      context.handle(
        _goalMeta,
        goal.isAcceptableOrUnknown(data['goal']!, _goalMeta),
      );
    } else if (isInserting) {
      context.missing(_goalMeta);
    }
    if (data.containsKey('goal_rate')) {
      context.handle(
        _goalRateMeta,
        goalRate.isAcceptableOrUnknown(data['goal_rate']!, _goalRateMeta),
      );
    } else if (isInserting) {
      context.missing(_goalRateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height'],
      )!,
      currentWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}current_weight'],
      )!,
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      )!,
      goal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal'],
      )!,
      goalRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}goal_rate'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String name;
  final int age;
  final String gender;
  final double height;
  final double currentWeight;
  final String activityLevel;
  final String goal;
  final double goalRate;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.height,
    required this.currentWeight,
    required this.activityLevel,
    required this.goal,
    required this.goalRate,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['gender'] = Variable<String>(gender);
    map['height'] = Variable<double>(height);
    map['current_weight'] = Variable<double>(currentWeight);
    map['activity_level'] = Variable<String>(activityLevel);
    map['goal'] = Variable<String>(goal);
    map['goal_rate'] = Variable<double>(goalRate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      gender: Value(gender),
      height: Value(height),
      currentWeight: Value(currentWeight),
      activityLevel: Value(activityLevel),
      goal: Value(goal),
      goalRate: Value(goalRate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      gender: serializer.fromJson<String>(json['gender']),
      height: serializer.fromJson<double>(json['height']),
      currentWeight: serializer.fromJson<double>(json['currentWeight']),
      activityLevel: serializer.fromJson<String>(json['activityLevel']),
      goal: serializer.fromJson<String>(json['goal']),
      goalRate: serializer.fromJson<double>(json['goalRate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'gender': serializer.toJson<String>(gender),
      'height': serializer.toJson<double>(height),
      'currentWeight': serializer.toJson<double>(currentWeight),
      'activityLevel': serializer.toJson<String>(activityLevel),
      'goal': serializer.toJson<String>(goal),
      'goalRate': serializer.toJson<double>(goalRate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    int? id,
    String? name,
    int? age,
    String? gender,
    double? height,
    double? currentWeight,
    String? activityLevel,
    String? goal,
    double? goalRate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    gender: gender ?? this.gender,
    height: height ?? this.height,
    currentWeight: currentWeight ?? this.currentWeight,
    activityLevel: activityLevel ?? this.activityLevel,
    goal: goal ?? this.goal,
    goalRate: goalRate ?? this.goalRate,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      height: data.height.present ? data.height.value : this.height,
      currentWeight: data.currentWeight.present
          ? data.currentWeight.value
          : this.currentWeight,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      goal: data.goal.present ? data.goal.value : this.goal,
      goalRate: data.goalRate.present ? data.goalRate.value : this.goalRate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('height: $height, ')
          ..write('currentWeight: $currentWeight, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goal: $goal, ')
          ..write('goalRate: $goalRate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    age,
    gender,
    height,
    currentWeight,
    activityLevel,
    goal,
    goalRate,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.height == this.height &&
          other.currentWeight == this.currentWeight &&
          other.activityLevel == this.activityLevel &&
          other.goal == this.goal &&
          other.goalRate == this.goalRate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  final Value<String> gender;
  final Value<double> height;
  final Value<double> currentWeight;
  final Value<String> activityLevel;
  final Value<String> goal;
  final Value<double> goalRate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.height = const Value.absent(),
    this.currentWeight = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goal = const Value.absent(),
    this.goalRate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int age,
    required String gender,
    required double height,
    required double currentWeight,
    required String activityLevel,
    required String goal,
    required double goalRate,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       age = Value(age),
       gender = Value(gender),
       height = Value(height),
       currentWeight = Value(currentWeight),
       activityLevel = Value(activityLevel),
       goal = Value(goal),
       goalRate = Value(goalRate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<double>? height,
    Expression<double>? currentWeight,
    Expression<String>? activityLevel,
    Expression<String>? goal,
    Expression<double>? goalRate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (height != null) 'height': height,
      if (currentWeight != null) 'current_weight': currentWeight,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (goal != null) 'goal': goal,
      if (goalRate != null) 'goal_rate': goalRate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? age,
    Value<String>? gender,
    Value<double>? height,
    Value<double>? currentWeight,
    Value<String>? activityLevel,
    Value<String>? goal,
    Value<double>? goalRate,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      currentWeight: currentWeight ?? this.currentWeight,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      goalRate: goalRate ?? this.goalRate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (height.present) {
      map['height'] = Variable<double>(height.value);
    }
    if (currentWeight.present) {
      map['current_weight'] = Variable<double>(currentWeight.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (goal.present) {
      map['goal'] = Variable<String>(goal.value);
    }
    if (goalRate.present) {
      map['goal_rate'] = Variable<double>(goalRate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('height: $height, ')
          ..write('currentWeight: $currentWeight, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goal: $goal, ')
          ..write('goalRate: $goalRate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $MacroGoalsTable extends MacroGoals
    with TableInfo<$MacroGoalsTable, MacroGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MacroGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _caloriesTargetMeta = const VerificationMeta(
    'caloriesTarget',
  );
  @override
  late final GeneratedColumn<int> caloriesTarget = GeneratedColumn<int>(
    'calories_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinTargetMeta = const VerificationMeta(
    'proteinTarget',
  );
  @override
  late final GeneratedColumn<double> proteinTarget = GeneratedColumn<double>(
    'protein_target',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsTargetMeta = const VerificationMeta(
    'carbsTarget',
  );
  @override
  late final GeneratedColumn<double> carbsTarget = GeneratedColumn<double>(
    'carbs_target',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatTargetMeta = const VerificationMeta(
    'fatTarget',
  );
  @override
  late final GeneratedColumn<double> fatTarget = GeneratedColumn<double>(
    'fat_target',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberTargetMeta = const VerificationMeta(
    'fiberTarget',
  );
  @override
  late final GeneratedColumn<double> fiberTarget = GeneratedColumn<double>(
    'fiber_target',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    caloriesTarget,
    proteinTarget,
    carbsTarget,
    fatTarget,
    fiberTarget,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'macro_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<MacroGoal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('calories_target')) {
      context.handle(
        _caloriesTargetMeta,
        caloriesTarget.isAcceptableOrUnknown(
          data['calories_target']!,
          _caloriesTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesTargetMeta);
    }
    if (data.containsKey('protein_target')) {
      context.handle(
        _proteinTargetMeta,
        proteinTarget.isAcceptableOrUnknown(
          data['protein_target']!,
          _proteinTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinTargetMeta);
    }
    if (data.containsKey('carbs_target')) {
      context.handle(
        _carbsTargetMeta,
        carbsTarget.isAcceptableOrUnknown(
          data['carbs_target']!,
          _carbsTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsTargetMeta);
    }
    if (data.containsKey('fat_target')) {
      context.handle(
        _fatTargetMeta,
        fatTarget.isAcceptableOrUnknown(data['fat_target']!, _fatTargetMeta),
      );
    } else if (isInserting) {
      context.missing(_fatTargetMeta);
    }
    if (data.containsKey('fiber_target')) {
      context.handle(
        _fiberTargetMeta,
        fiberTarget.isAcceptableOrUnknown(
          data['fiber_target']!,
          _fiberTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fiberTargetMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MacroGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MacroGoal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      caloriesTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories_target'],
      )!,
      proteinTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_target'],
      )!,
      carbsTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_target'],
      )!,
      fatTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_target'],
      )!,
      fiberTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_target'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $MacroGoalsTable createAlias(String alias) {
    return $MacroGoalsTable(attachedDatabase, alias);
  }
}

class MacroGoal extends DataClass implements Insertable<MacroGoal> {
  final int id;
  final int userId;
  final int caloriesTarget;
  final double proteinTarget;
  final double carbsTarget;
  final double fatTarget;
  final double fiberTarget;
  final DateTime updatedAt;
  const MacroGoal({
    required this.id,
    required this.userId,
    required this.caloriesTarget,
    required this.proteinTarget,
    required this.carbsTarget,
    required this.fatTarget,
    required this.fiberTarget,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['calories_target'] = Variable<int>(caloriesTarget);
    map['protein_target'] = Variable<double>(proteinTarget);
    map['carbs_target'] = Variable<double>(carbsTarget);
    map['fat_target'] = Variable<double>(fatTarget);
    map['fiber_target'] = Variable<double>(fiberTarget);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  MacroGoalsCompanion toCompanion(bool nullToAbsent) {
    return MacroGoalsCompanion(
      id: Value(id),
      userId: Value(userId),
      caloriesTarget: Value(caloriesTarget),
      proteinTarget: Value(proteinTarget),
      carbsTarget: Value(carbsTarget),
      fatTarget: Value(fatTarget),
      fiberTarget: Value(fiberTarget),
      updatedAt: Value(updatedAt),
    );
  }

  factory MacroGoal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MacroGoal(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      caloriesTarget: serializer.fromJson<int>(json['caloriesTarget']),
      proteinTarget: serializer.fromJson<double>(json['proteinTarget']),
      carbsTarget: serializer.fromJson<double>(json['carbsTarget']),
      fatTarget: serializer.fromJson<double>(json['fatTarget']),
      fiberTarget: serializer.fromJson<double>(json['fiberTarget']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'caloriesTarget': serializer.toJson<int>(caloriesTarget),
      'proteinTarget': serializer.toJson<double>(proteinTarget),
      'carbsTarget': serializer.toJson<double>(carbsTarget),
      'fatTarget': serializer.toJson<double>(fatTarget),
      'fiberTarget': serializer.toJson<double>(fiberTarget),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  MacroGoal copyWith({
    int? id,
    int? userId,
    int? caloriesTarget,
    double? proteinTarget,
    double? carbsTarget,
    double? fatTarget,
    double? fiberTarget,
    DateTime? updatedAt,
  }) => MacroGoal(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    caloriesTarget: caloriesTarget ?? this.caloriesTarget,
    proteinTarget: proteinTarget ?? this.proteinTarget,
    carbsTarget: carbsTarget ?? this.carbsTarget,
    fatTarget: fatTarget ?? this.fatTarget,
    fiberTarget: fiberTarget ?? this.fiberTarget,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  MacroGoal copyWithCompanion(MacroGoalsCompanion data) {
    return MacroGoal(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      caloriesTarget: data.caloriesTarget.present
          ? data.caloriesTarget.value
          : this.caloriesTarget,
      proteinTarget: data.proteinTarget.present
          ? data.proteinTarget.value
          : this.proteinTarget,
      carbsTarget: data.carbsTarget.present
          ? data.carbsTarget.value
          : this.carbsTarget,
      fatTarget: data.fatTarget.present ? data.fatTarget.value : this.fatTarget,
      fiberTarget: data.fiberTarget.present
          ? data.fiberTarget.value
          : this.fiberTarget,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MacroGoal(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('caloriesTarget: $caloriesTarget, ')
          ..write('proteinTarget: $proteinTarget, ')
          ..write('carbsTarget: $carbsTarget, ')
          ..write('fatTarget: $fatTarget, ')
          ..write('fiberTarget: $fiberTarget, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    caloriesTarget,
    proteinTarget,
    carbsTarget,
    fatTarget,
    fiberTarget,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MacroGoal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.caloriesTarget == this.caloriesTarget &&
          other.proteinTarget == this.proteinTarget &&
          other.carbsTarget == this.carbsTarget &&
          other.fatTarget == this.fatTarget &&
          other.fiberTarget == this.fiberTarget &&
          other.updatedAt == this.updatedAt);
}

class MacroGoalsCompanion extends UpdateCompanion<MacroGoal> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> caloriesTarget;
  final Value<double> proteinTarget;
  final Value<double> carbsTarget;
  final Value<double> fatTarget;
  final Value<double> fiberTarget;
  final Value<DateTime> updatedAt;
  const MacroGoalsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.caloriesTarget = const Value.absent(),
    this.proteinTarget = const Value.absent(),
    this.carbsTarget = const Value.absent(),
    this.fatTarget = const Value.absent(),
    this.fiberTarget = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  MacroGoalsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int caloriesTarget,
    required double proteinTarget,
    required double carbsTarget,
    required double fatTarget,
    required double fiberTarget,
    required DateTime updatedAt,
  }) : userId = Value(userId),
       caloriesTarget = Value(caloriesTarget),
       proteinTarget = Value(proteinTarget),
       carbsTarget = Value(carbsTarget),
       fatTarget = Value(fatTarget),
       fiberTarget = Value(fiberTarget),
       updatedAt = Value(updatedAt);
  static Insertable<MacroGoal> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? caloriesTarget,
    Expression<double>? proteinTarget,
    Expression<double>? carbsTarget,
    Expression<double>? fatTarget,
    Expression<double>? fiberTarget,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (caloriesTarget != null) 'calories_target': caloriesTarget,
      if (proteinTarget != null) 'protein_target': proteinTarget,
      if (carbsTarget != null) 'carbs_target': carbsTarget,
      if (fatTarget != null) 'fat_target': fatTarget,
      if (fiberTarget != null) 'fiber_target': fiberTarget,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  MacroGoalsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? caloriesTarget,
    Value<double>? proteinTarget,
    Value<double>? carbsTarget,
    Value<double>? fatTarget,
    Value<double>? fiberTarget,
    Value<DateTime>? updatedAt,
  }) {
    return MacroGoalsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      fatTarget: fatTarget ?? this.fatTarget,
      fiberTarget: fiberTarget ?? this.fiberTarget,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (caloriesTarget.present) {
      map['calories_target'] = Variable<int>(caloriesTarget.value);
    }
    if (proteinTarget.present) {
      map['protein_target'] = Variable<double>(proteinTarget.value);
    }
    if (carbsTarget.present) {
      map['carbs_target'] = Variable<double>(carbsTarget.value);
    }
    if (fatTarget.present) {
      map['fat_target'] = Variable<double>(fatTarget.value);
    }
    if (fiberTarget.present) {
      map['fiber_target'] = Variable<double>(fiberTarget.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MacroGoalsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('caloriesTarget: $caloriesTarget, ')
          ..write('proteinTarget: $proteinTarget, ')
          ..write('carbsTarget: $carbsTarget, ')
          ..write('fatTarget: $fatTarget, ')
          ..write('fiberTarget: $fiberTarget, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FoodItemsTable extends FoodItems
    with TableInfo<$FoodItemsTable, FoodItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measurementTypeMeta = const VerificationMeta(
    'measurementType',
  );
  @override
  late final GeneratedColumn<String> measurementType = GeneratedColumn<String>(
    'measurement_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _measurementUnitMeta = const VerificationMeta(
    'measurementUnit',
  );
  @override
  late final GeneratedColumn<String> measurementUnit = GeneratedColumn<String>(
    'measurement_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesPerUnitMeta = const VerificationMeta(
    'caloriesPerUnit',
  );
  @override
  late final GeneratedColumn<double> caloriesPerUnit = GeneratedColumn<double>(
    'calories_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinPerUnitMeta = const VerificationMeta(
    'proteinPerUnit',
  );
  @override
  late final GeneratedColumn<double> proteinPerUnit = GeneratedColumn<double>(
    'protein_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsPerUnitMeta = const VerificationMeta(
    'carbsPerUnit',
  );
  @override
  late final GeneratedColumn<double> carbsPerUnit = GeneratedColumn<double>(
    'carbs_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatPerUnitMeta = const VerificationMeta(
    'fatPerUnit',
  );
  @override
  late final GeneratedColumn<double> fatPerUnit = GeneratedColumn<double>(
    'fat_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberPerUnitMeta = const VerificationMeta(
    'fiberPerUnit',
  );
  @override
  late final GeneratedColumn<double> fiberPerUnit = GeneratedColumn<double>(
    'fiber_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    category,
    measurementType,
    measurementUnit,
    caloriesPerUnit,
    proteinPerUnit,
    carbsPerUnit,
    fatPerUnit,
    fiberPerUnit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('measurement_type')) {
      context.handle(
        _measurementTypeMeta,
        measurementType.isAcceptableOrUnknown(
          data['measurement_type']!,
          _measurementTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementTypeMeta);
    }
    if (data.containsKey('measurement_unit')) {
      context.handle(
        _measurementUnitMeta,
        measurementUnit.isAcceptableOrUnknown(
          data['measurement_unit']!,
          _measurementUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_measurementUnitMeta);
    }
    if (data.containsKey('calories_per_unit')) {
      context.handle(
        _caloriesPerUnitMeta,
        caloriesPerUnit.isAcceptableOrUnknown(
          data['calories_per_unit']!,
          _caloriesPerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPerUnitMeta);
    }
    if (data.containsKey('protein_per_unit')) {
      context.handle(
        _proteinPerUnitMeta,
        proteinPerUnit.isAcceptableOrUnknown(
          data['protein_per_unit']!,
          _proteinPerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinPerUnitMeta);
    }
    if (data.containsKey('carbs_per_unit')) {
      context.handle(
        _carbsPerUnitMeta,
        carbsPerUnit.isAcceptableOrUnknown(
          data['carbs_per_unit']!,
          _carbsPerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_carbsPerUnitMeta);
    }
    if (data.containsKey('fat_per_unit')) {
      context.handle(
        _fatPerUnitMeta,
        fatPerUnit.isAcceptableOrUnknown(
          data['fat_per_unit']!,
          _fatPerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fatPerUnitMeta);
    }
    if (data.containsKey('fiber_per_unit')) {
      context.handle(
        _fiberPerUnitMeta,
        fiberPerUnit.isAcceptableOrUnknown(
          data['fiber_per_unit']!,
          _fiberPerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fiberPerUnitMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      measurementType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_type'],
      )!,
      measurementUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_unit'],
      )!,
      caloriesPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_per_unit'],
      )!,
      proteinPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_per_unit'],
      )!,
      carbsPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_per_unit'],
      )!,
      fatPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_per_unit'],
      )!,
      fiberPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber_per_unit'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FoodItemsTable createAlias(String alias) {
    return $FoodItemsTable(attachedDatabase, alias);
  }
}

class FoodItem extends DataClass implements Insertable<FoodItem> {
  final int id;
  final int? userId;
  final String name;
  final String? category;
  final String measurementType;
  final String measurementUnit;
  final double caloriesPerUnit;
  final double proteinPerUnit;
  final double carbsPerUnit;
  final double fatPerUnit;
  final double fiberPerUnit;
  final DateTime createdAt;
  const FoodItem({
    required this.id,
    this.userId,
    required this.name,
    this.category,
    required this.measurementType,
    required this.measurementUnit,
    required this.caloriesPerUnit,
    required this.proteinPerUnit,
    required this.carbsPerUnit,
    required this.fatPerUnit,
    required this.fiberPerUnit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    map['measurement_type'] = Variable<String>(measurementType);
    map['measurement_unit'] = Variable<String>(measurementUnit);
    map['calories_per_unit'] = Variable<double>(caloriesPerUnit);
    map['protein_per_unit'] = Variable<double>(proteinPerUnit);
    map['carbs_per_unit'] = Variable<double>(carbsPerUnit);
    map['fat_per_unit'] = Variable<double>(fatPerUnit);
    map['fiber_per_unit'] = Variable<double>(fiberPerUnit);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FoodItemsCompanion toCompanion(bool nullToAbsent) {
    return FoodItemsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      name: Value(name),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      measurementType: Value(measurementType),
      measurementUnit: Value(measurementUnit),
      caloriesPerUnit: Value(caloriesPerUnit),
      proteinPerUnit: Value(proteinPerUnit),
      carbsPerUnit: Value(carbsPerUnit),
      fatPerUnit: Value(fatPerUnit),
      fiberPerUnit: Value(fiberPerUnit),
      createdAt: Value(createdAt),
    );
  }

  factory FoodItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItem(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String?>(json['category']),
      measurementType: serializer.fromJson<String>(json['measurementType']),
      measurementUnit: serializer.fromJson<String>(json['measurementUnit']),
      caloriesPerUnit: serializer.fromJson<double>(json['caloriesPerUnit']),
      proteinPerUnit: serializer.fromJson<double>(json['proteinPerUnit']),
      carbsPerUnit: serializer.fromJson<double>(json['carbsPerUnit']),
      fatPerUnit: serializer.fromJson<double>(json['fatPerUnit']),
      fiberPerUnit: serializer.fromJson<double>(json['fiberPerUnit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int?>(userId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String?>(category),
      'measurementType': serializer.toJson<String>(measurementType),
      'measurementUnit': serializer.toJson<String>(measurementUnit),
      'caloriesPerUnit': serializer.toJson<double>(caloriesPerUnit),
      'proteinPerUnit': serializer.toJson<double>(proteinPerUnit),
      'carbsPerUnit': serializer.toJson<double>(carbsPerUnit),
      'fatPerUnit': serializer.toJson<double>(fatPerUnit),
      'fiberPerUnit': serializer.toJson<double>(fiberPerUnit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FoodItem copyWith({
    int? id,
    Value<int?> userId = const Value.absent(),
    String? name,
    Value<String?> category = const Value.absent(),
    String? measurementType,
    String? measurementUnit,
    double? caloriesPerUnit,
    double? proteinPerUnit,
    double? carbsPerUnit,
    double? fatPerUnit,
    double? fiberPerUnit,
    DateTime? createdAt,
  }) => FoodItem(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    name: name ?? this.name,
    category: category.present ? category.value : this.category,
    measurementType: measurementType ?? this.measurementType,
    measurementUnit: measurementUnit ?? this.measurementUnit,
    caloriesPerUnit: caloriesPerUnit ?? this.caloriesPerUnit,
    proteinPerUnit: proteinPerUnit ?? this.proteinPerUnit,
    carbsPerUnit: carbsPerUnit ?? this.carbsPerUnit,
    fatPerUnit: fatPerUnit ?? this.fatPerUnit,
    fiberPerUnit: fiberPerUnit ?? this.fiberPerUnit,
    createdAt: createdAt ?? this.createdAt,
  );
  FoodItem copyWithCompanion(FoodItemsCompanion data) {
    return FoodItem(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      measurementType: data.measurementType.present
          ? data.measurementType.value
          : this.measurementType,
      measurementUnit: data.measurementUnit.present
          ? data.measurementUnit.value
          : this.measurementUnit,
      caloriesPerUnit: data.caloriesPerUnit.present
          ? data.caloriesPerUnit.value
          : this.caloriesPerUnit,
      proteinPerUnit: data.proteinPerUnit.present
          ? data.proteinPerUnit.value
          : this.proteinPerUnit,
      carbsPerUnit: data.carbsPerUnit.present
          ? data.carbsPerUnit.value
          : this.carbsPerUnit,
      fatPerUnit: data.fatPerUnit.present
          ? data.fatPerUnit.value
          : this.fatPerUnit,
      fiberPerUnit: data.fiberPerUnit.present
          ? data.fiberPerUnit.value
          : this.fiberPerUnit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItem(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('measurementType: $measurementType, ')
          ..write('measurementUnit: $measurementUnit, ')
          ..write('caloriesPerUnit: $caloriesPerUnit, ')
          ..write('proteinPerUnit: $proteinPerUnit, ')
          ..write('carbsPerUnit: $carbsPerUnit, ')
          ..write('fatPerUnit: $fatPerUnit, ')
          ..write('fiberPerUnit: $fiberPerUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    category,
    measurementType,
    measurementUnit,
    caloriesPerUnit,
    proteinPerUnit,
    carbsPerUnit,
    fatPerUnit,
    fiberPerUnit,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItem &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.category == this.category &&
          other.measurementType == this.measurementType &&
          other.measurementUnit == this.measurementUnit &&
          other.caloriesPerUnit == this.caloriesPerUnit &&
          other.proteinPerUnit == this.proteinPerUnit &&
          other.carbsPerUnit == this.carbsPerUnit &&
          other.fatPerUnit == this.fatPerUnit &&
          other.fiberPerUnit == this.fiberPerUnit &&
          other.createdAt == this.createdAt);
}

class FoodItemsCompanion extends UpdateCompanion<FoodItem> {
  final Value<int> id;
  final Value<int?> userId;
  final Value<String> name;
  final Value<String?> category;
  final Value<String> measurementType;
  final Value<String> measurementUnit;
  final Value<double> caloriesPerUnit;
  final Value<double> proteinPerUnit;
  final Value<double> carbsPerUnit;
  final Value<double> fatPerUnit;
  final Value<double> fiberPerUnit;
  final Value<DateTime> createdAt;
  const FoodItemsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.measurementType = const Value.absent(),
    this.measurementUnit = const Value.absent(),
    this.caloriesPerUnit = const Value.absent(),
    this.proteinPerUnit = const Value.absent(),
    this.carbsPerUnit = const Value.absent(),
    this.fatPerUnit = const Value.absent(),
    this.fiberPerUnit = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FoodItemsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String name,
    this.category = const Value.absent(),
    required String measurementType,
    required String measurementUnit,
    required double caloriesPerUnit,
    required double proteinPerUnit,
    required double carbsPerUnit,
    required double fatPerUnit,
    required double fiberPerUnit,
    required DateTime createdAt,
  }) : name = Value(name),
       measurementType = Value(measurementType),
       measurementUnit = Value(measurementUnit),
       caloriesPerUnit = Value(caloriesPerUnit),
       proteinPerUnit = Value(proteinPerUnit),
       carbsPerUnit = Value(carbsPerUnit),
       fatPerUnit = Value(fatPerUnit),
       fiberPerUnit = Value(fiberPerUnit),
       createdAt = Value(createdAt);
  static Insertable<FoodItem> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? measurementType,
    Expression<String>? measurementUnit,
    Expression<double>? caloriesPerUnit,
    Expression<double>? proteinPerUnit,
    Expression<double>? carbsPerUnit,
    Expression<double>? fatPerUnit,
    Expression<double>? fiberPerUnit,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (measurementType != null) 'measurement_type': measurementType,
      if (measurementUnit != null) 'measurement_unit': measurementUnit,
      if (caloriesPerUnit != null) 'calories_per_unit': caloriesPerUnit,
      if (proteinPerUnit != null) 'protein_per_unit': proteinPerUnit,
      if (carbsPerUnit != null) 'carbs_per_unit': carbsPerUnit,
      if (fatPerUnit != null) 'fat_per_unit': fatPerUnit,
      if (fiberPerUnit != null) 'fiber_per_unit': fiberPerUnit,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FoodItemsCompanion copyWith({
    Value<int>? id,
    Value<int?>? userId,
    Value<String>? name,
    Value<String?>? category,
    Value<String>? measurementType,
    Value<String>? measurementUnit,
    Value<double>? caloriesPerUnit,
    Value<double>? proteinPerUnit,
    Value<double>? carbsPerUnit,
    Value<double>? fatPerUnit,
    Value<double>? fiberPerUnit,
    Value<DateTime>? createdAt,
  }) {
    return FoodItemsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      category: category ?? this.category,
      measurementType: measurementType ?? this.measurementType,
      measurementUnit: measurementUnit ?? this.measurementUnit,
      caloriesPerUnit: caloriesPerUnit ?? this.caloriesPerUnit,
      proteinPerUnit: proteinPerUnit ?? this.proteinPerUnit,
      carbsPerUnit: carbsPerUnit ?? this.carbsPerUnit,
      fatPerUnit: fatPerUnit ?? this.fatPerUnit,
      fiberPerUnit: fiberPerUnit ?? this.fiberPerUnit,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (measurementType.present) {
      map['measurement_type'] = Variable<String>(measurementType.value);
    }
    if (measurementUnit.present) {
      map['measurement_unit'] = Variable<String>(measurementUnit.value);
    }
    if (caloriesPerUnit.present) {
      map['calories_per_unit'] = Variable<double>(caloriesPerUnit.value);
    }
    if (proteinPerUnit.present) {
      map['protein_per_unit'] = Variable<double>(proteinPerUnit.value);
    }
    if (carbsPerUnit.present) {
      map['carbs_per_unit'] = Variable<double>(carbsPerUnit.value);
    }
    if (fatPerUnit.present) {
      map['fat_per_unit'] = Variable<double>(fatPerUnit.value);
    }
    if (fiberPerUnit.present) {
      map['fiber_per_unit'] = Variable<double>(fiberPerUnit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('measurementType: $measurementType, ')
          ..write('measurementUnit: $measurementUnit, ')
          ..write('caloriesPerUnit: $caloriesPerUnit, ')
          ..write('proteinPerUnit: $proteinPerUnit, ')
          ..write('carbsPerUnit: $carbsPerUnit, ')
          ..write('fatPerUnit: $fatPerUnit, ')
          ..write('fiberPerUnit: $fiberPerUnit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FoodLogsTable extends FoodLogs with TableInfo<$FoodLogsTable, FoodLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _foodItemIdMeta = const VerificationMeta(
    'foodItemId',
  );
  @override
  late final GeneratedColumn<int> foodItemId = GeneratedColumn<int>(
    'food_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES food_items (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedDateMeta = const VerificationMeta(
    'loggedDate',
  );
  @override
  late final GeneratedColumn<DateTime> loggedDate = GeneratedColumn<DateTime>(
    'logged_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loggedTimeMeta = const VerificationMeta(
    'loggedTime',
  );
  @override
  late final GeneratedColumn<DateTime> loggedTime = GeneratedColumn<DateTime>(
    'logged_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberMeta = const VerificationMeta('fiber');
  @override
  late final GeneratedColumn<double> fiber = GeneratedColumn<double>(
    'fiber',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    foodItemId,
    quantity,
    loggedDate,
    loggedTime,
    calories,
    protein,
    carbs,
    fat,
    fiber,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('food_item_id')) {
      context.handle(
        _foodItemIdMeta,
        foodItemId.isAcceptableOrUnknown(
          data['food_item_id']!,
          _foodItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodItemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('logged_date')) {
      context.handle(
        _loggedDateMeta,
        loggedDate.isAcceptableOrUnknown(data['logged_date']!, _loggedDateMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedDateMeta);
    }
    if (data.containsKey('logged_time')) {
      context.handle(
        _loggedTimeMeta,
        loggedTime.isAcceptableOrUnknown(data['logged_time']!, _loggedTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedTimeMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('fiber')) {
      context.handle(
        _fiberMeta,
        fiber.isAcceptableOrUnknown(data['fiber']!, _fiberMeta),
      );
    } else if (isInserting) {
      context.missing(_fiberMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      foodItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_item_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      loggedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_date'],
      )!,
      loggedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_time'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      fiber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FoodLogsTable createAlias(String alias) {
    return $FoodLogsTable(attachedDatabase, alias);
  }
}

class FoodLog extends DataClass implements Insertable<FoodLog> {
  final int id;
  final int? userId;
  final int foodItemId;
  final double quantity;
  final DateTime loggedDate;
  final DateTime loggedTime;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final DateTime createdAt;
  const FoodLog({
    required this.id,
    this.userId,
    required this.foodItemId,
    required this.quantity,
    required this.loggedDate,
    required this.loggedTime,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['food_item_id'] = Variable<int>(foodItemId);
    map['quantity'] = Variable<double>(quantity);
    map['logged_date'] = Variable<DateTime>(loggedDate);
    map['logged_time'] = Variable<DateTime>(loggedTime);
    map['calories'] = Variable<double>(calories);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    map['fiber'] = Variable<double>(fiber);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FoodLogsCompanion toCompanion(bool nullToAbsent) {
    return FoodLogsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      foodItemId: Value(foodItemId),
      quantity: Value(quantity),
      loggedDate: Value(loggedDate),
      loggedTime: Value(loggedTime),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      fiber: Value(fiber),
      createdAt: Value(createdAt),
    );
  }

  factory FoodLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodLog(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      foodItemId: serializer.fromJson<int>(json['foodItemId']),
      quantity: serializer.fromJson<double>(json['quantity']),
      loggedDate: serializer.fromJson<DateTime>(json['loggedDate']),
      loggedTime: serializer.fromJson<DateTime>(json['loggedTime']),
      calories: serializer.fromJson<double>(json['calories']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
      fiber: serializer.fromJson<double>(json['fiber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int?>(userId),
      'foodItemId': serializer.toJson<int>(foodItemId),
      'quantity': serializer.toJson<double>(quantity),
      'loggedDate': serializer.toJson<DateTime>(loggedDate),
      'loggedTime': serializer.toJson<DateTime>(loggedTime),
      'calories': serializer.toJson<double>(calories),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
      'fiber': serializer.toJson<double>(fiber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FoodLog copyWith({
    int? id,
    Value<int?> userId = const Value.absent(),
    int? foodItemId,
    double? quantity,
    DateTime? loggedDate,
    DateTime? loggedTime,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    double? fiber,
    DateTime? createdAt,
  }) => FoodLog(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    foodItemId: foodItemId ?? this.foodItemId,
    quantity: quantity ?? this.quantity,
    loggedDate: loggedDate ?? this.loggedDate,
    loggedTime: loggedTime ?? this.loggedTime,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    fiber: fiber ?? this.fiber,
    createdAt: createdAt ?? this.createdAt,
  );
  FoodLog copyWithCompanion(FoodLogsCompanion data) {
    return FoodLog(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      foodItemId: data.foodItemId.present
          ? data.foodItemId.value
          : this.foodItemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      loggedDate: data.loggedDate.present
          ? data.loggedDate.value
          : this.loggedDate,
      loggedTime: data.loggedTime.present
          ? data.loggedTime.value
          : this.loggedTime,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      fiber: data.fiber.present ? data.fiber.value : this.fiber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodLog(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('foodItemId: $foodItemId, ')
          ..write('quantity: $quantity, ')
          ..write('loggedDate: $loggedDate, ')
          ..write('loggedTime: $loggedTime, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('fiber: $fiber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    foodItemId,
    quantity,
    loggedDate,
    loggedTime,
    calories,
    protein,
    carbs,
    fat,
    fiber,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodLog &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.foodItemId == this.foodItemId &&
          other.quantity == this.quantity &&
          other.loggedDate == this.loggedDate &&
          other.loggedTime == this.loggedTime &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.fiber == this.fiber &&
          other.createdAt == this.createdAt);
}

class FoodLogsCompanion extends UpdateCompanion<FoodLog> {
  final Value<int> id;
  final Value<int?> userId;
  final Value<int> foodItemId;
  final Value<double> quantity;
  final Value<DateTime> loggedDate;
  final Value<DateTime> loggedTime;
  final Value<double> calories;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fat;
  final Value<double> fiber;
  final Value<DateTime> createdAt;
  const FoodLogsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.foodItemId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.loggedDate = const Value.absent(),
    this.loggedTime = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.fiber = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FoodLogsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required int foodItemId,
    required double quantity,
    required DateTime loggedDate,
    required DateTime loggedTime,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    required double fiber,
    required DateTime createdAt,
  }) : foodItemId = Value(foodItemId),
       quantity = Value(quantity),
       loggedDate = Value(loggedDate),
       loggedTime = Value(loggedTime),
       calories = Value(calories),
       protein = Value(protein),
       carbs = Value(carbs),
       fat = Value(fat),
       fiber = Value(fiber),
       createdAt = Value(createdAt);
  static Insertable<FoodLog> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? foodItemId,
    Expression<double>? quantity,
    Expression<DateTime>? loggedDate,
    Expression<DateTime>? loggedTime,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<double>? fiber,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (foodItemId != null) 'food_item_id': foodItemId,
      if (quantity != null) 'quantity': quantity,
      if (loggedDate != null) 'logged_date': loggedDate,
      if (loggedTime != null) 'logged_time': loggedTime,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (fiber != null) 'fiber': fiber,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FoodLogsCompanion copyWith({
    Value<int>? id,
    Value<int?>? userId,
    Value<int>? foodItemId,
    Value<double>? quantity,
    Value<DateTime>? loggedDate,
    Value<DateTime>? loggedTime,
    Value<double>? calories,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fat,
    Value<double>? fiber,
    Value<DateTime>? createdAt,
  }) {
    return FoodLogsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      foodItemId: foodItemId ?? this.foodItemId,
      quantity: quantity ?? this.quantity,
      loggedDate: loggedDate ?? this.loggedDate,
      loggedTime: loggedTime ?? this.loggedTime,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (foodItemId.present) {
      map['food_item_id'] = Variable<int>(foodItemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (loggedDate.present) {
      map['logged_date'] = Variable<DateTime>(loggedDate.value);
    }
    if (loggedTime.present) {
      map['logged_time'] = Variable<DateTime>(loggedTime.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (fiber.present) {
      map['fiber'] = Variable<double>(fiber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('foodItemId: $foodItemId, ')
          ..write('quantity: $quantity, ')
          ..write('loggedDate: $loggedDate, ')
          ..write('loggedTime: $loggedTime, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('fiber: $fiber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;
  final int? userId;
  final String name;
  final DateTime createdAt;
  const Meal({
    required this.id,
    this.userId,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int?>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int?>(userId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Meal copyWith({
    int? id,
    Value<int?> userId = const Value.absent(),
    String? name,
    DateTime? createdAt,
  }) => Meal(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<int?> userId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    required String name,
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<int?>? userId,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MealItemsTable extends MealItems
    with TableInfo<$MealItemsTable, MealItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meals (id)',
    ),
  );
  static const VerificationMeta _foodItemIdMeta = const VerificationMeta(
    'foodItemId',
  );
  @override
  late final GeneratedColumn<int> foodItemId = GeneratedColumn<int>(
    'food_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES food_items (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, mealId, foodItemId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('food_item_id')) {
      context.handle(
        _foodItemIdMeta,
        foodItemId.isAcceptableOrUnknown(
          data['food_item_id']!,
          _foodItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodItemIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      mealId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}meal_id'],
      )!,
      foodItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_item_id'],
      )!,
    );
  }

  @override
  $MealItemsTable createAlias(String alias) {
    return $MealItemsTable(attachedDatabase, alias);
  }
}

class MealItem extends DataClass implements Insertable<MealItem> {
  final int id;
  final int mealId;
  final int foodItemId;
  const MealItem({
    required this.id,
    required this.mealId,
    required this.foodItemId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['food_item_id'] = Variable<int>(foodItemId);
    return map;
  }

  MealItemsCompanion toCompanion(bool nullToAbsent) {
    return MealItemsCompanion(
      id: Value(id),
      mealId: Value(mealId),
      foodItemId: Value(foodItemId),
    );
  }

  factory MealItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealItem(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      foodItemId: serializer.fromJson<int>(json['foodItemId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'foodItemId': serializer.toJson<int>(foodItemId),
    };
  }

  MealItem copyWith({int? id, int? mealId, int? foodItemId}) => MealItem(
    id: id ?? this.id,
    mealId: mealId ?? this.mealId,
    foodItemId: foodItemId ?? this.foodItemId,
  );
  MealItem copyWithCompanion(MealItemsCompanion data) {
    return MealItem(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      foodItemId: data.foodItemId.present
          ? data.foodItemId.value
          : this.foodItemId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealItem(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('foodItemId: $foodItemId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealId, foodItemId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealItem &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.foodItemId == this.foodItemId);
}

class MealItemsCompanion extends UpdateCompanion<MealItem> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<int> foodItemId;
  const MealItemsCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.foodItemId = const Value.absent(),
  });
  MealItemsCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required int foodItemId,
  }) : mealId = Value(mealId),
       foodItemId = Value(foodItemId);
  static Insertable<MealItem> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<int>? foodItemId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (foodItemId != null) 'food_item_id': foodItemId,
    });
  }

  MealItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? mealId,
    Value<int>? foodItemId,
  }) {
    return MealItemsCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      foodItemId: foodItemId ?? this.foodItemId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (foodItemId.present) {
      map['food_item_id'] = Variable<int>(foodItemId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealItemsCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('foodItemId: $foodItemId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $MacroGoalsTable macroGoals = $MacroGoalsTable(this);
  late final $FoodItemsTable foodItems = $FoodItemsTable(this);
  late final $FoodLogsTable foodLogs = $FoodLogsTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $MealItemsTable mealItems = $MealItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    macroGoals,
    foodItems,
    foodLogs,
    meals,
    mealItems,
  ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  required String name,
  required int age,
  required String gender,
  required double height,
  required double currentWeight,
  required String activityLevel,
  required String goal,
  required double goalRate,
  required DateTime createdAt,
  required DateTime updatedAt,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int> age,
  Value<String> gender,
  Value<double> height,
  Value<double> currentWeight,
  Value<String> activityLevel,
  Value<String> goal,
  Value<double> goalRate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MacroGoalsTable, List<MacroGoal>>
  _macroGoalsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.macroGoals,
    aliasName: 'users__id__macro_goals__user_id',
  );

  $$MacroGoalsTableProcessedTableManager get macroGoalsRefs {
    final manager = $$MacroGoalsTableTableManager(
      $_db,
      $_db.macroGoals,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_macroGoalsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FoodItemsTable, List<FoodItem>>
  _foodItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.foodItems,
    aliasName: 'users__id__food_items__user_id',
  );

  $$FoodItemsTableProcessedTableManager get foodItemsRefs {
    final manager = $$FoodItemsTableTableManager(
      $_db,
      $_db.foodItems,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FoodLogsTable, List<FoodLog>> _foodLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.foodLogs,
    aliasName: 'users__id__food_logs__user_id',
  );

  $$FoodLogsTableProcessedTableManager get foodLogsRefs {
    final manager = $$FoodLogsTableTableManager(
      $_db,
      $_db.foodLogs,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealsTable, List<Meal>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: 'users__id__meals__user_id',
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentWeight => $composableBuilder(
    column: $table.currentWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get goalRate => $composableBuilder(
    column: $table.goalRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> macroGoalsRefs(
    Expression<bool> Function($$MacroGoalsTableFilterComposer f) f,
  ) {
    final $$MacroGoalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.macroGoals,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MacroGoalsTableFilterComposer(
            $db: $db,
            $table: $db.macroGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> foodItemsRefs(
    Expression<bool> Function($$FoodItemsTableFilterComposer f) f,
  ) {
    final $$FoodItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableFilterComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> foodLogsRefs(
    Expression<bool> Function($$FoodLogsTableFilterComposer f) f,
  ) {
    final $$FoodLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableFilterComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentWeight => $composableBuilder(
    column: $table.currentWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goal => $composableBuilder(
    column: $table.goal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get goalRate => $composableBuilder(
    column: $table.goalRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<double> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);

  GeneratedColumn<double> get currentWeight => $composableBuilder(
    column: $table.currentWeight,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goal =>
      $composableBuilder(column: $table.goal, builder: (column) => column);

  GeneratedColumn<double> get goalRate =>
      $composableBuilder(column: $table.goalRate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> macroGoalsRefs<T extends Object>(
    Expression<T> Function($$MacroGoalsTableAnnotationComposer a) f,
  ) {
    final $$MacroGoalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.macroGoals,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MacroGoalsTableAnnotationComposer(
            $db: $db,
            $table: $db.macroGoals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> foodItemsRefs<T extends Object>(
    Expression<T> Function($$FoodItemsTableAnnotationComposer a) f,
  ) {
    final $$FoodItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> foodLogsRefs<T extends Object>(
    Expression<T> Function($$FoodLogsTableAnnotationComposer a) f,
  ) {
    final $$FoodLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({
            bool macroGoalsRefs,
            bool foodItemsRefs,
            bool foodLogsRefs,
            bool mealsRefs,
          })
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String> gender = const Value.absent(),
                Value<double> height = const Value.absent(),
                Value<double> currentWeight = const Value.absent(),
                Value<String> activityLevel = const Value.absent(),
                Value<String> goal = const Value.absent(),
                Value<double> goalRate = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                name: name,
                age: age,
                gender: gender,
                height: height,
                currentWeight: currentWeight,
                activityLevel: activityLevel,
                goal: goal,
                goalRate: goalRate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int age,
                required String gender,
                required double height,
                required double currentWeight,
                required String activityLevel,
                required String goal,
                required double goalRate,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => UsersCompanion.insert(
                id: id,
                name: name,
                age: age,
                gender: gender,
                height: height,
                currentWeight: currentWeight,
                activityLevel: activityLevel,
                goal: goal,
                goalRate: goalRate,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UsersTable, User>(table),
                  $$UsersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                macroGoalsRefs = false,
                foodItemsRefs = false,
                foodLogsRefs = false,
                mealsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (macroGoalsRefs) db.macroGoals,
                    if (foodItemsRefs) db.foodItems,
                    if (foodLogsRefs) db.foodLogs,
                    if (mealsRefs) db.meals,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (macroGoalsRefs)
                        await $_getPrefetchedData<User, $UsersTable, MacroGoal>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._macroGoalsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).macroGoalsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (foodItemsRefs)
                        await $_getPrefetchedData<User, $UsersTable, FoodItem>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._foodItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).foodItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (foodLogsRefs)
                        await $_getPrefetchedData<User, $UsersTable, FoodLog>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._foodLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(
                                db,
                                table,
                                p0,
                              ).foodLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealsRefs)
                        await $_getPrefetchedData<User, $UsersTable, Meal>(
                          currentTable: table,
                          referencedTable: $$UsersTableReferences
                              ._mealsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UsersTableReferences(db, table, p0).mealsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.userId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({
        bool macroGoalsRefs,
        bool foodItemsRefs,
        bool foodLogsRefs,
        bool mealsRefs,
      })
    >;
typedef $$MacroGoalsTableCreateCompanionBuilder = MacroGoalsCompanion Function({
  Value<int> id,
  required int userId,
  required int caloriesTarget,
  required double proteinTarget,
  required double carbsTarget,
  required double fatTarget,
  required double fiberTarget,
  required DateTime updatedAt,
});
typedef $$MacroGoalsTableUpdateCompanionBuilder = MacroGoalsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> caloriesTarget,
  Value<double> proteinTarget,
  Value<double> carbsTarget,
  Value<double> fatTarget,
  Value<double> fiberTarget,
  Value<DateTime> updatedAt,
});

final class $$MacroGoalsTableReferences
    extends BaseReferences<_$AppDatabase, $MacroGoalsTable, MacroGoal> {
  $$MacroGoalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('macro_goals__user_id__users__id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<int>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MacroGoalsTableFilterComposer
    extends Composer<_$AppDatabase, $MacroGoalsTable> {
  $$MacroGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caloriesTarget => $composableBuilder(
    column: $table.caloriesTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsTarget => $composableBuilder(
    column: $table.carbsTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatTarget => $composableBuilder(
    column: $table.fatTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberTarget => $composableBuilder(
    column: $table.fiberTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MacroGoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $MacroGoalsTable> {
  $$MacroGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caloriesTarget => $composableBuilder(
    column: $table.caloriesTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsTarget => $composableBuilder(
    column: $table.carbsTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatTarget => $composableBuilder(
    column: $table.fatTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberTarget => $composableBuilder(
    column: $table.fiberTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MacroGoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MacroGoalsTable> {
  $$MacroGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get caloriesTarget => $composableBuilder(
    column: $table.caloriesTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinTarget => $composableBuilder(
    column: $table.proteinTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsTarget => $composableBuilder(
    column: $table.carbsTarget,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatTarget =>
      $composableBuilder(column: $table.fatTarget, builder: (column) => column);

  GeneratedColumn<double> get fiberTarget => $composableBuilder(
    column: $table.fiberTarget,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MacroGoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MacroGoalsTable,
          MacroGoal,
          $$MacroGoalsTableFilterComposer,
          $$MacroGoalsTableOrderingComposer,
          $$MacroGoalsTableAnnotationComposer,
          $$MacroGoalsTableCreateCompanionBuilder,
          $$MacroGoalsTableUpdateCompanionBuilder,
          (MacroGoal, $$MacroGoalsTableReferences),
          MacroGoal,
          PrefetchHooks Function({bool userId})
        > {
  $$MacroGoalsTableTableManager(_$AppDatabase db, $MacroGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MacroGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MacroGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MacroGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> caloriesTarget = const Value.absent(),
                Value<double> proteinTarget = const Value.absent(),
                Value<double> carbsTarget = const Value.absent(),
                Value<double> fatTarget = const Value.absent(),
                Value<double> fiberTarget = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => MacroGoalsCompanion(
                id: id,
                userId: userId,
                caloriesTarget: caloriesTarget,
                proteinTarget: proteinTarget,
                carbsTarget: carbsTarget,
                fatTarget: fatTarget,
                fiberTarget: fiberTarget,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int caloriesTarget,
                required double proteinTarget,
                required double carbsTarget,
                required double fatTarget,
                required double fiberTarget,
                required DateTime updatedAt,
              }) => MacroGoalsCompanion.insert(
                id: id,
                userId: userId,
                caloriesTarget: caloriesTarget,
                proteinTarget: proteinTarget,
                carbsTarget: carbsTarget,
                fatTarget: fatTarget,
                fiberTarget: fiberTarget,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MacroGoalsTable, MacroGoal>(table),
                  $$MacroGoalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$MacroGoalsTableReferences
                            ._userIdTable(db),
                        referencedColumn: $$MacroGoalsTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MacroGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MacroGoalsTable,
      MacroGoal,
      $$MacroGoalsTableFilterComposer,
      $$MacroGoalsTableOrderingComposer,
      $$MacroGoalsTableAnnotationComposer,
      $$MacroGoalsTableCreateCompanionBuilder,
      $$MacroGoalsTableUpdateCompanionBuilder,
      (MacroGoal, $$MacroGoalsTableReferences),
      MacroGoal,
      PrefetchHooks Function({bool userId})
    >;
typedef $$FoodItemsTableCreateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  Value<int?> userId,
  required String name,
  Value<String?> category,
  required String measurementType,
  required String measurementUnit,
  required double caloriesPerUnit,
  required double proteinPerUnit,
  required double carbsPerUnit,
  required double fatPerUnit,
  required double fiberPerUnit,
  required DateTime createdAt,
});
typedef $$FoodItemsTableUpdateCompanionBuilder = FoodItemsCompanion Function({
  Value<int> id,
  Value<int?> userId,
  Value<String> name,
  Value<String?> category,
  Value<String> measurementType,
  Value<String> measurementUnit,
  Value<double> caloriesPerUnit,
  Value<double> proteinPerUnit,
  Value<double> carbsPerUnit,
  Value<double> fatPerUnit,
  Value<double> fiberPerUnit,
  Value<DateTime> createdAt,
});

final class $$FoodItemsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodItemsTable, FoodItem> {
  $$FoodItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('food_items__user_id__users__id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FoodLogsTable, List<FoodLog>> _foodLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.foodLogs,
    aliasName: 'food_items__id__food_logs__food_item_id',
  );

  $$FoodLogsTableProcessedTableManager get foodLogsRefs {
    final manager = $$FoodLogsTableTableManager(
      $_db,
      $_db.foodLogs,
    ).filter((f) => f.foodItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealItemsTable, List<MealItem>>
  _mealItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealItems,
    aliasName: 'food_items__id__meal_items__food_item_id',
  );

  $$MealItemsTableProcessedTableManager get mealItemsRefs {
    final manager = $$MealItemsTableTableManager(
      $_db,
      $_db.mealItems,
    ).filter((f) => f.foodItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoodItemsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementType => $composableBuilder(
    column: $table.measurementType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementUnit => $composableBuilder(
    column: $table.measurementUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesPerUnit => $composableBuilder(
    column: $table.caloriesPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinPerUnit => $composableBuilder(
    column: $table.proteinPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsPerUnit => $composableBuilder(
    column: $table.carbsPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatPerUnit => $composableBuilder(
    column: $table.fatPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiberPerUnit => $composableBuilder(
    column: $table.fiberPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> foodLogsRefs(
    Expression<bool> Function($$FoodLogsTableFilterComposer f) f,
  ) {
    final $$FoodLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.foodItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableFilterComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealItemsRefs(
    Expression<bool> Function($$MealItemsTableFilterComposer f) f,
  ) {
    final $$MealItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealItems,
      getReferencedColumn: (t) => t.foodItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealItemsTableFilterComposer(
            $db: $db,
            $table: $db.mealItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementType => $composableBuilder(
    column: $table.measurementType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementUnit => $composableBuilder(
    column: $table.measurementUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesPerUnit => $composableBuilder(
    column: $table.caloriesPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinPerUnit => $composableBuilder(
    column: $table.proteinPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsPerUnit => $composableBuilder(
    column: $table.carbsPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatPerUnit => $composableBuilder(
    column: $table.fatPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiberPerUnit => $composableBuilder(
    column: $table.fiberPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemsTable> {
  $$FoodItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get measurementType => $composableBuilder(
    column: $table.measurementType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get measurementUnit => $composableBuilder(
    column: $table.measurementUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get caloriesPerUnit => $composableBuilder(
    column: $table.caloriesPerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinPerUnit => $composableBuilder(
    column: $table.proteinPerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsPerUnit => $composableBuilder(
    column: $table.carbsPerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatPerUnit => $composableBuilder(
    column: $table.fatPerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fiberPerUnit => $composableBuilder(
    column: $table.fiberPerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> foodLogsRefs<T extends Object>(
    Expression<T> Function($$FoodLogsTableAnnotationComposer a) f,
  ) {
    final $$FoodLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.foodItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealItemsRefs<T extends Object>(
    Expression<T> Function($$MealItemsTableAnnotationComposer a) f,
  ) {
    final $$MealItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealItems,
      getReferencedColumn: (t) => t.foodItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodItemsTable,
          FoodItem,
          $$FoodItemsTableFilterComposer,
          $$FoodItemsTableOrderingComposer,
          $$FoodItemsTableAnnotationComposer,
          $$FoodItemsTableCreateCompanionBuilder,
          $$FoodItemsTableUpdateCompanionBuilder,
          (FoodItem, $$FoodItemsTableReferences),
          FoodItem,
          PrefetchHooks Function({
            bool userId,
            bool foodLogsRefs,
            bool mealItemsRefs,
          })
        > {
  $$FoodItemsTableTableManager(_$AppDatabase db, $FoodItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String> measurementType = const Value.absent(),
                Value<String> measurementUnit = const Value.absent(),
                Value<double> caloriesPerUnit = const Value.absent(),
                Value<double> proteinPerUnit = const Value.absent(),
                Value<double> carbsPerUnit = const Value.absent(),
                Value<double> fatPerUnit = const Value.absent(),
                Value<double> fiberPerUnit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FoodItemsCompanion(
                id: id,
                userId: userId,
                name: name,
                category: category,
                measurementType: measurementType,
                measurementUnit: measurementUnit,
                caloriesPerUnit: caloriesPerUnit,
                proteinPerUnit: proteinPerUnit,
                carbsPerUnit: carbsPerUnit,
                fatPerUnit: fatPerUnit,
                fiberPerUnit: fiberPerUnit,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                required String name,
                Value<String?> category = const Value.absent(),
                required String measurementType,
                required String measurementUnit,
                required double caloriesPerUnit,
                required double proteinPerUnit,
                required double carbsPerUnit,
                required double fatPerUnit,
                required double fiberPerUnit,
                required DateTime createdAt,
              }) => FoodItemsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                category: category,
                measurementType: measurementType,
                measurementUnit: measurementUnit,
                caloriesPerUnit: caloriesPerUnit,
                proteinPerUnit: proteinPerUnit,
                carbsPerUnit: carbsPerUnit,
                fatPerUnit: fatPerUnit,
                fiberPerUnit: fiberPerUnit,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodItemsTable, FoodItem>(table),
                  $$FoodItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({userId = false, foodLogsRefs = false, mealItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (foodLogsRefs) db.foodLogs,
                    if (mealItemsRefs) db.mealItems,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.userId,
                            referencedTable: $$FoodItemsTableReferences
                                ._userIdTable(db),
                            referencedColumn: $$FoodItemsTableReferences
                                ._userIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (foodLogsRefs)
                        await $_getPrefetchedData<
                          FoodItem,
                          $FoodItemsTable,
                          FoodLog
                        >(
                          currentTable: table,
                          referencedTable: $$FoodItemsTableReferences
                              ._foodLogsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FoodItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).foodLogsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.foodItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealItemsRefs)
                        await $_getPrefetchedData<
                          FoodItem,
                          $FoodItemsTable,
                          MealItem
                        >(
                          currentTable: table,
                          referencedTable: $$FoodItemsTableReferences
                              ._mealItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FoodItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).mealItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.foodItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FoodItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodItemsTable,
      FoodItem,
      $$FoodItemsTableFilterComposer,
      $$FoodItemsTableOrderingComposer,
      $$FoodItemsTableAnnotationComposer,
      $$FoodItemsTableCreateCompanionBuilder,
      $$FoodItemsTableUpdateCompanionBuilder,
      (FoodItem, $$FoodItemsTableReferences),
      FoodItem,
      PrefetchHooks Function({
        bool userId,
        bool foodLogsRefs,
        bool mealItemsRefs,
      })
    >;
typedef $$FoodLogsTableCreateCompanionBuilder = FoodLogsCompanion Function({
  Value<int> id,
  Value<int?> userId,
  required int foodItemId,
  required double quantity,
  required DateTime loggedDate,
  required DateTime loggedTime,
  required double calories,
  required double protein,
  required double carbs,
  required double fat,
  required double fiber,
  required DateTime createdAt,
});
typedef $$FoodLogsTableUpdateCompanionBuilder = FoodLogsCompanion Function({
  Value<int> id,
  Value<int?> userId,
  Value<int> foodItemId,
  Value<double> quantity,
  Value<DateTime> loggedDate,
  Value<DateTime> loggedTime,
  Value<double> calories,
  Value<double> protein,
  Value<double> carbs,
  Value<double> fat,
  Value<double> fiber,
  Value<DateTime> createdAt,
});

final class $$FoodLogsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodLogsTable, FoodLog> {
  $$FoodLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('food_logs__user_id__users__id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FoodItemsTable _foodItemIdTable(_$AppDatabase db) =>
      db.foodItems.createAlias('food_logs__food_item_id__food_items__id');

  $$FoodItemsTableProcessedTableManager get foodItemId {
    final $_column = $_itemColumn<int>('food_item_id')!;

    final manager = $$FoodItemsTableTableManager(
      $_db,
      $_db.foodItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FoodLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedTime => $composableBuilder(
    column: $table.loggedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiber => $composableBuilder(
    column: $table.fiber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemsTableFilterComposer get foodItemId {
    final $$FoodItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodItemId,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableFilterComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedTime => $composableBuilder(
    column: $table.loggedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiber => $composableBuilder(
    column: $table.fiber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemsTableOrderingComposer get foodItemId {
    final $$FoodItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodItemId,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableOrderingComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedDate => $composableBuilder(
    column: $table.loggedDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get loggedTime => $composableBuilder(
    column: $table.loggedTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemsTableAnnotationComposer get foodItemId {
    final $$FoodItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodItemId,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodLogsTable,
          FoodLog,
          $$FoodLogsTableFilterComposer,
          $$FoodLogsTableOrderingComposer,
          $$FoodLogsTableAnnotationComposer,
          $$FoodLogsTableCreateCompanionBuilder,
          $$FoodLogsTableUpdateCompanionBuilder,
          (FoodLog, $$FoodLogsTableReferences),
          FoodLog,
          PrefetchHooks Function({bool userId, bool foodItemId})
        > {
  $$FoodLogsTableTableManager(_$AppDatabase db, $FoodLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<int> foodItemId = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<DateTime> loggedDate = const Value.absent(),
                Value<DateTime> loggedTime = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<double> fiber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FoodLogsCompanion(
                id: id,
                userId: userId,
                foodItemId: foodItemId,
                quantity: quantity,
                loggedDate: loggedDate,
                loggedTime: loggedTime,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                fiber: fiber,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                required int foodItemId,
                required double quantity,
                required DateTime loggedDate,
                required DateTime loggedTime,
                required double calories,
                required double protein,
                required double carbs,
                required double fat,
                required double fiber,
                required DateTime createdAt,
              }) => FoodLogsCompanion.insert(
                id: id,
                userId: userId,
                foodItemId: foodItemId,
                quantity: quantity,
                loggedDate: loggedDate,
                loggedTime: loggedTime,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                fiber: fiber,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FoodLogsTable, FoodLog>(table),
                  $$FoodLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, foodItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$FoodLogsTableReferences._userIdTable(
                          db,
                        ),
                        referencedColumn: $$FoodLogsTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (foodItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.foodItemId,
                        referencedTable: $$FoodLogsTableReferences
                            ._foodItemIdTable(db),
                        referencedColumn: $$FoodLogsTableReferences
                            ._foodItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FoodLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodLogsTable,
      FoodLog,
      $$FoodLogsTableFilterComposer,
      $$FoodLogsTableOrderingComposer,
      $$FoodLogsTableAnnotationComposer,
      $$FoodLogsTableCreateCompanionBuilder,
      $$FoodLogsTableUpdateCompanionBuilder,
      (FoodLog, $$FoodLogsTableReferences),
      FoodLog,
      PrefetchHooks Function({bool userId, bool foodItemId})
    >;
typedef $$MealsTableCreateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<int?> userId,
  required String name,
  required DateTime createdAt,
});
typedef $$MealsTableUpdateCompanionBuilder = MealsCompanion Function({
  Value<int> id,
  Value<int?> userId,
  Value<String> name,
  Value<DateTime> createdAt,
});

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, Meal> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('meals__user_id__users__id');

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MealItemsTable, List<MealItem>>
  _mealItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealItems,
    aliasName: 'meals__id__meal_items__meal_id',
  );

  $$MealItemsTableProcessedTableManager get mealItemsRefs {
    final manager = $$MealItemsTableTableManager(
      $_db,
      $_db.mealItems,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mealItemsRefs(
    Expression<bool> Function($$MealItemsTableFilterComposer f) f,
  ) {
    final $$MealItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealItemsTableFilterComposer(
            $db: $db,
            $table: $db.mealItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mealItemsRefs<T extends Object>(
    Expression<T> Function($$MealItemsTableAnnotationComposer a) f,
  ) {
    final $$MealItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealItems,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, $$MealsTableReferences),
          Meal,
          PrefetchHooks Function({bool userId, bool mealItemsRefs})
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                userId: userId,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                required String name,
                required DateTime createdAt,
              }) => MealsCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealsTable, Meal>(table),
                  $$MealsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({userId = false, mealItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealItemsRefs) db.mealItems],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (userId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.userId,
                        referencedTable: $$MealsTableReferences._userIdTable(
                          db,
                        ),
                        referencedColumn: $$MealsTableReferences
                            ._userIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealItemsRefs)
                    await $_getPrefetchedData<Meal, $MealsTable, MealItem>(
                      currentTable: table,
                      referencedTable: $$MealsTableReferences
                          ._mealItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MealsTableReferences(db, table, p0).mealItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.mealId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, $$MealsTableReferences),
      Meal,
      PrefetchHooks Function({bool userId, bool mealItemsRefs})
    >;
typedef $$MealItemsTableCreateCompanionBuilder = MealItemsCompanion Function({
  Value<int> id,
  required int mealId,
  required int foodItemId,
});
typedef $$MealItemsTableUpdateCompanionBuilder = MealItemsCompanion Function({
  Value<int> id,
  Value<int> mealId,
  Value<int> foodItemId,
});

final class $$MealItemsTableReferences
    extends BaseReferences<_$AppDatabase, $MealItemsTable, MealItem> {
  $$MealItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealsTable _mealIdTable(_$AppDatabase db) =>
      db.meals.createAlias('meal_items__meal_id__meals__id');

  $$MealsTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<int>('meal_id')!;

    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FoodItemsTable _foodItemIdTable(_$AppDatabase db) =>
      db.foodItems.createAlias('meal_items__food_item_id__food_items__id');

  $$FoodItemsTableProcessedTableManager get foodItemId {
    final $_column = $_itemColumn<int>('food_item_id')!;

    final manager = $$FoodItemsTableTableManager(
      $_db,
      $_db.foodItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MealItemsTable> {
  $$MealItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$MealsTableFilterComposer get mealId {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemsTableFilterComposer get foodItemId {
    final $$FoodItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodItemId,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableFilterComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealItemsTable> {
  $$MealItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealsTableOrderingComposer get mealId {
    final $$MealsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableOrderingComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemsTableOrderingComposer get foodItemId {
    final $$FoodItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodItemId,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableOrderingComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealItemsTable> {
  $$MealItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$MealsTableAnnotationComposer get mealId {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemsTableAnnotationComposer get foodItemId {
    final $$FoodItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodItemId,
      referencedTable: $db.foodItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealItemsTable,
          MealItem,
          $$MealItemsTableFilterComposer,
          $$MealItemsTableOrderingComposer,
          $$MealItemsTableAnnotationComposer,
          $$MealItemsTableCreateCompanionBuilder,
          $$MealItemsTableUpdateCompanionBuilder,
          (MealItem, $$MealItemsTableReferences),
          MealItem,
          PrefetchHooks Function({bool mealId, bool foodItemId})
        > {
  $$MealItemsTableTableManager(_$AppDatabase db, $MealItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealId = const Value.absent(),
                Value<int> foodItemId = const Value.absent(),
              }) => MealItemsCompanion(
                id: id,
                mealId: mealId,
                foodItemId: foodItemId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealId,
                required int foodItemId,
              }) => MealItemsCompanion.insert(
                id: id,
                mealId: mealId,
                foodItemId: foodItemId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealItemsTable, MealItem>(table),
                  $$MealItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealId = false, foodItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (mealId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.mealId,
                        referencedTable: $$MealItemsTableReferences
                            ._mealIdTable(db),
                        referencedColumn: $$MealItemsTableReferences
                            ._mealIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (foodItemId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.foodItemId,
                        referencedTable: $$MealItemsTableReferences
                            ._foodItemIdTable(db),
                        referencedColumn: $$MealItemsTableReferences
                            ._foodItemIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealItemsTable,
      MealItem,
      $$MealItemsTableFilterComposer,
      $$MealItemsTableOrderingComposer,
      $$MealItemsTableAnnotationComposer,
      $$MealItemsTableCreateCompanionBuilder,
      $$MealItemsTableUpdateCompanionBuilder,
      (MealItem, $$MealItemsTableReferences),
      MealItem,
      PrefetchHooks Function({bool mealId, bool foodItemId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$MacroGoalsTableTableManager get macroGoals =>
      $$MacroGoalsTableTableManager(_db, _db.macroGoals);
  $$FoodItemsTableTableManager get foodItems =>
      $$FoodItemsTableTableManager(_db, _db.foodItems);
  $$FoodLogsTableTableManager get foodLogs =>
      $$FoodLogsTableTableManager(_db, _db.foodLogs);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$MealItemsTableTableManager get mealItems =>
      $$MealItemsTableTableManager(_db, _db.mealItems);
}
