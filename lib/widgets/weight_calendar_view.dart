import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightCalendarView extends ConsumerStatefulWidget {
  final List<WeightLog> logs;
  const WeightCalendarView({super.key, required this.logs});

  @override
  ConsumerState<WeightCalendarView> createState() => _WeightCalendarViewState();
}

class _WeightCalendarViewState extends ConsumerState<WeightCalendarView> {
  bool _isExpanded = false;
  late DateTime _currentMonth;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Map of date -> weight
    final logMap = <DateTime, double>{};
    for (var log in widget.logs) {
      final date = DateTime(log.loggedDate.year, log.loggedDate.month, log.loggedDate.day);
      logMap[date] = log.weight;
    }

    // Determine date range for chart
    List<DateTime> chartDates = [];
    if (!_isExpanded) {
      for (int i = 6; i >= 0; i--) {
        chartDates.add(DateTime(todayDate.year, todayDate.month, todayDate.day - i));
      }
    } else {
      final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
      for (int i = 1; i <= daysInMonth; i++) {
        chartDates.add(DateTime(_currentMonth.year, _currentMonth.month, i));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.green.withValues(alpha: 0.15) : Colors.green.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.monitor_weight_outlined,
                  color: isDark ? Colors.green.shade400 : Colors.green.shade700),
            ),
            const SizedBox(width: 16),
            const Text('Weight Trends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 32),
        _buildLineChart(chartDates, logMap, isDark),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Log History', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                  if (_isExpanded) {
                    _currentMonth = DateTime(today.year, today.month);
                  }
                });
              },
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, size: 20),
              label: Text(_isExpanded ? 'Show Week' : 'Show Month'),
            )
          ],
        ),
        const SizedBox(height: 12),
        if (!_isExpanded) _buildWeekView(todayDate, logMap, isDark)
        else _buildMonthView(logMap, isDark),
      ],
    );
  }

  Widget _buildLineChart(List<DateTime> dateRange, Map<DateTime, double> logMap, bool isDark) {
    final spots = <FlSpot>[];
    double? minY;
    double? maxY;

    for (int i = 0; i < dateRange.length; i++) {
      final date = dateRange[i];
      final weight = logMap[date];
      if (weight != null) {
        spots.add(FlSpot(i.toDouble(), weight));
        if (minY == null || weight < minY) minY = weight;
        if (maxY == null || weight > maxY) maxY = weight;
      }
    }

    if (spots.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('No logs to display')),
      );
    }

    minY = minY! - 2;
    maxY = maxY! + 2;

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (dateRange.length - 1).toDouble(),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minY: minY,
          maxY: maxY,
          lineTouchData: LineTouchData(
            touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
              if (event is FlTapUpEvent && touchResponse != null && touchResponse.lineBarSpots != null) {
                final spotIndex = touchResponse.lineBarSpots!.first.x.toInt();
                if (spotIndex >= 0 && spotIndex < dateRange.length) {
                  setState(() {
                    _selectedDate = dateRange[spotIndex];
                  });
                }
              }
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y.toStringAsFixed(1)} kg',
                    TextStyle(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  final dateIndex = spot.x.toInt();
                  if (dateIndex < 0 || dateIndex >= dateRange.length) {
                    return FlDotCirclePainter(radius: 4, color: Colors.green, strokeWidth: 0);
                  }
                  final date = dateRange[dateIndex];
                  final isSelected = _selectedDate != null && 
                                     _selectedDate!.year == date.year && 
                                     _selectedDate!.month == date.month && 
                                     _selectedDate!.day == date.day;
                  
                  if (isSelected) {
                    return FlDotCirclePainter(
                      radius: 6,
                      color: isDark ? Colors.green.shade200 : Colors.white,
                      strokeWidth: 3,
                      strokeColor: Colors.green,
                    );
                  }
                  return FlDotCirclePainter(radius: 4, color: Colors.green, strokeWidth: 0);
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.green.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekView(DateTime todayDate, Map<DateTime, double> logMap, bool isDark) {
    List<DateTime> weekDates = [];
    for (int i = 6; i >= 0; i--) {
      weekDates.add(DateTime(todayDate.year, todayDate.month, todayDate.day - i));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDates.map((date) => Flexible(
        child: _buildDayCircle(date, logMap[date] != null, isDark, isToday: date == todayDate)
      )).toList(),
    );
  }

  Widget _buildMonthView(Map<DateTime, double> logMap, bool isDark) {
    final daysInMonth = DateUtils.getDaysInMonth(_currentMonth.year, _currentMonth.month);
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final firstWeekday = firstDay.weekday; 

    int emptyPrefix = firstWeekday - 1; 

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
                });
              },
            ),
            Text(DateFormat.yMMMM().format(_currentMonth), style: const TextStyle(fontWeight: FontWeight.w600)),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) => 
            Expanded(child: Center(child: Text(d, style: TextStyle(color: Colors.grey.shade500, fontSize: 12))))
          ).toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: emptyPrefix + daysInMonth,
          itemBuilder: (context, index) {
            if (index < emptyPrefix) return const SizedBox.shrink();
            final day = index - emptyPrefix + 1;
            final date = DateTime(_currentMonth.year, _currentMonth.month, day);
            final today = DateTime.now();
            final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
            
            return _buildDayCircle(date, logMap[date] != null, isDark, isToday: isToday);
          },
        ),
      ],
    );
  }

  Widget _buildDayCircle(DateTime date, bool hasWeight, bool isDark, {bool isToday = false}) {
    final isSelected = _selectedDate != null && 
                       _selectedDate!.year == date.year && 
                       _selectedDate!.month == date.month && 
                       _selectedDate!.day == date.day;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      onLongPress: hasWeight ? () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Log'),
            content: Text('Delete weight log for ${DateFormat.yMd().format(date)}?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
            ],
          )
        );
        if (confirm == true) {
          final db = ref.read(databaseProvider);
          final logs = widget.logs.where((l) {
             final ld = DateTime(l.loggedDate.year, l.loggedDate.month, l.loggedDate.day);
             return ld == date;
          }).toList();
          for (var l in logs) {
            await (db.delete(db.weightLogs)..where((t) => t.id.equals(l.id))).go();
          }
        }
      } : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected 
                  ? Colors.green 
                  : hasWeight 
                      ? (isDark ? Colors.green.withValues(alpha: 0.2) : Colors.green.shade100)
                      : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              border: isToday && !isSelected ? Border.all(color: Colors.green, width: 2) : null,
            ),
            child: Center(
              child: Text(
                date.day.toString(), 
                style: TextStyle(
                  fontSize: 14, 
                  fontWeight: hasWeight || isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected 
                      ? Colors.white 
                      : hasWeight 
                          ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
                          : (isDark ? Colors.grey.shade500 : Colors.grey.shade600)
                )
              ),
            ),
          ),
          if (!_isExpanded) ...[
            const SizedBox(height: 4),
            Text(DateFormat.E().format(date)[0], style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ]
        ],
      ),
    );
  }
}
