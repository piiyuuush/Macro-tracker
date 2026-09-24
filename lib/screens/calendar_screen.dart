import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: FutureBuilder<List<FoodLog>>(
        future: ref.read(databaseProvider).select(ref.read(databaseProvider).foodLogs).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final logs = snapshot.data ?? [];
          if (logs.isEmpty) {
            return const Center(child: Text('No historical logs found.'));
          }

          logs.sort((a, b) => b.loggedTime.compareTo(a.loggedTime)); // Descending order

          return ListView.builder(
            itemCount: logs.length,
            itemBuilder: (context, index) {
              final log = logs[index];
              return ListTile(
                title: Text('Food ID: ${log.foodItemId}'), // Join not implemented in basic view
                subtitle: Text('${log.loggedDate.toIso8601String().split("T")[0]} · ${log.calories} kcal'),
                trailing: Text('${log.protein}g P | ${log.carbs}g C | ${log.fat}g F'),
              );
            },
          );
        },
      ),
    );
  }
}
