import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math';

class NotificationsSettingsModal extends StatefulWidget {
  const NotificationsSettingsModal({super.key});

  @override
  State<NotificationsSettingsModal> createState() => _NotificationsSettingsModalState();
}

class _NotificationsSettingsModalState extends State<NotificationsSettingsModal> {
  final TextEditingController _countController = TextEditingController();
  List<TimeOfDay> _times = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final timesStr = prefs.getString('notification_times');
    if (timesStr != null) {
      try {
        final List<dynamic> decoded = jsonDecode(timesStr);
        _times = decoded.map((e) => TimeOfDay(hour: e['h'], minute: e['m'])).toList();
        _countController.text = _times.length.toString();
      } catch (e) {}
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, int>> toSave = _times.map((t) => {'h': t.hour, 'm': t.minute}).toList();
    await prefs.setString('notification_times', jsonEncode(toSave));
    
    // Stub for scheduling notifications
    _scheduleNotifications();
    
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reminders saved!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
      );
    }
  }

  void _scheduleNotifications() {
    // 6-7 casual messages randomly chosen
    final messages = [
      "Hey there! Don't forget to log your last meal. 🍎",
      "Time to track those macros! You've got this. 💪",
      "Did you eat something tasty? Log it before you forget! 🍕",
      "Just a friendly reminder to keep your food diary updated. ✍️",
      "Stay on track! What did you have recently? 🥗",
      "Logging food takes 10 seconds. Do it now! ⏱️",
      "Macros won't track themselves! Jump in and log it. 🥑"
    ];
    
    final random = Random();
    // In a full implementation, flutter_local_notifications would be used
    // to schedule a daily alarm for each TimeOfDay in _times, 
    // picking a random message from the list for the notification body!
    print("Scheduling ${messages[random.nextInt(messages.length)]} for $_times");
  }

  void _updateCount(String val) {
    int count = int.tryParse(val) ?? 0;
    if (count < 0) count = 0;
    if (count > 10) count = 10; // sensible max
    
    setState(() {
      if (count > _times.length) {
        _times.addAll(List.generate(count - _times.length, (_) => const TimeOfDay(hour: 12, minute: 0)));
      } else if (count < _times.length) {
        _times = _times.sublist(0, count);
      }
    });
  }

  Future<void> _pickTime(int index) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _times[index],
    );
    if (picked != null) {
      setState(() {
        _times[index] = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111111) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 24, left: 24, right: 24
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Meal Reminders', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 8),
            Text('How many times a day do you want to be reminded to log food?', style: TextStyle(color: isDark ? Colors.white70 : Colors.black87)),
            const SizedBox(height: 16),
            TextField(
              controller: _countController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of Reminders (e.g., 3)',
                filled: true,
                fillColor: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: _updateCount,
            ),
            const SizedBox(height: 16),
            if (_times.isNotEmpty) ...[
              const Text('Set your reminder times:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...List.generate(_times.length, (index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  color: isDark ? Colors.green.withValues(alpha: 0.12) : Colors.green.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.green),
                    title: Text('Reminder ${index + 1}'),
                    trailing: Text(
                      _times[index].format(context),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                    ),
                    onTap: () => _pickTime(index),
                  ),
                );
              }),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Reminders', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
