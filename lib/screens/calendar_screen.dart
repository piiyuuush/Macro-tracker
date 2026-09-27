
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../providers/data_providers.dart';
import '../database/database.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final allLogsAsync = ref.watch(allFoodLogsProvider);
    final macroGoalsAsync = ref.watch(macroGoalsProvider);
    final foodItemsAsync = ref.watch(foodItemsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.black : Colors.green,
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
                    color: isDark ? Colors.black : Colors.white,
                    height: 430, // Fixed height to prevent layout shifts between 5-week and 6-week months
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: selectedDate,
                      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        ref.read(selectedDateProvider.notifier).updateDate(selectedDay);
                      },
                      calendarFormat: CalendarFormat.month,
                      rowHeight: 58,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                        titleTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 17, fontWeight: FontWeight.w600),
                        leftChevronIcon: Icon(Icons.chevron_left, color: isDark ? Colors.white70 : Colors.black54),
                        rightChevronIcon: Icon(Icons.chevron_right, color: isDark ? Colors.white70 : Colors.black54),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                        weekendStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
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
                        defaultTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        weekendTextStyle: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        outsideTextStyle: TextStyle(color: isDark ? Colors.white24 : Colors.grey),
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          return _buildCalendarCell(context, day, selectedDate, allLogs, goalCal, isToday: isSameDay(day, DateTime.now()));
                        },
                        todayBuilder: (context, day, focusedDay) {
                          return _buildCalendarCell(context, day, selectedDate, allLogs, goalCal, isToday: true);
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return _buildCalendarCell(context, day, selectedDate, allLogs, goalCal, isSelected: true, isToday: isSameDay(day, DateTime.now()));
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
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isDark ? Colors.white10 : Colors.grey.shade300)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.all(12),
                                                decoration: BoxDecoration(color: isDark ? Colors.green.withValues(alpha: 0.15) : Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
                                                child: Icon(food.category != null && food.category!.startsWith('Meal') ? Icons.restaurant : Icons.fastfood, color: isDark ? Colors.green.shade400 : Colors.green.shade700, size: 24),
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
                                                      style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade700, fontSize: 13),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      '${log.quantity.toInt()} ${food.servingType == 'weight' ? 'g' : (food.servingType == 'volume' ? 'ml' : 'x')} logged at ${log.loggedTime.hour}:${log.loggedTime.minute.toString().padLeft(2, '0')}',
                                                      style: TextStyle(color: isDark ? Colors.green.shade400 : Colors.green.shade600, fontSize: 12, fontWeight: FontWeight.w500),
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

  Widget _buildCalendarCell(BuildContext context, DateTime day, DateTime selectedDate, List<FoodLog> allLogs, double goalCal, {bool isSelected = false, bool isToday = false}) {
    // Calculate total calories for this specific day
    double totalCal = 0;
    for (var log in allLogs) {
      if (isSameDay(log.loggedDate, day)) {
        totalCal += log.calories;
      }
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    double completion = goalCal > 0 ? (totalCal / goalCal) : 0;
    bool hasData = totalCal > 0;

    return Container(
      width: 44,
      height: 44,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? Colors.green : (isToday ? Colors.green.withValues(alpha: 0.1) : Colors.transparent),
        border: isToday && !isSelected ? Border.all(color: Colors.green.withValues(alpha: 0.5), width: 1.5) : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (hasData)
            SizedBox.expand(
              child: CircularProgressIndicator(
                value: completion,
                backgroundColor: Colors.transparent,
                color: isSelected ? Colors.white : Colors.green,
                strokeWidth: 3,
              ),
            ),
          Text(
            day.day.toString(),
            style: TextStyle(
              fontWeight: isSelected || isToday || hasData ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : (isToday ? Colors.green : (isDark ? Colors.white : Colors.black87)),
            ),
          ),
        ],
      ),
    );
  }
}
