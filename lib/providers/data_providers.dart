import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import 'database_provider.dart';

final foodItemsProvider = StreamProvider<List<FoodItem>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.foodItems).watch();
});

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
  
  void updateDate(DateTime date) {
    state = date;
  }
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(SelectedDateNotifier.new);

final todayLogsProvider = StreamProvider<List<FoodLog>>((ref) {
  final db = ref.watch(databaseProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  final todayStart = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
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

final currentWeekLogsProvider = StreamProvider<List<FoodLog>>((ref) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  // Calculate Monday of the current week (1 = Monday, 7 = Sunday)
  final int daysSinceMonday = now.weekday - 1;
  final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysSinceMonday));
  final nextMonday = monday.add(const Duration(days: 7));
  
  return (db.select(db.foodLogs)
        ..where((t) => t.loggedDate.isBiggerOrEqualValue(monday) & 
                       t.loggedDate.isSmallerThanValue(nextMonday)))
      .watch();
});

final allFoodLogsProvider = StreamProvider<List<FoodLog>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.select(db.foodLogs).watch();
});
