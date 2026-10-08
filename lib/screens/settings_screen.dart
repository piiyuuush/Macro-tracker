import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../utils/backup_service.dart';
import '../widgets/notifications_settings_modal.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? Colors.black : Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppearanceSection(context, ref),
            const SizedBox(height: 32),
            const Text('Data Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: isDark ? Colors.blue.withValues(alpha: 0.15) : Colors.blue.shade50, shape: BoxShape.circle),
                  child: Icon(Icons.notifications_active, color: isDark ? Colors.blue.shade400 : Colors.blue.shade700),
                ),
                title: const Text('Meal Reminders', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Set up notifications to log food'),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => const NotificationsSettingsModal(),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: isDark ? Colors.green.withValues(alpha: 0.15) : Colors.green.shade100, shape: BoxShape.circle),
                  child: Icon(Icons.download_rounded, color: isDark ? Colors.green.shade400 : Colors.green.shade700),
                ),
                title: const Text('Export Data', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Save a full backup (JSON)'),
                onTap: () => BackupService.showExportOptions(context, ref),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: isDark ? Colors.white12 : Colors.grey.shade300)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: isDark ? Colors.orange.withValues(alpha: 0.15) : Colors.orange.shade50, shape: BoxShape.circle),
                  child: Icon(Icons.upload_rounded, color: isDark ? Colors.orange.shade400 : Colors.orange.shade700),
                ),
                title: const Text('Import Data', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Restore from a backup'),
                onTap: () => BackupService.importData(context, ref),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeModeProvider);
    final notifier = ref.read(themeModeProvider.notifier);
    final themeMode = themeAsync.value ?? ThemeMode.system;
    final followSystem = themeMode == ThemeMode.system;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Appearance',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isDark ? Colors.white12 : Colors.grey.shade300,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  secondary: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.green.withValues(alpha: 0.15)
                          : Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.brightness_auto,
                      color: isDark
                          ? Colors.green.shade400
                          : Colors.green.shade700,
                    ),
                  ),
                  title: const Text(
                    'Follow system theme',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    followSystem
                        ? 'Currently: ${isDark ? 'AMOLED Black' : 'Light'} (system)'
                        : 'Off — choose manually below',
                  ),
                  value: followSystem,
                  onChanged: (v) => notifier.followSystem(v),
                ),
                if (!followSystem) ...[
                  const Divider(height: 1, indent: 20, endIndent: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.palette_outlined, size: 20),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Theme',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SegmentedButton<ThemeMode>(
                          segments: const [
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.light,
                              label: Text('Light'),
                              icon: Icon(Icons.light_mode, size: 16),
                            ),
                            ButtonSegment<ThemeMode>(
                              value: ThemeMode.dark,
                              label: Text('AMOLED'),
                              icon:
                                  Icon(Icons.dark_mode, size: 16),
                            ),
                          ],
                          selected: {
                            themeMode == ThemeMode.dark
                                ? ThemeMode.dark
                                : ThemeMode.light
                          },
                          onSelectionChanged: (s) =>
                              notifier.setTheme(s.first),
                          showSelectedIcon: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
