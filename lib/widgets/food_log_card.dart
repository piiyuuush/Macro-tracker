import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import '../database/database.dart';
import '../providers/data_providers.dart';
import '../providers/database_provider.dart';
import '../widgets/app_selector.dart';
import '../widgets/food_search_selector.dart';

class FoodLogCard extends ConsumerWidget {
  final FoodLog log;
  final FoodItem food;
  final List<FoodItem> foodItems;

  const FoodLogCard({
    super.key,
    required this.log,
    required this.food,
    required this.foodItems,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHiddenMeal = food.category != null && food.category!.startsWith('HiddenMeal:');
    final isNormalMeal = food.category != null && food.category!.startsWith('Meal:');
    final isAnyMeal = isHiddenMeal || isNormalMeal;

    List<Widget> subItems = [];
    int subItemCount = 0;
    if (isAnyMeal) {
      try {
        final prefix = isHiddenMeal ? 'HiddenMeal:' : 'Meal:';
        final jsonStr = food.category!.replaceFirst(prefix, '');
        final List<dynamic> decoded = jsonDecode(jsonStr);
        subItemCount = decoded.length;
        for (var item in decoded) {
          final subFood = foodItems.cast<FoodItem?>().firstWhere((f) => f?.id == item['id'], orElse: () => null);
          if (subFood != null) {
            subItems.add(Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.subdirectory_arrow_right_rounded, size: 16, color: Colors.green.shade400),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      subFood.name,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white70 : Colors.grey.shade800,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '${item['qty']} ${subFood.servingType == 'weight' ? 'g' : (subFood.servingType == 'volume' ? 'ml' : 'x')}',
                    style: TextStyle(color: isDark ? Colors.white38 : Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ));
          }
        }
      } catch (_) {}
    }

    final String portionText;
    if (isAnyMeal) {
      portionText = subItemCount > 0 ? '$subItemCount items' : 'Meal';
    } else if (food.servingType == 'weight') {
      portionText = '${log.quantity.toInt()} g';
    } else if (food.servingType == 'volume') {
      portionText = '${log.quantity.toInt()} ml';
    } else {
      portionText = '${log.quantity.toInt()} ${log.quantity == 1 ? 'unit' : 'units'}';
    }

    final formattedTime = DateFormat('h:mm a').format(log.loggedTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? const Color(0xFF181818) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          childrenPadding: EdgeInsets.zero,
          trailing: subItems.isNotEmpty
              ? Icon(Icons.expand_more_rounded, color: isDark ? Colors.white38 : Colors.grey.shade400)
              : const SizedBox.shrink(),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? (isAnyMeal ? Colors.orange.withValues(alpha: 0.15) : Colors.green.withValues(alpha: 0.15))
                      : (isAnyMeal ? Colors.orange.shade50 : Colors.green.shade50),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isAnyMeal ? Icons.restaurant_rounded : Icons.fastfood_rounded,
                  color: isAnyMeal
                      ? (isDark ? Colors.orange.shade400 : Colors.orange.shade700)
                      : (isDark ? Colors.green.shade400 : Colors.green.shade700),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        food.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        portionText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white60 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule_rounded, size: 12, color: isDark ? Colors.white38 : Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white60 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Text(
                  '${log.calories.round()} kcal',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.orange.shade300 : Colors.orange.shade800,
                  ),
                ),
                const Spacer(),
                _buildMacroPill('P', '${log.protein.round()}g', Colors.blue, isDark),
                const SizedBox(width: 5),
                _buildMacroPill('C', '${log.carbs.round()}g', Colors.orange, isDark),
                const SizedBox(width: 5),
                _buildMacroPill('F', '${log.fat.round()}g', Colors.redAccent, isDark),
              ],
            ),
          ),
          children: [
            if (subItems.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF101010) : const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.white10 : Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.format_list_bulleted_rounded, size: 14, color: isDark ? Colors.white54 : Colors.grey.shade600),
                          const SizedBox(width: 6),
                          Text(
                            'MEAL INGREDIENTS',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: isDark ? Colors.white54 : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Divider(height: 8),
                      ...subItems,
                    ],
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline_rounded, size: 17, color: Colors.redAccent),
                    label: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontSize: 13, fontWeight: FontWeight.w600)),
                    onPressed: () => _confirmDeleteLog(context, ref, log),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 17, color: Colors.blue),
                    label: const Text('Edit', style: TextStyle(color: Colors.blue, fontSize: 13, fontWeight: FontWeight.w600)),
                    onPressed: () => _showEditLogDialog(context, ref, log, food),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildMacroPill(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
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

  void _showEditCustomLogDialog(BuildContext context, WidgetRef ref, FoodLog log, FoodItem hiddenMeal) {
    final foodItemsAsync = ref.read(foodItemsProvider);
    final mealNameController = TextEditingController(text: hiddenMeal.name);
    
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
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return AlertDialog(
              title: const Text('Edit Meal', style: TextStyle(fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              content: foodItemsAsync.when(
                data: (foodItems) {
                  final selectableFoods = foodItems.where((f) => f.category == null || !f.category!.startsWith('HiddenMeal')).toList();
                  
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
                              labelText: 'Meal Name',
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
                          final updatedName = mealNameController.text.trim();
                          
                          // Update the HiddenMeal food item macros and category
                          await db.update(db.foodItems).replace(hiddenMeal.copyWith(
                            name: updatedName.isNotEmpty ? updatedName : hiddenMeal.name,
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
}
