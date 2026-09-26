
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/data_providers.dart';
import '../database/database.dart';
import '../providers/database_provider.dart';
import 'package:drift/drift.dart' as drift;

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final allLogsAsync = ref.watch(allFoodLogsProvider);
    final macroGoalsAsync = ref.watch(macroGoalsProvider);
    final foodItemsAsync = ref.watch(foodItemsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: macroGoalsAsync.when(
        data: (goals) {
          if (goals == null) {
            return const Center(child: Text('No goals set. Please complete onboarding.'));
          }
          final goalCal = goals.caloriesTarget.toDouble();

          return allLogsAsync.when(
            data: (allLogs) {
              return Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: selectedDate,
                      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        ref.read(selectedDateProvider.notifier).updateDate(selectedDay);
                      },
                      calendarFormat: CalendarFormat.month,
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      calendarStyle: CalendarStyle(
                        selectedDecoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        todayTextStyle: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          return _buildCalendarCell(day, selectedDate, allLogs, goalCal, isToday: isSameDay(day, DateTime.now()));
                        },
                        todayBuilder: (context, day, focusedDay) {
                          return _buildCalendarCell(day, selectedDate, allLogs, goalCal, isToday: true);
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return _buildCalendarCell(day, selectedDate, allLogs, goalCal, isSelected: true, isToday: isSameDay(day, DateTime.now()));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: foodItemsAsync.when(
                      data: (foodItems) {
                        // Filter logs for the selected date
                        final dailyLogs = allLogs.where((log) => isSameDay(log.loggedDate, selectedDate)).toList();
                        
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${DateFormat('EEEE, MMM d').format(selectedDate)}\'s Logs',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              if (dailyLogs.isEmpty)
                                const Expanded(
                                  child: Center(child: Text('No food logged for this day.', style: TextStyle(color: Colors.grey))),
                                )
                              else
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: dailyLogs.length,
                                    itemBuilder: (context, index) {
                                      final log = dailyLogs[index];
                                      final food = foodItems.cast<FoodItem?>().firstWhere((f) => f?.id == log.foodItemId, orElse: () => null);
                                      if (food == null) return const SizedBox();

                                      return Card(
                                        elevation: 0,
                                        margin: const EdgeInsets.only(bottom: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade300)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                                                child: Icon(food.category != null && food.category!.startsWith('Meal') ? Icons.restaurant : Icons.fastfood, color: Colors.green.shade700, size: 24),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(food.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      '${log.calories.toInt()} kcal · ${log.protein.toInt()}g Protein',
                                                      style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      '${log.quantity.toInt()} ${food.measurementType == 'measurable' ? 'g' : 'unit(s)'} logged at ${log.loggedTime.hour}:${log.loggedTime.minute.toString().padLeft(2, '0')}',
                                                      style: TextStyle(color: Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCalendarCell(DateTime day, DateTime selectedDate, List<FoodLog> allLogs, double goalCal, {bool isSelected = false, bool isToday = false}) {
    // Calculate total calories for this specific day
    double totalCal = 0;
    for (var log in allLogs) {
      if (isSameDay(log.loggedDate, day)) {
        totalCal += log.calories;
      }
    }
    
    double completion = goalCal > 0 ? (totalCal / goalCal) : 0;
    bool hasData = totalCal > 0;

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.green : (isToday ? Colors.green.withValues(alpha: 0.1) : Colors.transparent),
        border: isToday && !isSelected ? Border.all(color: Colors.green.withValues(alpha: 0.5), width: 1.5) : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (hasData && !isSelected)
            CircularProgressIndicator(
              value: completion,
              backgroundColor: Colors.grey.shade200,
              color: Colors.green.shade400,
              strokeWidth: 3,
            ),
          if (hasData && isSelected)
            CircularProgressIndicator(
              value: completion,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              color: Colors.white,
              strokeWidth: 3,
            ),
          Text(
            day.day.toString(),
            style: TextStyle(
              fontWeight: isSelected || isToday || hasData ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : (isToday ? Colors.green : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
