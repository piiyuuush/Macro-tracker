import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../providers/data_providers.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import 'package:drift/drift.dart' as drift;

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {

  Future<void> _exportData(BuildContext context) async {
    try {
      final db = ref.read(databaseProvider);
      
      final users = await db.select(db.users).get();
      final macroGoals = await db.select(db.macroGoals).get();
      final foodItems = await db.select(db.foodItems).get();
      final foodLogs = await db.select(db.foodLogs).get();
      final meals = await db.select(db.meals).get();
      final mealItems = await db.select(db.mealItems).get();
      
      final data = {
        'users': users.map((u) => u.toJson()).toList(),
        'macroGoals': macroGoals.map((m) => m.toJson()).toList(),
        'foodItems': foodItems.map((f) => f.toJson()).toList(),
        'foodLogs': foodLogs.map((l) => l.toJson()).toList(),
        'meals': meals.map((m) => m.toJson()).toList(),
        'mealItems': mealItems.map((mi) => mi.toJson()).toList(),
      };
      
      final String jsonData = jsonEncode(data);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/macro_tracker_backup.json');
      await file.writeAsString(jsonData);
      
      if (context.mounted) {
        await Share.shareXFiles([XFile(file.path)], text: 'My Macro Tracker Backup');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error exporting: $e')));
      }
    }
  }

  Future<void> _importData(BuildContext context) async {
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      
      if (result != null && result.path != null) {
        final file = File(result.path!);
        final String jsonData = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(jsonData);
        
        final db = ref.read(databaseProvider);
        
        bool confirm = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Restore Backup?'),
            content: const Text('This will overwrite all your current data. This action cannot be undone.'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.pop(ctx, true), 
                child: const Text('Restore', style: TextStyle(color: Colors.white))
              ),
            ],
          )
        ) ?? false;
        
        if (!confirm) return;

        await db.transaction(() async {
          await db.delete(db.mealItems).go();
          await db.delete(db.meals).go();
          await db.delete(db.foodLogs).go();
          await db.delete(db.foodItems).go();
          await db.delete(db.macroGoals).go();
          await db.delete(db.users).go();
          
          if (data['users'] != null) {
            for (var u in data['users']) {
              await db.into(db.users).insert(User.fromJson(u));
            }
          }
          if (data['macroGoals'] != null) {
            for (var m in data['macroGoals']) {
              await db.into(db.macroGoals).insert(MacroGoal.fromJson(m));
            }
          }
          if (data['foodItems'] != null) {
            for (var f in data['foodItems']) {
              await db.into(db.foodItems).insert(FoodItem.fromJson(f));
            }
          }
          if (data['foodLogs'] != null) {
            for (var l in data['foodLogs']) {
              await db.into(db.foodLogs).insert(FoodLog.fromJson(l));
            }
          }
          if (data['meals'] != null) {
            for (var m in data['meals']) {
              await db.into(db.meals).insert(Meal.fromJson(m));
            }
          }
          if (data['mealItems'] != null) {
            for (var mi in data['mealItems']) {
              await db.into(db.mealItems).insert(MealItem.fromJson(mi));
            }
          }
        });
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Backup restored successfully!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error importing: $e')));
      }
    }
  }

  void _showEditModal(BuildContext context, User user, MacroGoal goals) {
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditProfileForm(user: user, goals: goals)
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProfileProvider);
    final goalsAsync = ref.watch(macroGoalsProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) return const Center(child: Text('No User Profile Found'));
          return goalsAsync.when(
            data: (goals) {
              if (goals == null) return const Center(child: Text('No Goals Found'));

              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade600]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(radius: 40, backgroundColor: Colors.white, child: Icon(Icons.person, size: 50, color: Colors.green)),
                          const SizedBox(height: 16),
                          Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 8),
                          Text('${user.age} yrs • ${user.gender} • ${user.currentWeight} kg • ${user.height} cm', style: TextStyle(fontSize: 16, color: Colors.green.shade100)),
                          const SizedBox(height: 8),
                          Text('Goal: ${user.goal} (${user.goalRate} kg/wk)', style: const TextStyle(fontSize: 14, color: Colors.white70)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Daily Macro Targets', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                        TextButton.icon(
                          onPressed: () => _showEditModal(context, user, goals),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Edit'),
                          style: TextButton.styleFrom(foregroundColor: Colors.green.shade700),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Macro Targets Grid
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      childAspectRatio: 2.5,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildMacroCard('Calories', '${goals.caloriesTarget} kcal', Icons.local_fire_department, Colors.orange),
                        _buildMacroCard('Protein', '${goals.proteinTarget} g', Icons.fitness_center, Colors.blue),
                        _buildMacroCard('Carbs', '${goals.carbsTarget} g', Icons.breakfast_dining, Colors.yellow.shade700),
                        _buildMacroCard('Fat', '${goals.fatTarget} g', Icons.water_drop, Colors.red.shade400),
                        _buildMacroCard('Fiber', '${goals.fiberTarget} g', Icons.grass, Colors.green.shade400),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                    const Text('Data Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade300)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.green.shade100, shape: BoxShape.circle),
                          child: Icon(Icons.download_rounded, color: Colors.green.shade700),
                        ),
                        title: const Text('Export Data', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Save a full backup (JSON)'),
                        onTap: () => _exportData(context),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade300)),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.orange.shade50, shape: BoxShape.circle),
                          child: Icon(Icons.upload_rounded, color: Colors.orange.shade700),
                        ),
                        title: const Text('Import Data', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Restore from a backup'),
                        onTap: () => _importData(context),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
            error: (e, s) => Center(child: Text('Error: $e')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: Colors.green)),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(0, 3))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _EditProfileForm extends ConsumerStatefulWidget {
  final User user;
  final MacroGoal goals;
  const _EditProfileForm({required this.user, required this.goals});

  @override
  ConsumerState<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _weightCtrl;
  late TextEditingController _heightCtrl;
  late TextEditingController _ageCtrl;
  late String _activityLevel;
  late String _goal;
  late TextEditingController _goalRateCtrl;

  late TextEditingController _calCtrl;
  late TextEditingController _proteinCtrl;
  late TextEditingController _carbsCtrl;
  late TextEditingController _fatCtrl;

  @override
  void initState() {
    super.initState();
    _weightCtrl = TextEditingController(text: widget.user.currentWeight.toString());
    _heightCtrl = TextEditingController(text: widget.user.height.toString());
    _ageCtrl = TextEditingController(text: widget.user.age.toString());
    _activityLevel = widget.user.activityLevel;
    _goal = widget.user.goal;
    _goalRateCtrl = TextEditingController(text: widget.user.goalRate.toString());

    _calCtrl = TextEditingController(text: widget.goals.caloriesTarget.toString());
    _proteinCtrl = TextEditingController(text: widget.goals.proteinTarget.toString());
    _carbsCtrl = TextEditingController(text: widget.goals.carbsTarget.toString());
    _fatCtrl = TextEditingController(text: widget.goals.fatTarget.toString());
  }

  void _recalculateMacros() {
    final weight = double.tryParse(_weightCtrl.text) ?? widget.user.currentWeight;
    final height = double.tryParse(_heightCtrl.text) ?? widget.user.height;
    final age = int.tryParse(_ageCtrl.text) ?? widget.user.age;
    final rate = double.tryParse(_goalRateCtrl.text) ?? widget.user.goalRate;

    double bmr = (10 * weight) + (6.25 * height) - (5 * age);
    bmr += (widget.user.gender == 'M') ? 5 : -161;

    double activityMultiplier = 1.2;
    switch (_activityLevel) {
      case 'Lightly Active': activityMultiplier = 1.375; break;
      case 'Moderately Active': activityMultiplier = 1.55; break;
      case 'Very Active': activityMultiplier = 1.725; break;
      case 'Extremely Active': activityMultiplier = 1.9; break;
    }

    double tdee = bmr * activityMultiplier;
    double dailyAdjustment = rate * 1100;
    
    double targetCals = tdee;
    if (_goal == 'Weight Loss') targetCals -= dailyAdjustment;
    if (_goal == 'Weight Gain') targetCals += dailyAdjustment;

    if (targetCals < 1200) targetCals = 1200;

    double protein = (targetCals * 0.3) / 4.0;
    double carbs = (targetCals * 0.4) / 4.0;
    double fat = (targetCals * 0.3) / 9.0;

    setState(() {
      _calCtrl.text = targetCals.round().toString();
      _proteinCtrl.text = protein.round().toString();
      _carbsCtrl.text = carbs.round().toString();
      _fatCtrl.text = fat.round().toString();
    });
  }

  void _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final db = ref.read(databaseProvider);

    await db.update(db.users).replace(
      widget.user.copyWith(
        currentWeight: double.parse(_weightCtrl.text),
        height: double.parse(_heightCtrl.text),
        age: int.parse(_ageCtrl.text),
        activityLevel: _activityLevel,
        goal: _goal,
        goalRate: double.parse(_goalRateCtrl.text),
        updatedAt: DateTime.now(),
      )
    );

    await db.update(db.macroGoals).replace(
      widget.goals.copyWith(
        caloriesTarget: int.parse(_calCtrl.text),
        proteinTarget: double.parse(_proteinCtrl.text),
        carbsTarget: double.parse(_carbsCtrl.text),
        fatTarget: double.parse(_fatCtrl.text),
        updatedAt: DateTime.now(),
      )
    );

    if (mounted) Navigator.pop(context);
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24, left: 24, right: 24
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Edit Profile & Goals', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _weightCtrl, decoration: _inputDeco('Weight (kg)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _heightCtrl, decoration: _inputDeco('Height (cm)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _ageCtrl, decoration: _inputDeco('Age'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _activityLevel,
                decoration: _inputDeco('Activity Level'),
                items: ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Extremely Active'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _activityLevel = v!),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: _goal,
                      decoration: _inputDeco('Goal'),
                      items: ['Weight Loss', 'Maintenance', 'Weight Gain'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) => setState(() => _goal = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _goalRateCtrl, decoration: _inputDeco('Rate/wk'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _recalculateMacros,
                icon: const Icon(Icons.calculate),
                label: const Text('Recalculate Macros'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade50, foregroundColor: Colors.orange.shade800, elevation: 0),
              ),
              const Divider(height: 32),
              const Text('Macro Targets', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _calCtrl, decoration: _inputDeco('Calories'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _proteinCtrl, decoration: _inputDeco('Protein (g)'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _carbsCtrl, decoration: _inputDeco('Carbs (g)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _fatCtrl, decoration: _inputDeco('Fat (g)'), keyboardType: TextInputType.number)),
                ],
              ),
              
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
