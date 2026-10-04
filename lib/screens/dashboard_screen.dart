
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import '../providers/data_providers.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../widgets/app_dropdown.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final macroGoalsAsync = ref.watch(macroGoalsProvider);
    final todayLogsAsync = ref.watch(todayLogsProvider);
    final foodItemsAsync = ref.watch(foodItemsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.black : Colors.green,
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
                          _buildWeekBar(context, ref, goals),
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300)),
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
                                                color: isDark ? Colors.white12 : Colors.grey.shade200,
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
                                      Expanded(child: _buildMacroStat(context, 'Protein', totalProtein, goals.proteinTarget, Colors.blue)),
                                      Expanded(child: _buildMacroStat(context, 'Carbs', totalCarbs, goals.carbsTarget, Colors.orange)),
                                      Expanded(child: _buildMacroStat(context, 'Fat', totalFat, goals.fatTarget, Colors.redAccent)),
                                      Expanded(child: _buildMacroStat(context, 'Fiber', totalFiber, goals.fiberTarget, Colors.green)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Builder(
                            builder: (context) {
                              final selectedDate = ref.watch(selectedDateProvider);
                              final isToday = selectedDate.year == DateTime.now().year && selectedDate.day == DateTime.now().day && selectedDate.month == DateTime.now().month;
                              final title = isToday ? "Today's Food Logs" : "${DateFormat('EEEE').format(selectedDate)}'s Food Logs";
                              return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
                            }
                          ),
                          const SizedBox(height: 12),
                          if (logs.isEmpty) 
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: Text('No food logged for this day.', style: TextStyle(color: Colors.grey))),
                            )
                          else
                            ...logs.map((log) {
                              final food = foodItems.cast<FoodItem?>().firstWhere((f) => f?.id == log.foodItemId, orElse: () => null);
                              if (food == null) return const SizedBox();
                              
                              final isHiddenMeal = food.category != null && food.category!.startsWith('HiddenMeal:');
                              final isNormalMeal = food.category != null && food.category!.startsWith('Meal:');
                              final isAnyMeal = isHiddenMeal || isNormalMeal;
                              
                              List<Widget> subItems = [];
                              if (isHiddenMeal) {
                                try {
                                  final jsonStr = food.category!.replaceFirst('HiddenMeal:', '');
                                  final List<dynamic> decoded = jsonDecode(jsonStr);
                                  for (var item in decoded) {
                                    final subFood = foodItems.cast<FoodItem?>().firstWhere((f) => f?.id == item['id'], orElse: () => null);
                                    if (subFood != null) {
                                      subItems.add(Padding(
                                        padding: const EdgeInsets.only(top: 8.0, left: 40.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.subdirectory_arrow_right, size: 16, color: Colors.grey.shade500),
                                            const SizedBox(width: 8),
                                            Text(subFood.name, style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade800)),
                                            const Spacer(),
                                            Text('${item['qty']} ${subFood.servingType == 'weight' ? 'g' : (subFood.servingType == 'volume' ? 'ml' : 'x')}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      ));
                                    }
                                  }
                                } catch (_) {}
                              }
                              
                              return Card(
                                elevation: 0,
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300)),
                                child: ExpansionTile(
                                  tilePadding: const EdgeInsets.all(16.0),
                                  shape: const Border(),
                                  trailing: subItems.isNotEmpty ? null : const SizedBox.shrink(),
                                  leading: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: isDark ? Colors.green.withValues(alpha: 0.15) : Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                                    child: Icon(isAnyMeal ? Icons.restaurant : Icons.fastfood, color: isDark ? Colors.green.shade400 : Colors.green.shade700, size: 24),
                                  ),
                                  title: Text(food.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        '${log.calories.toInt()} kcal · ${log.protein.toInt()}g Protein',
                                        style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontSize: 13),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        isHiddenMeal 
                                          ? 'Logged at ${log.loggedTime.hour}:${log.loggedTime.minute.toString().padLeft(2, '0')}'
                                          : '${log.quantity.toInt()} ${food.servingType == 'weight' ? 'g' : (food.servingType == 'volume' ? 'ml' : 'x')} logged at ${log.loggedTime.hour}:${log.loggedTime.minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(color: isDark ? Colors.green.shade400 : Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    if (subItems.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                        child: Column(children: subItems),
                                      ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: TextButton.icon(
                                          icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                                          label: const Text('Edit Log', style: TextStyle(color: Colors.blue)),
                                          onPressed: () => _showEditLogDialog(context, ref, log, food),
                                        ),
                                      ),
                                    ),
                                  ],
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


  void _showEditCustomLogDialog(BuildContext context, WidgetRef ref, FoodLog log, FoodItem hiddenMeal) {
    final foodItemsAsync = ref.read(foodItemsProvider);
    
    // Parse the components
    List<Map<String, dynamic>> components = [];
    try {
      final jsonStr = hiddenMeal.category!.replaceFirst('HiddenMeal:', '');
      final List<dynamic> decoded = jsonDecode(jsonStr);
      final allFoods = foodItemsAsync.value ?? [];
      for (var item in decoded) {
        final subFood = allFoods.cast<FoodItem?>().firstWhere((f) => f?.id == item['id'], orElse: () => null);
        if (subFood != null) {
          components.add({
            'food': subFood,
            'controller': TextEditingController(text: item['qty'].toString())
          });
        }
      }
    } catch (_) {}
    
    if (components.isEmpty) {
      components.add({'food': null, 'controller': TextEditingController()});
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Custom Log', style: TextStyle(fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: foodItemsAsync.when(
                data: (foodItems) {
                  final selectableFoods = foodItems.where((f) => f.category == null || !f.category!.startsWith('HiddenMeal')).toList();
                  
                  return SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: components.length + 1,
                      itemBuilder: (context, index) {
                        if (index == components.length) {
                          return Container(
                            margin: const EdgeInsets.only(top: 4, bottom: 8),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  components.add({'food': null, 'controller': TextEditingController()});
                                });
                              },
                              icon: const Icon(Icons.add, color: Colors.green),
                              label: const Text('Add Another Item', style: TextStyle(color: Colors.green)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.green.withValues(alpha: 0.5), width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          );
                        }
                        
                        final comp = components[index];
                        final food = comp['food'] as FoodItem?;
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: AppDropdown<FoodItem>(
                                      value: food,
                                      label: 'Select Food',
                                      prefixIcon: Icons.restaurant_outlined,
                                      items: selectableFoods.map((f) {
                                        final isMeal = f.category != null && f.category!.startsWith('Meal');
                                        return AppDropdownItem<FoodItem>(
                                          value: f,
                                          label: f.name,
                                          subtitle: '${f.caloriesPerUnit.toInt()} kcal',
                                          icon: isMeal ? Icons.restaurant_rounded : Icons.fastfood_rounded,
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null && val.category != null && val.category!.startsWith('Meal')) {
                                          setState(() {
                                            components.removeAt(index);
                                            final jsonStr = val.category!.replaceFirst('Meal:', '');
                                            try {
                                              final List<dynamic> decoded = jsonDecode(jsonStr);
                                              int insertIdx = index;
                                              for (var item in decoded) {
                                                final subFood = foodItems.firstWhere((f) => f.id == item['id']);
                                                components.insert(insertIdx, {
                                                  'food': subFood,
                                                  'controller': TextEditingController(text: item['qty'].toString())
                                                });
                                                insertIdx++;
                                              }
                                            } catch (_) {}
                                            if (components.isEmpty) {
                                              components.add({'food': null, 'controller': TextEditingController()});
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            components[index]['food'] = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  if (components.length > 1)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.redAccent),
                                        onPressed: () {
                                          setState(() {
                                            components.removeAt(index);
                                          });
                                        },
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    'Quantity:',
                                    style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 130,
                                    child: TextField(
                                      controller: comp['controller'] as TextEditingController,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        suffixText: food != null && food.servingType == 'weight' ? ' g' : (food != null && food.servingType == 'volume' ? ' ml' : ' x'),
                                        filled: true,
                                        fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(color: Colors.green),
                error: (e, s) => Text('Error: $e'),
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
                    ElevatedButton(
                      onPressed: () async {
                        double totalCal = 0, totalP = 0, totalC = 0, totalF = 0, totalFiber = 0;
                        List<Map<String, dynamic>> jsonComponents = [];
                        bool isValid = false;

                        for (var c in components) {
                          final f = c['food'] as FoodItem?;
                          final qty = double.tryParse((c['controller'] as TextEditingController).text) ?? 0;
                          if (f != null && qty > 0) {
                            isValid = true;
                            final multiplier = (f.servingType == 'weight' || f.servingType == 'volume') ? (qty / 100.0) : qty;
                            totalCal += f.caloriesPerUnit * multiplier;
                            totalP += f.proteinPerUnit * multiplier;
                            totalC += f.carbsPerUnit * multiplier;
                            totalF += f.fatPerUnit * multiplier;
                            totalFiber += f.fiberPerUnit * multiplier;
                            jsonComponents.add({'id': f.id, 'qty': qty});
                          }
                        }

                        if (isValid) {
                          final db = ref.read(databaseProvider);
                          
                          // Update the HiddenMeal food item macros and category
                          await db.update(db.foodItems).replace(hiddenMeal.copyWith(
                            caloriesPerUnit: totalCal,
                            proteinPerUnit: totalP,
                            carbsPerUnit: totalC,
                            fatPerUnit: totalF,
                            fiberPerUnit: totalFiber,
                            category: drift.Value('HiddenMeal:${jsonEncode(jsonComponents)}'),
                          ));
                          
                          // Update the FoodLog macros
                          await db.update(db.foodLogs).replace(log.copyWith(
                            calories: totalCal,
                            protein: totalP,
                            carbs: totalC,
                            fat: totalF,
                            fiber: totalFiber,
                          ));

                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _showEditLogDialog(BuildContext context, WidgetRef ref, FoodLog log, FoodItem food) {
    if (food.category != null && food.category!.startsWith('HiddenMeal:')) {
      _showEditCustomLogDialog(context, ref, log, food);
      return;
    }
    
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
                  labelText: food.servingType == 'weight' ? 'Quantity (g)' : (food.servingType == 'volume' ? 'Quantity (ml)' : 'Quantity (x)'),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
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
                  final multiplier = (food.servingType == 'weight' || food.servingType == 'volume') ? (qty / 100.0) : qty; 
                  
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
    String? baseMealName;
    List<Map<String, dynamic>> components = [
      {'food': null, 'controller': TextEditingController()}
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Log Food Items', style: TextStyle(fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: foodItemsAsync.when(
                data: (foodItems) {
                  final selectableFoods = foodItems.where((f) => f.category == null || !f.category!.startsWith('HiddenMeal')).toList();
                  
                  if (selectableFoods.isEmpty) {
                    return const Text('Please add food items in the Inventory first.');
                  }
                  
                  return SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: components.length + 1,
                      itemBuilder: (context, index) {
                        if (index == components.length) {
                          return Container(
                            margin: const EdgeInsets.only(top: 4, bottom: 8),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  components.add({'food': null, 'controller': TextEditingController()});
                                });
                              },
                              icon: const Icon(Icons.add, color: Colors.green),
                              label: const Text('Add Another Item', style: TextStyle(color: Colors.green)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.green.withValues(alpha: 0.5), width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          );
                        }
                        
                        final comp = components[index];
                        final food = comp['food'] as FoodItem?;
                        final isDark = Theme.of(context).brightness == Brightness.dark;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade300),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: AppDropdown<FoodItem>(
                                      value: food,
                                      label: 'Select Food',
                                      prefixIcon: Icons.restaurant_outlined,
                                      items: selectableFoods.map((f) {
                                        final isMeal = f.category != null && f.category!.startsWith('Meal');
                                        return AppDropdownItem<FoodItem>(
                                          value: f,
                                          label: f.name,
                                          subtitle: '${f.caloriesPerUnit.toInt()} kcal',
                                          icon: isMeal ? Icons.restaurant_rounded : Icons.fastfood_rounded,
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null && val.category != null && val.category!.startsWith('Meal')) {
                                          setState(() {
                                            baseMealName ??= val.name;
                                            components.removeAt(index);
                                            final jsonStr = val.category!.replaceFirst('Meal:', '');
                                            try {
                                              final List<dynamic> decoded = jsonDecode(jsonStr);
                                              int insertIdx = index;
                                              for (var item in decoded) {
                                                final subFood = foodItems.firstWhere((f) => f.id == item['id']);
                                                components.insert(insertIdx, {
                                                  'food': subFood,
                                                  'controller': TextEditingController(text: item['qty'].toString())
                                                });
                                                insertIdx++;
                                              }
                                            } catch (_) {}
                                            if (components.isEmpty) {
                                              components.add({'food': null, 'controller': TextEditingController()});
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            components[index]['food'] = val;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  if (components.length > 1)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.redAccent),
                                        onPressed: () {
                                          setState(() {
                                            components.removeAt(index);
                                          });
                                        },
                                      ),
                                    )
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    'Quantity:',
                                    style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 130,
                                    child: TextField(
                                      controller: comp['controller'] as TextEditingController,
                                      textAlign: TextAlign.right,
                                      decoration: InputDecoration(
                                        suffixText: food != null && food.servingType == 'weight' ? ' g' : (food != null && food.servingType == 'volume' ? ' ml' : ' x'),
                                        filled: true,
                                        fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(color: Colors.green),
                error: (e, s) => Text('Error: $e'),
              ),
              actions: foodItemsAsync.maybeWhen(
                data: (foodItems) {
                  final selectableFoods = foodItems.where((f) => f.category == null || !f.category!.startsWith('HiddenMeal')).toList();
                  if (selectableFoods.isEmpty) {
                    return [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(mainNavigationProvider.notifier).setIndex(1);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                        child: const Text('Okay'),
                      ),
                    ];
                  }
                  return [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                    ElevatedButton(
                      onPressed: () async {
                        double totalCal = 0, totalP = 0, totalC = 0, totalF = 0, totalFiber = 0;
                        List<Map<String, dynamic>> jsonComponents = [];
                        bool isValid = false;

                        for (var c in components) {
                          final f = c['food'] as FoodItem?;
                          final qty = double.tryParse((c['controller'] as TextEditingController).text) ?? 0;
                          if (f != null && qty > 0) {
                            isValid = true;
                            final multiplier = (f.servingType == 'weight' || f.servingType == 'volume') ? (qty / 100.0) : qty;
                            totalCal += f.caloriesPerUnit * multiplier;
                            totalP += f.proteinPerUnit * multiplier;
                            totalC += f.carbsPerUnit * multiplier;
                            totalF += f.fatPerUnit * multiplier;
                            totalFiber += f.fiberPerUnit * multiplier;
                            jsonComponents.add({'id': f.id, 'qty': qty});
                          }
                        }

                        if (isValid) {
                          final db = ref.read(databaseProvider);
                          final now = DateTime.now();
                          final loggedDate = ref.read(selectedDateProvider);
                          final loggedTime = loggedDate.year == now.year && loggedDate.day == now.day ? now : loggedDate;

                          if (jsonComponents.length == 1) {
                            final fId = jsonComponents.first['id'] as int;
                            final qty = jsonComponents.first['qty'] as double;
                            final f = foodItems.firstWhere((x) => x.id == fId);
                            final multiplier = (f.servingType == 'weight' || f.servingType == 'volume') ? (qty / 100.0) : qty;
                            
                            await db.into(db.foodLogs).insert(FoodLogsCompanion.insert(
                              foodItemId: fId,
                              quantity: qty,
                              loggedDate: loggedDate,
                              loggedTime: loggedTime,
                              calories: f.caloriesPerUnit * multiplier,
                              protein: f.proteinPerUnit * multiplier,
                              carbs: f.carbsPerUnit * multiplier,
                              fat: f.fatPerUnit * multiplier,
                              fiber: f.fiberPerUnit * multiplier,
                              createdAt: now,
                            ));
                          } else {
                            final newMealId = await db.into(db.foodItems).insert(FoodItemsCompanion.insert(
                              name: baseMealName ?? 'Custom Log',
                              servingType: 'count',
                              measurementUnit: 'unit',
                              caloriesPerUnit: totalCal,
                              proteinPerUnit: totalP,
                              carbsPerUnit: totalC,
                              fatPerUnit: totalF,
                              fiberPerUnit: totalFiber,
                              category: drift.Value('HiddenMeal:${jsonEncode(jsonComponents)}'),
                              createdAt: now,
                            ));

                            await db.into(db.foodLogs).insert(FoodLogsCompanion.insert(
                              foodItemId: newMealId,
                              quantity: 1.0,
                              loggedDate: loggedDate,
                              loggedTime: loggedTime,
                              calories: totalCal,
                              protein: totalP,
                              carbs: totalC,
                              fat: totalF,
                              fiber: totalFiber,
                              createdAt: now,
                            ));
                          }
                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                      child: const Text('Save'),
                    ),
                  ];
                },
                orElse: () => [],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildWeekBar(BuildContext context, WidgetRef ref, MacroGoal goals) {
    final now = DateTime.now();
    final int daysSinceMonday = now.weekday - 1;
    final monday = DateTime(now.year, now.month, now.day).subtract(Duration(days: daysSinceMonday));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final selectedDate = ref.watch(selectedDateProvider);
    final weekLogsAsync = ref.watch(currentWeekLogsProvider);
    
    return weekLogsAsync.when(
      data: (weekLogs) {
        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final date = monday.add(Duration(days: index));
              final isSelected = date.year == selectedDate.year && date.month == selectedDate.month && date.day == selectedDate.day;
              
              // Calculate completion for this specific date
              double totalCal = 0;
              for (var log in weekLogs) {
                if (log.loggedDate.year == date.year && log.loggedDate.month == date.month && log.loggedDate.day == date.day) {
                  totalCal += log.calories;
                }
              }
              
              double completion = goals.caloriesTarget > 0 ? (totalCal / goals.caloriesTarget) : 0;
              
              final now = DateTime.now();
              final today = DateTime(now.year, now.month, now.day);
              final isFuture = date.isAfter(today);
              
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isFuture ? null : () {
                  ref.read(selectedDateProvider.notifier).updateDate(date);
                },
                child: Column(
                  children: [
                    Text(
                      DateFormat('E').format(date).substring(0, 3),
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.green : (isFuture ? (isDark ? Colors.white24 : Colors.grey.shade300) : Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? Colors.green.withValues(alpha: 0.1) : Colors.transparent,
                        border: date.year == today.year && date.month == today.month && date.day == today.day && !isSelected
                            ? Border.all(color: Colors.green.withValues(alpha: 0.5), width: 1.5)
                            : null,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (completion > 0)
                            SizedBox.expand(
                              child: CircularProgressIndicator(
                                value: completion,
                                backgroundColor: Colors.transparent,
                                color: Colors.green,
                                strokeWidth: 3,
                              ),
                            ),
                          Text(
                            date.day.toString(),
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green : (isFuture ? (isDark ? Colors.white24 : Colors.grey.shade400) : (isDark ? Colors.white : Colors.black87)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        );
      },
      loading: () => const SizedBox(height: 80, child: Center(child: CircularProgressIndicator())),
      error: (e, s) => const SizedBox(height: 80),
    );
  }

  Widget _buildMacroStat(BuildContext context, String label, double current, double goal, Color color) {
    final bool isCompleted = goal > 0 && current >= goal;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
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
                  backgroundColor: isDark ? Colors.white12 : Colors.grey[200],
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
