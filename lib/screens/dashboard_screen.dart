
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/data_providers.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final macroGoalsAsync = ref.watch(macroGoalsProvider);
    final todayLogsAsync = ref.watch(todayLogsProvider);
    final foodItemsAsync = ref.watch(foodItemsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: macroGoalsAsync.when(
        data: (goals) {
          if (goals == null) {
            return const Center(child: Text('No goals set. Please complete onboarding.'));
          }

          return todayLogsAsync.when(
            data: (logs) {
              return foodItemsAsync.when(
                data: (foodItems) {
                  double totalCal = 0, totalProtein = 0, totalCarbs = 0, totalFat = 0, totalFiber = 0;
                  for (var log in logs) {
                    totalCal += log.calories;
                    totalProtein += log.protein;
                    totalCarbs += log.carbs;
                    totalFat += log.fat;
                    totalFiber += log.fiber;
                  }

                  final double goalCal = goals.caloriesTarget.toDouble();

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade300)),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: Stack(
                                      children: [
                                        PieChart(
                                          PieChartData(
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 70,
                                            startDegreeOffset: -90,
                                            sections: [
                                              PieChartSectionData(
                                                color: Colors.green,
                                                value: totalCal.clamp(0, goalCal),
                                                title: '',
                                                radius: 20,
                                              ),
                                              PieChartSectionData(
                                                color: Colors.grey.shade200,
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
                                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                              ),
                                              const Text('kcal', style: TextStyle(color: Colors.grey)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(child: _buildMacroStat('Protein', totalProtein, goals.proteinTarget, Colors.blue)),
                                      Expanded(child: _buildMacroStat('Carbs', totalCarbs, goals.carbsTarget, Colors.orange)),
                                      Expanded(child: _buildMacroStat('Fat', totalFat, goals.fatTarget, Colors.redAccent)),
                                      Expanded(child: _buildMacroStat('Fiber', totalFiber, goals.fiberTarget, Colors.green)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text('Today\'s Food Logs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          if (logs.isEmpty) 
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: Text('No food logged today.', style: TextStyle(color: Colors.grey))),
                            )
                          else
                            ...logs.map((log) {
                              final food = foodItems.cast<FoodItem?>().firstWhere((f) => f?.id == log.foodItemId, orElse: () => null);
                              if (food == null) return const SizedBox();
                              
                              return Card(
                                elevation: 0,
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade300)),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                                        child: Icon(food.category != null && food.category!.startsWith('Meal') ? Icons.restaurant : Icons.fastfood, color: Colors.green.shade700, size: 24),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(food.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${log.calories.toInt()} kcal · ${log.protein.toInt()}g Protein',
                                              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${log.quantity.toInt()} ${food.measurementType == 'measurable' ? 'g' : 'unit(s)'} logged at ${log.loggedTime.hour}:${log.loggedTime.minute.toString().padLeft(2, '0')}',
                                              style: TextStyle(color: Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showEditLogDialog(context, ref, log, food),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
                error: (err, stack) => Center(child: Text('Error: $err')),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => _showAddFoodLogDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDeleteLog(BuildContext context, WidgetRef ref, FoodLog log) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Log?'),
        content: const Text('Are you sure you want to remove this entry from your daily log?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () {
              ref.read(databaseProvider).delete(ref.read(databaseProvider).foodLogs).delete(log);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditLogDialog(BuildContext context, WidgetRef ref, FoodLog log, FoodItem food) {
    final quantityController = TextEditingController(text: log.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Log Quantity', style: TextStyle(fontWeight: FontWeight.bold)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Editing: ${food.name}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(
                  labelText: food.measurementType == 'measurable' ? 'Quantity (g)' : 'Quantity (units)',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () {
                Navigator.pop(context);
                _confirmDeleteLog(context, ref, log);
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                final qty = double.tryParse(quantityController.text) ?? 0.0;
                if (qty > 0) {
                  final db = ref.read(databaseProvider);
                  final multiplier = food.measurementType == 'measurable' ? (qty / 100.0) : qty; 
                  
                  await db.update(db.foodLogs).replace(log.copyWith(
                    quantity: qty,
                    calories: food.caloriesPerUnit * multiplier,
                    protein: food.proteinPerUnit * multiplier,
                    carbs: food.carbsPerUnit * multiplier,
                    fat: food.fatPerUnit * multiplier,
                    fiber: food.fiberPerUnit * multiplier,
                  ));
                  if (context.mounted) Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              child: const Text('Update'),
            ),
              ],
            ),
          ],
        );
      },
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
              title: const Text('Log Food Item', style: TextStyle(fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: foodItemsAsync.when(
                data: (foodItems) {
                  if (foodItems.isEmpty) {
                    return const Text('Please add food items in the Inventory first.');
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<FoodItem>(
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Select Food',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        value: selectedFood,
                        items: foodItems.map((food) {
                          return DropdownMenuItem(
                            value: food,
                            child: Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedFood = val;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: quantityController,
                        decoration: InputDecoration(
                          labelText: selectedFood != null && selectedFood!.measurementType == 'measurable' ? 'Quantity (g)' : 'Quantity (units)',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  );
                },
                loading: () => const CircularProgressIndicator(color: Colors.green),
                error: (e, s) => Text('Error: $e'),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                ElevatedButton(
                  onPressed: () async {
                    final qty = double.tryParse(quantityController.text) ?? 1.0;
                    if (selectedFood != null && qty > 0) {
                      final db = ref.read(databaseProvider);
                      final now = DateTime.now();
                      
                      final multiplier = selectedFood!.measurementType == 'measurable' ? (qty / 100.0) : qty; 

                      await db.into(db.foodLogs).insert(FoodLogsCompanion.insert(
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
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
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
    final bool isCompleted = goal > 0 && current >= goal;
    
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        SizedBox(
          width: 50,
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  value: goal > 0 ? (current / goal) : 0,
                  backgroundColor: Colors.grey[200],
                  color: color,
                  strokeWidth: 5,
                ),
              ),
              if (isCompleted)
                Icon(Icons.check, color: color, size: 28),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('${current.toInt()}g', style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
