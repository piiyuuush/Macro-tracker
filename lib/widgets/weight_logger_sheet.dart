import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../database/database.dart';
import '../providers/database_provider.dart';

Future<void> showWeightLoggerSheet(BuildContext context, WidgetRef ref) async {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _WeightLoggerSheet(),
  );
}

class _WeightLoggerSheet extends ConsumerStatefulWidget {
  const _WeightLoggerSheet();

  @override
  ConsumerState<_WeightLoggerSheet> createState() => _WeightLoggerSheetState();
}

class _WeightLoggerSheetState extends ConsumerState<_WeightLoggerSheet> {
  final _controller = TextEditingController();

  void _save() async {
    final weight = double.tryParse(_controller.text);
    if (weight != null && weight > 0) {
      final db = ref.read(databaseProvider);
      final now = DateTime.now();
      await db.into(db.weightLogs).insert(
        WeightLogsCompanion.insert(
          weight: weight,
          loggedDate: DateTime(now.year, now.month, now.day),
          createdAt: now,
        ),
      );
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Log Today\'s Weight', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                suffixText: 'kg',
                filled: true,
                fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 24),
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Save Weight', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
