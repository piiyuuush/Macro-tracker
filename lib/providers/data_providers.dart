import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import 'database_provider.dart';

final foodItemsProvider = StreamProvider<List<FoodItem>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.foodItems).watch();
});

final todayLogsProvider = StreamProvider<List<FoodLog>>((ref) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd = todayStart.add(const Duration(days: 1));
  
  return (db.select(db.foodLogs)
        ..where((t) => t.loggedDate.isBiggerOrEqualValue(todayStart) & 
                       t.loggedDate.isSmallerThanValue(todayEnd)))
      .watch();
});

final mealsProvider = StreamProvider<List<Meal>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.meals).watch();
});

final userProfileProvider = StreamProvider<User?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.users)..limit(1)).watchSingleOrNull();
});

final macroGoalsProvider = StreamProvider<MacroGoal?>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.macroGoals)..limit(1)).watchSingleOrNull();
});
