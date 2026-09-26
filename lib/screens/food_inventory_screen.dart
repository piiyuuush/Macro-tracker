import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/llm_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';

class FoodInventoryScreen extends ConsumerWidget {
  const FoodInventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodItemsAsyncValue = ref.watch(foodItemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Food Inventory')),
      body: foodItemsAsyncValue.when(
        data: (foodItems) {
          if (foodItems.isEmpty) {
            return const Center(child: Text('No food items found.'));
          }
          return ListView.builder(
            itemCount: foodItems.length,
            itemBuilder: (context, index) {
              final food = foodItems[index];
              return ListTile(
                title: Text(food.name),
                subtitle: Text('Macros: ${food.caloriesPerUnit} cal · ${food.proteinPerUnit}g P · ${food.carbsPerUnit}g C · ${food.fatPerUnit}g F · ${food.fiberPerUnit}g Fiber'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(databaseProvider).delete(ref.read(databaseProvider).foodItems).delete(food);
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFoodDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFoodDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final calController = TextEditingController();
    final proteinController = TextEditingController();
    final carbsController = TextEditingController();
    final fatController = TextEditingController();
    final fiberController = TextEditingController();
    final pasteController = TextEditingController();
    
    // State for Measurement Type
    String measurementType = 'Measurable (e.g. 100g)';

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
              title: const Text('Add Food Item', style: TextStyle(fontWeight: FontWeight.bold)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              content: SizedBox(
                width: double.maxFinite, // Safely stretch out wide without overflowing
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
                      
                      // Compact Macro Inputs
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
                  onPressed: () {
                    final db = ref.read(databaseProvider);
                    final isMeasurable = measurementType.contains('Measurable');
                    
                    db.into(db.foodItems).insert(FoodItemsCompanion.insert(
                      name: nameController.text,
                      measurementType: isMeasurable ? 'measurable' : 'countable',
                      measurementUnit: isMeasurable ? 'g' : 'unit',
                      caloriesPerUnit: double.tryParse(calController.text) ?? 0.0,
                      proteinPerUnit: double.tryParse(proteinController.text) ?? 0.0,
                      carbsPerUnit: double.tryParse(carbsController.text) ?? 0.0,
                      fatPerUnit: double.tryParse(fatController.text) ?? 0.0,
                      fiberPerUnit: double.tryParse(fiberController.text) ?? 0.0,
                      createdAt: DateTime.now(),
                    ));
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  child: const Text('Save Food'),
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
