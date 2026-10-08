import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';
import '../providers/data_providers.dart';

Future<FoodItem?> showFoodSearchSelector(BuildContext context, WidgetRef ref, List<FoodItem> selectableFoods) async {
  return showModalBottomSheet<FoodItem>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _FoodSearchSelectorSheet(selectableFoods: selectableFoods);
    },
  );
}

class _FoodSearchSelectorSheet extends ConsumerStatefulWidget {
  final List<FoodItem> selectableFoods;
  const _FoodSearchSelectorSheet({required this.selectableFoods});

  @override
  ConsumerState<_FoodSearchSelectorSheet> createState() => _FoodSearchSelectorSheetState();
}

class _FoodSearchSelectorSheetState extends ConsumerState<_FoodSearchSelectorSheet> {
  String searchQuery = '';
  late List<FoodItem> recentFoods;

  @override
  void initState() {
    super.initState();
    _computeRecentFoods();
  }

  void _computeRecentFoods() {
    final allLogs = ref.read(allFoodLogsProvider).value ?? [];
    // Sort logs by time descending
    final sortedLogs = List<FoodLog>.from(allLogs)
      ..sort((a, b) => b.loggedTime.compareTo(a.loggedTime));
    
    final recentIds = <int>{};
    for (var log in sortedLogs) {
      recentIds.add(log.foodItemId);
      if (recentIds.length >= 4) break;
    }
    
    recentFoods = widget.selectableFoods.where((f) => recentIds.contains(f.id)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    final filteredFoods = widget.selectableFoods.where((f) {
      if (searchQuery.isEmpty) return true;
      return f.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search food...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                if (searchQuery.isEmpty && recentFoods.isNotEmpty) ...[
                  const Text('Recent Foods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                  ...recentFoods.map((f) => _buildFoodTile(f, isDark)),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Divider(),
                  ),
                  const Text('All Foods', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 8),
                ],
                ...filteredFoods.map((f) => _buildFoodTile(f, isDark)),
                if (filteredFoods.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('No foods found.', style: TextStyle(color: Colors.grey))),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodTile(FoodItem f, bool isDark) {
    final isMeal = f.category != null && f.category!.startsWith('Meal');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDark ? Colors.green.withValues(alpha: 0.15) : Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(isMeal ? Icons.restaurant_rounded : Icons.fastfood_rounded, color: Colors.green),
      ),
      title: Text(f.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('${f.caloriesPerUnit.toInt()} kcal', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      onTap: () => Navigator.of(context).pop(f),
    );
  }
}
