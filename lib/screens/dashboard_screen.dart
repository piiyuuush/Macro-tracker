
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/food_search_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import '../providers/data_providers.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../widgets/app_selector.dart';
import '../widgets/weight_logger_sheet.dart';
import '../widgets/food_log_card.dart';

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
                          _buildWeightTrackerCard(context, ref),
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
                            ...(() {
                              final sortedLogs = List<FoodLog>.from(logs)
                                ..sort((a, b) => b.loggedTime.compareTo(a.loggedTime));
                              return sortedLogs.map((log) {
                                final food = foodItems.cast<FoodItem?>().firstWhere((f) => f?.id == log.foodItemId, orElse: () => null);
                                if (food == null) return const SizedBox();
                                return FoodLogCard(
                                  key: ValueKey(log.id),
                                  log: log,
                                  food: food,
                                  foodItems: foodItems,
                                );
                              });
                            })(),
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

  void _showAddFoodLogDialog(BuildContext context, WidgetRef ref) {
    final foodItemsAsync = ref.read(foodItemsProvider);
    String? baseMealName;
    final mealNameController = TextEditingController();
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
                  
                  final isDark = Theme.of(context).brightness == Brightness.dark;
                  return SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: mealNameController,
                            decoration: InputDecoration(
                              labelText: 'Meal Name (Optional)',
                              hintText: 'e.g., Breakfast, College meal',
                              prefixIcon: const Icon(Icons.restaurant_menu_rounded, color: Colors.green),
                              filled: true,
                              fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                'Breakfast',
                                'College meal',
                                'Meal at office',
                                'Lunch',
                                'Dinner',
                                'Snack',
                                'Pre-Workout',
                                'Post-Workout',
                              ].map((suggested) => Padding(
                                padding: const EdgeInsets.only(right: 6.0),
                                child: ActionChip(
                                  label: Text(suggested, style: const TextStyle(fontSize: 12)),
                                  backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                                  side: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300),
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  onPressed: () {
                                    setState(() {
                                      mealNameController.text = suggested;
                                    });
                                  },
                                ),
                              )).toList(),
                            ),
                          ),
                          const SizedBox(height: 14),
                          ...components.asMap().entries.map((entry) {
                            final index = entry.key;
                            final comp = entry.value;
                            final food = comp['food'] as FoodItem?;
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
                                        child: AppSelector(
                                          valueText: food?.name,
                                          label: 'Select Food',
                                          prefixIcon: Icons.restaurant_outlined,
                                          onTap: () async {
                                            final val = await showFoodSearchSelector(context, ref, selectableFoods);
                                            if (val != null) {
                                              if (val.category != null && val.category!.startsWith('Meal')) {
                                                setState(() {
                                                  baseMealName ??= val.name;
                                                  if (mealNameController.text.isEmpty) {
                                                    mealNameController.text = val.name;
                                                  }
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
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: isDark ? Colors.white : Colors.black87),
                                          decoration: InputDecoration(
                                            suffixText: food != null && food.servingType == 'weight' ? ' g' : (food != null && food.servingType == 'volume' ? ' ml' : ' x'),
                                            filled: true,
                                            fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              borderSide: BorderSide(color: isDark ? Colors.green.shade400 : Colors.green.shade700, width: 1.6),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          Container(
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
                          ),
                        ],
                      ),
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

                          final customName = mealNameController.text.trim();
                          final hasCustomName = customName.isNotEmpty;
                          final effectiveMealName = hasCustomName ? customName : (baseMealName ?? (jsonComponents.length > 1 ? 'Custom Meal' : null));

                          if (effectiveMealName == null && jsonComponents.length == 1) {
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
                              name: effectiveMealName ?? 'Custom Meal',
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

  Widget _buildWeightTrackerCard(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final weightLogsAsync = ref.watch(weightLogsProvider);

    return weightLogsAsync.when(
      data: (logs) {
        final now = DateTime.now();
        final latestLog = logs.firstOrNull;
        final isLoggedToday = latestLog != null &&
            latestLog.loggedDate.year == now.year &&
            latestLog.loggedDate.day == now.day;

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        latestLog != null ? 'Current Weight' : 'Weight Tracker',
                        style: TextStyle(
                            fontSize: 14, color: isDark ? Colors.white70 : Colors.grey.shade700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        latestLog != null ? '${latestLog.weight.toStringAsFixed(1)} kg' : 'Not Logged',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => showWeightLoggerSheet(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isLoggedToday ? (isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade200) : Colors.green,
                    foregroundColor: isLoggedToday ? (isDark ? Colors.white : Colors.black87) : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: Text(isLoggedToday ? 'Update' : 'Log Today'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
