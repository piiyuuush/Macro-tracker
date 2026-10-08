import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get gender => text()();
  RealColumn get height => real()();
  RealColumn get currentWeight => real()();
  TextColumn get activityLevel => text()();
  TextColumn get goal => text()();
  RealColumn get goalRate => real()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class MacroGoals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  IntColumn get caloriesTarget => integer()();
  RealColumn get proteinTarget => real()();
  RealColumn get carbsTarget => real()();
  RealColumn get fatTarget => real()();
  RealColumn get fiberTarget => real()();
  DateTimeColumn get updatedAt => dateTime()();
}

class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id).nullable()();
  TextColumn get name => text()();
  TextColumn get category => text().nullable()();
  TextColumn get servingType => text()();
  TextColumn get measurementUnit => text()();
  RealColumn get caloriesPerUnit => real()();
  RealColumn get proteinPerUnit => real()();
  RealColumn get carbsPerUnit => real()();
  RealColumn get fatPerUnit => real()();
  RealColumn get fiberPerUnit => real()();
  DateTimeColumn get createdAt => dateTime()();
}

class FoodLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id).nullable()();
  IntColumn get foodItemId => integer().references(FoodItems, #id)();
  RealColumn get quantity => real()();
  DateTimeColumn get loggedDate => dateTime()();
  DateTimeColumn get loggedTime => dateTime()();
  RealColumn get calories => real()();
  RealColumn get protein => real()();
  RealColumn get carbs => real()();
  RealColumn get fat => real()();
  RealColumn get fiber => real()();
  DateTimeColumn get createdAt => dateTime()();
}

class Meals extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id).nullable()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
}

class MealItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get mealId => integer().references(Meals, #id)();
  IntColumn get foodItemId => integer().references(FoodItems, #id)();
}

class WeightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id).nullable()();
  RealColumn get weight => real()();
  DateTimeColumn get loggedDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Users, MacroGoals, FoodItems, FoodLogs, Meals, MealItems, WeightLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          try {
            await m.addColumn(foodItems, foodItems.servingType);
          } catch (e) {
            // Column might already exist
          }
          try {
            await m.createTable(meals);
          } catch (e) {
            // Table might already exist
          }
          try {
            await m.createTable(mealItems);
          } catch (e) {
            // Table might already exist
          }
        }
        if (from < 3) {
          try {
            await m.createTable(weightLogs);
          } catch (e) {
            // Table might already exist
          }
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'macro_tracker.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
