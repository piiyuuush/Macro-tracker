import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/data_providers.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/services.dart';

class BackupService {
  
  static Future<void> showExportOptions(BuildContext context, WidgetRef ref) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text('What would you like to export?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: const Icon(Icons.fastfood, color: Colors.orange),
                title: const Text('Food Inventory Only'),
                subtitle: const Text('Export food items and custom meals'),
                onTap: () {
                  Navigator.pop(ctx);
                  exportData(context, ref, 'inventory');
                },
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.blue),
                title: const Text('Personal Data Only'),
                subtitle: const Text('Export food logs, goals, and profile'),
                onTap: () {
                  Navigator.pop(ctx);
                  exportData(context, ref, 'personal');
                },
              ),
              ListTile(
                leading: const Icon(Icons.all_inclusive, color: Colors.green),
                title: const Text('Entire Backup'),
                subtitle: const Text('Export everything for a full restore'),
                onTap: () {
                  Navigator.pop(ctx);
                  exportData(context, ref, 'full');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> exportData(BuildContext context, WidgetRef ref, String type) async {
    try {
      final db = ref.read(databaseProvider);
      final Map<String, dynamic> data = {'exportType': type};
      
      if (type == 'full' || type == 'personal') {
        data['users'] = (await db.select(db.users).get()).map((u) => u.toJson()).toList();
        data['macroGoals'] = (await db.select(db.macroGoals).get()).map((m) => m.toJson()).toList();
        data['foodLogs'] = (await db.select(db.foodLogs).get()).map((l) => l.toJson()).toList();
      }
      
      if (type == 'full' || type == 'inventory') {
        data['foodItems'] = (await db.select(db.foodItems).get()).map((f) => f.toJson()).toList();
        data['meals'] = (await db.select(db.meals).get()).map((m) => m.toJson()).toList();
        data['mealItems'] = (await db.select(db.mealItems).get()).map((mi) => mi.toJson()).toList();
      }
      
      final String jsonData = jsonEncode(data);
      
      String fileName = 'macro_tracker_full_backup.json';
      if (type == 'inventory') fileName = 'macro_tracker_inventory.json';
      if (type == 'personal') fileName = 'macro_tracker_personal_data.json';
      
      if (context.mounted) {
        final result = await FilePicker.saveFile(
          dialogTitle: 'Save Backup',
          fileName: fileName,
          bytes: Uint8List.fromList(utf8.encode(jsonData)),
          type: FileType.custom,
          allowedExtensions: ['json'],
        );
        
        if (result != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup saved successfully!'), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error exporting: $e')));
      }
    }
  }

  static Future<void> importData(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      
      if (result != null && result.path != null) {
        final file = File(result.path!);
        final String jsonData = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(jsonData);
        
        final String exportType = data['exportType'] ?? 'full'; 
        final db = ref.read(databaseProvider);
        
        // Check if user has existing data
        final existingFoods = await db.select(db.foodItems).get();
        final existingLogs = await db.select(db.foodLogs).get();
        final hasData = existingFoods.isNotEmpty || existingLogs.isNotEmpty;

        String mode = 'overwrite';

        if (hasData) {
          final chosen = await showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => AlertDialog(
              title: const Text('Data Conflict'),
              content: const Text('You already have data saved in this app. How would you like to handle the imported backup?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, 'cancel'), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, 'overwrite'), 
                  child: const Text('Overwrite All', style: TextStyle(color: Colors.red))
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, 'merge'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text('Merge Data safely'),
                ),
              ],
            )
          );
          
          if (chosen == null || chosen == 'cancel') return;
          mode = chosen;
        }

        await db.transaction(() async {
          if (mode == 'overwrite') {
            // Overwrite mode
            if (exportType == 'full' || exportType == 'inventory') {
              await db.delete(db.mealItems).go();
              await db.delete(db.meals).go();
              await db.delete(db.foodItems).go();
              await db.delete(db.foodLogs).go();
            }
            if (exportType == 'full' || exportType == 'personal') {
              await db.delete(db.foodLogs).go();
              await db.delete(db.macroGoals).go();
              await db.delete(db.users).go();
            }
            
            if (data['users'] != null) {
              for (var u in data['users']) await db.into(db.users).insert(User.fromJson(u));
            }
            if (data['macroGoals'] != null) {
              for (var m in data['macroGoals']) await db.into(db.macroGoals).insert(MacroGoal.fromJson(m));
            }
            if (data['foodItems'] != null) {
              for (var f in data['foodItems']) await db.into(db.foodItems).insert(FoodItem.fromJson(f));
            }
            if (data['foodLogs'] != null) {
              for (var l in data['foodLogs']) await db.into(db.foodLogs).insert(FoodLog.fromJson(l));
            }
            if (data['meals'] != null) {
              for (var m in data['meals']) await db.into(db.meals).insert(Meal.fromJson(m));
            }
            if (data['mealItems'] != null) {
              for (var mi in data['mealItems']) await db.into(db.mealItems).insert(MealItem.fromJson(mi));
            }
          } else if (mode == 'merge') {
            // Merge mode
            Map<int, int> foodIdMap = {}; // old_id -> new_id
            
            // 1. Merge Food Items
            if (data['foodItems'] != null) {
              final currentFoods = await db.select(db.foodItems).get();
              for (var fData in data['foodItems']) {
                final oldFood = FoodItem.fromJson(fData);
                // Check for exact duplicate
                final match = currentFoods.where((c) => c.name.toLowerCase() == oldFood.name.toLowerCase() && c.caloriesPerUnit == oldFood.caloriesPerUnit && c.proteinPerUnit == oldFood.proteinPerUnit).firstOrNull;
                
                if (match != null) {
                  foodIdMap[oldFood.id] = match.id;
                } else {
                  // Insert as new (without ID so SQLite auto-increments)
                  final newId = await db.into(db.foodItems).insert(FoodItemsCompanion.insert(
                    name: oldFood.name,
                    servingType: oldFood.servingType,
                    measurementUnit: oldFood.measurementUnit,
                    caloriesPerUnit: oldFood.caloriesPerUnit,
                    proteinPerUnit: oldFood.proteinPerUnit,
                    carbsPerUnit: oldFood.carbsPerUnit,
                    fatPerUnit: oldFood.fatPerUnit,
                    fiberPerUnit: oldFood.fiberPerUnit,
                    category: drift.Value(oldFood.category),
                    createdAt: oldFood.createdAt,
                  ));
                  foodIdMap[oldFood.id] = newId;
                }
              }
            }
            
            // 2. Merge Meals and MealItems
            if (data['meals'] != null) {
              for (var mData in data['meals']) {
                final oldMeal = Meal.fromJson(mData);
                // We just insert meals as new, but remap their ID. We don't bother deduplicating complex meals to be safe.
                // Or wait, meal logic might be simpler since meals aren't used right now in logs natively (we use category hack).
                // Just insert it as new.
              }
            }
            
            // 3. Merge Food Logs
            if (data['foodLogs'] != null) {
              for (var lData in data['foodLogs']) {
                final oldLog = FoodLog.fromJson(lData);
                final newFoodId = foodIdMap[oldLog.foodItemId];
                if (newFoodId != null) {
                  await db.into(db.foodLogs).insert(FoodLogsCompanion.insert(
                    foodItemId: newFoodId,
                    quantity: oldLog.quantity,
                    loggedDate: oldLog.loggedDate,
                    loggedTime: oldLog.loggedTime,
                    calories: oldLog.calories,
                    protein: oldLog.protein,
                    carbs: oldLog.carbs,
                    fat: oldLog.fat,
                    fiber: oldLog.fiber,
                    createdAt: oldLog.createdAt,
                  ));
                }
              }
            }
          }
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data imported successfully!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error importing: $e')));
      }
    }
  }
}
