import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/data_providers.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayLogsAsync = ref.watch(todayLogsProvider);
    final macroGoalsAsync = ref.watch(macroGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: macroGoalsAsync.when(
        data: (goals) {
          if (goals == null) return const Center(child: Text('No goals set'));
          
          return todayLogsAsync.when(
            data: (logs) {
              double totalCal = 0;
              double totalProtein = 0;
              double totalCarbs = 0;
              double totalFat = 0;
              double totalFiber = 0;

              for (var log in logs) {
                totalCal += log.calories;
                totalProtein += log.protein;
                totalCarbs += log.carbs;
                totalFat += log.fat;
                totalFiber += log.fiber;
              }

              final goalCal = goals.caloriesTarget.toDouble();
          
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  height: 250,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 80,
                          startDegreeOffset: -90,
                          sections: [
                            PieChartSectionData(
                              color: Colors.redAccent,
                              value: totalCal.clamp(0, goalCal),
                              title: '',
                              radius: 20,
                            ),
                            PieChartSectionData(
                              color: Colors.grey.withValues(alpha: 0.2),
                              value: (goalCal - totalCal).clamp(0, goalCal),
                              title: '',
                              radius: 20,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${totalCal.toInt()} / ${goalCal.toInt()}',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const Text('kcal'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(child: _buildMacroStat('Protein', totalProtein, goals.proteinTarget, Colors.blue)),
                      Expanded(child: _buildMacroStat('Carbs', totalCarbs, goals.carbsTarget, Colors.yellow[700]!)),
                      Expanded(child: _buildMacroStat('Fat', totalFat, goals.fatTarget, Colors.orange)),
                      Expanded(child: _buildMacroStat('Fiber', totalFiber, goals.fiberTarget, Colors.green)),
                    ],
                  ),
                ),
                const Divider(),
                const Text('Today\'s Food Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (logs.isEmpty) const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('No food logged today.'),
                ),
                ...logs.map((log) => ListTile(
                  title: Text('Food ID: ${log.foodItemId}'), // Would join with food item name in full implementation
                  subtitle: Text('${log.quantity}g · ${log.calories} kcal'),
                  trailing: Text('${log.loggedTime.hour}:${log.loggedTime.minute.toString().padLeft(2, '0')}'),
                )),
              ],
            ),
          );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFoodLogDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFoodLogDialog(BuildContext context, WidgetRef ref) {
    final foodItemsAsync = ref.read(foodItemsProvider);
    final quantityController = TextEditingController();
    FoodItem? selectedFood;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Log Food Item'),
              content: foodItemsAsync.when(
                data: (foodItems) {
                  if (foodItems.isEmpty) {
                    return const Text('Please add food items in the Inventory first.');
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<FoodItem>(
                        isExpanded: true,
                        hint: const Text('Select Food'),
                        value: selectedFood,
                        items: foodItems.map((food) {
                          return DropdownMenuItem(
                            value: food,
                            child: Text(food.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedFood = val;
                          });
                        },
                      ),
                      TextField(
                        controller: quantityController,
                        decoration: const InputDecoration(labelText: 'Quantity (e.g., multiplier or grams)'),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, s) => Text('Error: $e'),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    final qty = double.tryParse(quantityController.text) ?? 1.0;
                    if (selectedFood != null) {
                      final db = ref.read(databaseProvider);
                      final now = DateTime.now();
                      
                      // For a multiplier quantity (e.g. 1 serving), multiply macros
                      // If it's gram-based and macros are per 100g, we'd divide by 100, 
                      // but for simplicity in MVP we assume the macro values are per "1 unit" of quantity
                      final multiplier = qty; 

                      db.into(db.foodLogs).insert(FoodLogsCompanion.insert(
                        foodItemId: selectedFood!.id,
                        quantity: qty,
                        loggedDate: DateTime(now.year, now.month, now.day),
                        loggedTime: now,
                        calories: selectedFood!.caloriesPerUnit * multiplier,
                        protein: selectedFood!.proteinPerUnit * multiplier,
                        carbs: selectedFood!.carbsPerUnit * multiplier,
                        fat: selectedFood!.fatPerUnit * multiplier,
                        fiber: selectedFood!.fiberPerUnit * multiplier,
                        createdAt: now,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildMacroStat(String label, double current, double goal, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: current / goal,
            backgroundColor: Colors.grey[200],
            color: color,
            strokeWidth: 6,
          ),
        ),
        const SizedBox(height: 8),
        Text('${current.toInt()}g'),
      ],
    );
  }
}
