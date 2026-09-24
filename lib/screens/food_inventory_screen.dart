import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/llm_parser.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_providers.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';

class FoodInventoryScreen extends ConsumerWidget {
  const FoodInventoryScreen({Key? key}) : super(key: key);

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
                subtitle: Text('Macros: ${food.caloriesPerUnit} cal · ${food.proteinPerUnit}g P · ${food.carbsPerUnit}g C · ${food.fatPerUnit}g F'),
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
    final pasteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Food Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('AI Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              final prompt = 'I need nutritional information for ${nameController.text.isEmpty ? "this food" : nameController.text} measured in 100g.\n'
                                            'Return ONLY the response in this exact format:\n'
                                            'Calories: [NUMBER]\n'
                                            'Protein: [NUMBER]\n'
                                            'Carbs: [NUMBER]\n'
                                            'Fat: [NUMBER]\n'
                                            'Fiber: [NUMBER]';
                              Clipboard.setData(ClipboardData(text: prompt));
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                            },
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy Prompt'),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: pasteController,
                                  decoration: const InputDecoration(hintText: 'Paste AI output...', border: OutlineInputBorder()),
                                  maxLines: 2,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.auto_fix_high, color: Colors.green),
                                onPressed: () {
                                  final macros = LlmParser.parseMacros(pasteController.text);
                                  setState(() {
                                    calController.text = macros['calories']!.toInt().toString();
                                    proteinController.text = macros['protein']!.toString();
                                    carbsController.text = macros['carbs']!.toString();
                                    fatController.text = macros['fat']!.toString();
                                  });
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(controller: calController, decoration: const InputDecoration(labelText: 'Calories (kcal)'), keyboardType: TextInputType.number),
                    TextField(controller: proteinController, decoration: const InputDecoration(labelText: 'Protein (g)'), keyboardType: TextInputType.number),
                    TextField(controller: carbsController, decoration: const InputDecoration(labelText: 'Carbs (g)'), keyboardType: TextInputType.number),
                    TextField(controller: fatController, decoration: const InputDecoration(labelText: 'Fat (g)'), keyboardType: TextInputType.number),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    final db = ref.read(databaseProvider);
                    db.into(db.foodItems).insert(FoodItemsCompanion.insert(
                      name: nameController.text,
                      measurementType: 'measurable',
                      measurementUnit: 'g',
                      caloriesPerUnit: double.tryParse(calController.text) ?? 0.0,
                      proteinPerUnit: double.tryParse(proteinController.text) ?? 0.0,
                      carbsPerUnit: double.tryParse(carbsController.text) ?? 0.0,
                      fatPerUnit: double.tryParse(fatController.text) ?? 0.0,
                      fiberPerUnit: 0.0,
                      createdAt: DateTime.now(),
                    ));
                    Navigator.pop(context);
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
}
