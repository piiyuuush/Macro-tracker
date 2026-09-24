import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../providers/data_providers.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider);
    final goalsAsync = ref.watch(macroGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile & Settings')),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('No User Profile Found'));
          return goalsAsync.when(
            data: (goals) {
              if (goals == null) return const Center(child: Text('No Goals Found'));

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text('User Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: const Text('Name'),
                    subtitle: Text(user.name),
                  ),
                  ListTile(
                    title: const Text('Details'),
                    subtitle: Text('${user.age} yrs | ${user.gender} | ${user.currentWeight}kg | ${user.height}cm'),
                  ),
                  const Divider(),
                  const Text('Macro Goals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: const Text('Daily Targets'),
                    subtitle: Text('${goals.caloriesTarget} kcal | ${goals.proteinTarget}g P | ${goals.carbsTarget}g C | ${goals.fatTarget}g F | ${goals.fiberTarget}g Fiber'),
                  ),
                  const Divider(),
                  const Text('Data Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ListTile(
                    title: const Text('Export Data to CSV'),
                    leading: const Icon(Icons.download),
                    onTap: () async {
                      // Implementation of Data export (CSV) - v0.5
                      try {
                        final db = ref.read(databaseProvider);
                        final logs = await db.select(db.foodLogs).get();
                        
                        final directory = await getApplicationDocumentsDirectory();
                        final file = File('${directory.path}/macro_tracker_export.csv');
                        
                        String csvData = 'Date,Time,Quantity,Calories,Protein,Carbs,Fat,Fiber\n';
                        for (var log in logs) {
                          csvData += '${log.loggedDate.toIso8601String().split('T')[0]},';
                          csvData += '${log.loggedTime.toIso8601String().split('T')[1]},';
                          csvData += '${log.quantity},${log.calories},${log.protein},${log.carbs},${log.fat},${log.fiber}\n';
                        }
                        
                        await file.writeAsString(csvData);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Exported to ${file.path}')),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Export failed: $e')),
                          );
                        }
                      }
                    },
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
