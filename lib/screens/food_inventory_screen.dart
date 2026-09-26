import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../utils/llm_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';
import 'package:drift/drift.dart' as drift;

class FoodInventoryScreen extends ConsumerStatefulWidget {
  const FoodInventoryScreen({super.key});

  @override
  ConsumerState<FoodInventoryScreen> createState() => _FoodInventoryScreenState();
}

class _FoodInventoryScreenState extends ConsumerState<FoodInventoryScreen> {
  bool isSelectionMode = false;
  Set<int> selectedFoodIds = {};

  @override
  Widget build(BuildContext context) {
    final foodItemsAsyncValue = ref.watch(foodItemsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(isSelectionMode ? '${selectedFoodIds.length} Selected' : 'Food Inventory', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: isSelectionMode ? [
          IconButton(
            icon: const Icon(Icons.playlist_add_check),
            tooltip: 'Group Selected',
            onPressed: () {
              if (selectedFoodIds.isEmpty) return;
              final allFoods = ref.read(foodItemsProvider).value ?? [];
              final selectedFoods = allFoods.where((f) => selectedFoodIds.contains(f.id)).toList();
              _showGroupModal(selectedFoods);
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                isSelectionMode = false;
                selectedFoodIds.clear();
              });
            },
          )
        ] : null,
      ),
      body: foodItemsAsyncValue.when(
        data: (foodItems) {
          if (foodItems.isEmpty) {
            return const Center(child: Text('No food items found.', style: TextStyle(color: Colors.grey, fontSize: 16)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];
              final isSelected = selectedFoodIds.contains(food.id);
              
              return GestureDetector(
                onLongPress: () {
                  if (!isSelectionMode) {
                    setState(() {
                      isSelectionMode = true;
                      selectedFoodIds.add(food.id);
                    });
                  }
                },
                onTap: () {
                  if (isSelectionMode) {
                    setState(() {
                      if (isSelected) {
                        selectedFoodIds.remove(food.id);
                        if (selectedFoodIds.isEmpty) isSelectionMode = false;
                      } else {
                        selectedFoodIds.add(food.id);
                      }
                    });
                  }
                },
                child: Card(
                  elevation: 0,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), 
                    side: BorderSide(color: isSelected ? Colors.green : Colors.grey.shade300, width: isSelected ? 2 : 1)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        if (isSelectionMode)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Checkbox(
                              value: isSelected,
                              activeColor: Colors.green,
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    selectedFoodIds.add(food.id);
                                  } else {
                                    selectedFoodIds.remove(food.id);
                                    if (selectedFoodIds.isEmpty) isSelectionMode = false;
                                  }
                                });
                              },
                            ),
                          ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                          child: Icon((food.category?.startsWith('Meal') ?? false) ? Icons.restaurant : Icons.fastfood, color: Colors.green.shade700, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(food.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                '${food.caloriesPerUnit.toInt()} kcal · ${food.proteinPerUnit.toInt()}g Protein',
                                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                food.measurementType == 'measurable' ? 'per 100g' : 'per unit',
                                style: TextStyle(color: Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        if (!isSelectionMode) ...[
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              if ((food.category?.startsWith('Meal') ?? false)) {
                                
                                // Fetch components
                                final jsonStr = food.category!.replaceFirst('Meal:', '');
                                final List<dynamic> decoded = jsonStr.isNotEmpty ? jsonDecode(jsonStr) : [];
                                final allFoods = ref.read(foodItemsProvider).value ?? [];
                                final componentIds = decoded.map((e) => e['id'] as int).toSet();
                                final selectedFoods = allFoods.where((f) => componentIds.contains(f.id)).toList();
                                _showGroupModal(selectedFoods, mealToEdit: food);

                              } else {
                                _showFoodDialog(context, ref, foodToEdit: food);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _confirmDelete(context, ref, food),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: isSelectionMode ? null : FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => _showFoodDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showGroupModal(List<FoodItem> selectedFoods, {FoodItem? mealToEdit}) {
    final groupNameController = TextEditingController(text: mealToEdit?.name ?? '');
    final Map<int, TextEditingController> quantityControllers = {};
    
    if (mealToEdit != null && mealToEdit.category != null) {
      final jsonStr = mealToEdit.category!.replaceFirst('Meal:', '');
      if (jsonStr.isNotEmpty) {
        try {
          final List<dynamic> decoded = jsonDecode(jsonStr);
          for (var item in decoded) {
            quantityControllers[item['id'] as int] = TextEditingController(text: item['qty'].toString());
          }
        } catch (e) {
          // Fallback if parsing fails
        }
      }
    }
    final calController = TextEditingController(text: mealToEdit?.caloriesPerUnit.toString() ?? '');
    final proteinController = TextEditingController(text: mealToEdit?.proteinPerUnit.toString() ?? '');
    final carbsController = TextEditingController(text: mealToEdit?.carbsPerUnit.toString() ?? '');
    final fatController = TextEditingController(text: mealToEdit?.fatPerUnit.toString() ?? '');
    final fiberController = TextEditingController(text: mealToEdit?.fiberPerUnit.toString() ?? '');

    void recalculateTotals() {
      double totalCal = 0, totalP = 0, totalC = 0, totalF = 0, totalFiber = 0;
      for (var f in selectedFoods) {
        final qty = double.tryParse(quantityControllers[f.id]?.text ?? '0') ?? 0;
        final multiplier = f.measurementType == 'measurable' ? (qty / 100.0) : qty;
        
        totalCal += f.caloriesPerUnit * multiplier;
        totalP += f.proteinPerUnit * multiplier;
        totalC += f.carbsPerUnit * multiplier;
        totalF += f.fatPerUnit * multiplier;
        totalFiber += f.fiberPerUnit * multiplier;
      }
      calController.text = totalCal.toInt().toString();
      proteinController.text = totalP.toStringAsFixed(1);
      carbsController.text = totalC.toStringAsFixed(1);
      fatController.text = totalF.toStringAsFixed(1);
      fiberController.text = totalFiber.toStringAsFixed(1);
    }
    
    // Initialize quantities and totals
    for (var f in selectedFoods) {
      if (!quantityControllers.containsKey(f.id)) {
        quantityControllers[f.id] = TextEditingController(text: f.measurementType == 'measurable' ? '100' : '1');
      }
    }
    if (mealToEdit == null) recalculateTotals();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            
            return AlertDialog(
              title: Text(mealToEdit == null ? 'Create Meal Group' : 'Edit Meal Group', style: TextStyle(fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: groupNameController,
                        decoration: InputDecoration(
                          labelText: 'Meal Name',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      const Align(alignment: Alignment.centerLeft, child: Text('Adjust Quantities:', style: TextStyle(fontWeight: FontWeight.bold))),
                      const SizedBox(height: 8),
                      ...selectedFoods.map((f) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Text(f.name, style: const TextStyle(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: quantityControllers[f.id],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    suffixText: f.measurementType == 'measurable' ? 'g' : 'x',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                  ),
                                  onChanged: (_) {
                                    setModalState(() {
                                      recalculateTotals();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 16),
                      
                      // Editable Macro Layout
                      _compactInput(calController, 'Total Cals (kcal)'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _compactInput(proteinController, 'Protein (g)')),
                          const SizedBox(width: 8),
                          Expanded(child: _compactInput(carbsController, 'Carbs (g)')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _compactInput(fatController, 'Fat (g)')),
                          const SizedBox(width: 8),
                          Expanded(child: _compactInput(fiberController, 'Fiber (g)')),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  onPressed: () async {
                    if (groupNameController.text.trim().isEmpty) return;
                    
                    final db = ref.read(databaseProvider);
                    final componentsJson = jsonEncode(selectedFoods.map((f) {
                      return {'id': f.id, 'qty': double.tryParse(quantityControllers[f.id]?.text ?? '0') ?? 0};
                    }).toList());
                    final catStr = 'Meal:$componentsJson';
                    
                    final companion = FoodItemsCompanion.insert(
                      name: groupNameController.text.trim(),
                      measurementType: 'countable',
                      measurementUnit: 'serving',
                      caloriesPerUnit: double.tryParse(calController.text) ?? 0.0,
                      proteinPerUnit: double.tryParse(proteinController.text) ?? 0.0,
                      carbsPerUnit: double.tryParse(carbsController.text) ?? 0.0,
                      fatPerUnit: double.tryParse(fatController.text) ?? 0.0,
                      fiberPerUnit: double.tryParse(fiberController.text) ?? 0.0,
                      createdAt: mealToEdit?.createdAt ?? DateTime.now(),
                      category: drift.Value(catStr),
                    );
                    
                    if (mealToEdit == null) {
                      await db.into(db.foodItems).insert(companion);
                    } else {
                      await db.update(db.foodItems).replace(mealToEdit.copyWith(
                        name: companion.name.value,
                        caloriesPerUnit: companion.caloriesPerUnit.value,
                        proteinPerUnit: companion.proteinPerUnit.value,
                        carbsPerUnit: companion.carbsPerUnit.value,
                        fatPerUnit: companion.fatPerUnit.value,
                        fiberPerUnit: companion.fiberPerUnit.value,
                        category: companion.category,
                      ));
                    }
                    
                    if (context.mounted) {
                      Navigator.pop(context);
                      setState(() {
                        isSelectionMode = false;
                        selectedFoodIds.clear();
                      });
                    }
                  },
                  child: Text(mealToEdit == null ? 'Save Group' : 'Update Meal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, FoodItem food) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Food?'),
        content: Text('Are you sure you want to delete ${food.name}? This cannot be undone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
            onPressed: () {
              ref.read(databaseProvider).delete(ref.read(databaseProvider).foodItems).delete(food);
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFoodDialog(BuildContext context, WidgetRef ref, {FoodItem? foodToEdit}) {
    final nameController = TextEditingController(text: foodToEdit?.name ?? '');
    final calController = TextEditingController(text: foodToEdit != null ? foodToEdit.caloriesPerUnit.toString() : '');
    final proteinController = TextEditingController(text: foodToEdit != null ? foodToEdit.proteinPerUnit.toString() : '');
    final carbsController = TextEditingController(text: foodToEdit != null ? foodToEdit.carbsPerUnit.toString() : '');
    final fatController = TextEditingController(text: foodToEdit != null ? foodToEdit.fatPerUnit.toString() : '');
    final fiberController = TextEditingController(text: foodToEdit != null ? foodToEdit.fiberPerUnit.toString() : '');
    final pasteController = TextEditingController();
    
    String measurementType = foodToEdit != null && foodToEdit.measurementType == 'countable' 
        ? 'Countable (e.g. 1 egg)' 
        : 'Measurable (e.g. 100g)';

    pasteController.addListener(() {
      if (pasteController.text.isNotEmpty) {
        final macros = LlmParser.parseMacros(pasteController.text);
        if (macros['calories']! > 0 || macros['protein']! > 0) {
          calController.text = macros['calories']!.toInt().toString();
          proteinController.text = macros['protein']!.toString();
          carbsController.text = macros['carbs']!.toString();
          fatController.text = macros['fat']!.toString();
          fiberController.text = macros['fiber']!.toString();
        }
      }
    });

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(foodToEdit == null ? 'Add Food Item' : 'Edit Food Item', style: const TextStyle(fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              content: SizedBox(
                width: double.maxFinite, 
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: nameController, 
                              decoration: InputDecoration(
                                labelText: 'Food Name',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              )
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              value: measurementType,
                              decoration: InputDecoration(
                                labelText: 'Food Type',
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              items: ['Measurable (e.g. 100g)', 'Countable (e.g. 1 egg)'].map((e) => DropdownMenuItem(value: e, child: Text(e.split(' ')[0], style: const TextStyle(fontSize: 14)))).toList(),
                              onChanged: (v) {
                                if (v != null) setState(() => measurementType = v);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.shade100)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.auto_awesome, color: Colors.green, size: 18),
                                SizedBox(width: 6),
                                Text('AI Assistant', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(8)
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      final foodName = nameController.text.isEmpty ? "this food" : nameController.text;
                                      String instruction = measurementType.contains('Measurable') 
                                          ? 'I need nutritional information for exactly 100g of $foodName.'
                                          : 'I need nutritional information for exactly 1 average size unit/piece of $foodName.';
                                      
                                      final prompt = '$instruction\n'
                                                    'Return ONLY the response in this exact format:\n'
                                                    'Calories: [NUMBER]\n'
                                                    'Protein: [NUMBER]\n'
                                                    'Carbs: [NUMBER]\n'
                                                    'Fat: [NUMBER]\n'
                                                    'Fiber: [NUMBER]';
                                      Clipboard.setData(ClipboardData(text: prompt));
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied! Paste into AI.')));
                                    },
                                    icon: const Icon(Icons.copy, color: Colors.white, size: 20),
                                    tooltip: 'Copy Prompt',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: pasteController,
                                    decoration: InputDecoration(
                                      hintText: 'Paste AI output...', 
                                      hintStyle: const TextStyle(fontSize: 13),
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      suffixIcon: pasteController.text.isNotEmpty ? IconButton(
                                        icon: const Icon(Icons.close, size: 16),
                                        onPressed: () => setState(() => pasteController.clear()),
                                      ) : null,
                                    ),
                                    maxLines: 1,
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      _compactInput(calController, 'Cals (kcal)'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _compactInput(proteinController, 'Protein (g)')),
                          const SizedBox(width: 8),
                          Expanded(child: _compactInput(carbsController, 'Carbs (g)')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _compactInput(fatController, 'Fat (g)')),
                          const SizedBox(width: 8),
                          Expanded(child: _compactInput(fiberController, 'Fiber (g)')),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                ElevatedButton(
                  onPressed: () async {
                    final db = ref.read(databaseProvider);
                    final isMeasurable = measurementType.contains('Measurable');
                    
                    final companion = FoodItemsCompanion.insert(
                      name: nameController.text,
                      measurementType: isMeasurable ? 'measurable' : 'countable',
                      measurementUnit: isMeasurable ? 'g' : 'unit',
                      caloriesPerUnit: double.tryParse(calController.text) ?? 0.0,
                      proteinPerUnit: double.tryParse(proteinController.text) ?? 0.0,
                      carbsPerUnit: double.tryParse(carbsController.text) ?? 0.0,
                      fatPerUnit: double.tryParse(fatController.text) ?? 0.0,
                      fiberPerUnit: double.tryParse(fiberController.text) ?? 0.0,
                      createdAt: foodToEdit?.createdAt ?? DateTime.now(),
                    );
                    
                    if (foodToEdit == null) {
                      await db.into(db.foodItems).insert(companion);
                    } else {
                      await db.update(db.foodItems).replace(foodToEdit.copyWith(
                        name: companion.name.value,
                        measurementType: companion.measurementType.value,
                        measurementUnit: companion.measurementUnit.value,
                        caloriesPerUnit: companion.caloriesPerUnit.value,
                        proteinPerUnit: companion.proteinPerUnit.value,
                        carbsPerUnit: companion.carbsPerUnit.value,
                        fatPerUnit: companion.fatPerUnit.value,
                        fiberPerUnit: companion.fiberPerUnit.value,
                      ));
                    }
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: Text(foodToEdit == null ? 'Save Food' : 'Update Food'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _compactInput(TextEditingController controller, String label) {
    return TextField(
      controller: controller, 
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ), 
      keyboardType: TextInputType.number,
    );
  }
}
