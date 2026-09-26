import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';
import '../utils/llm_parser.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  String _gender = 'M';
  
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  String _activityLevel = 'Sedentary';
  String _goal = 'Maintenance';
  final _goalRateCtrl = TextEditingController(text: '0.0');

  final _calCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();
  final _fiberCtrl = TextEditingController();

  void _calculateMacros() {
    final age = int.tryParse(_ageCtrl.text) ?? 25;
    final weight = double.tryParse(_weightCtrl.text) ?? 70.0;
    final height = double.tryParse(_heightCtrl.text) ?? 170.0;
    final rate = double.tryParse(_goalRateCtrl.text) ?? 0.0;

    // Mifflin-St Jeor Equation
    double bmr = (10 * weight) + (6.25 * height) - (5 * age);
    bmr += (_gender == 'M') ? 5 : -161;

    double activityMultiplier = 1.2;
    switch (_activityLevel) {
      case 'Lightly Active': activityMultiplier = 1.375; break;
      case 'Moderately Active': activityMultiplier = 1.55; break;
      case 'Very Active': activityMultiplier = 1.725; break;
      case 'Extremely Active': activityMultiplier = 1.9; break;
    }

    double tdee = bmr * activityMultiplier;
    
    // 1 kg of weight = ~7700 kcal. Daily deficit/surplus = rate * 7700 / 7 = rate * 1100
    double dailyAdjustment = rate * 1100;
    
    double targetCals = tdee;
    if (_goal == 'Weight Loss') targetCals -= dailyAdjustment;
    if (_goal == 'Weight Gain') targetCals += dailyAdjustment;

    // Ensure calories don't drop to dangerously low levels
    if (targetCals < 1200) targetCals = 1200;

    // Standard Macro Split: 30% Protein, 40% Carbs, 30% Fat
    double protein = (targetCals * 0.3) / 4.0;
    double carbs = (targetCals * 0.4) / 4.0;
    double fat = (targetCals * 0.3) / 9.0;
    double fiber = (targetCals / 1000.0) * 14.0;

    _calCtrl.text = targetCals.round().toString();
    _proteinCtrl.text = protein.round().toString();
    _carbsCtrl.text = carbs.round().toString();
    _fatCtrl.text = fat.round().toString();
    _fiberCtrl.text = fiber.round().toString();
  }

  void _nextStep() {
    if (_currentStep == 1 && !_formKey1.currentState!.validate()) return;
    if (_currentStep == 2) {
      if (!_formKey2.currentState!.validate()) return;
      // Auto-calculate macros before moving to step 3
      _calculateMacros();
    }
    
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _saveOnboarding();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _saveOnboarding() async {
    final db = ref.read(databaseProvider);
    
    final userId = await db.into(db.users).insert(UsersCompanion.insert(
      name: _nameCtrl.text.isEmpty ? 'User' : _nameCtrl.text,
      age: int.tryParse(_ageCtrl.text) ?? 25,
      gender: _gender,
      height: double.tryParse(_heightCtrl.text) ?? 170.0,
      currentWeight: double.tryParse(_weightCtrl.text) ?? 70.0,
      activityLevel: _activityLevel,
      goal: _goal,
      goalRate: double.tryParse(_goalRateCtrl.text) ?? 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));

    await db.into(db.macroGoals).insert(MacroGoalsCompanion.insert(
      userId: userId,
      caloriesTarget: int.tryParse(_calCtrl.text) ?? 2000,
      proteinTarget: double.tryParse(_proteinCtrl.text) ?? 150.0,
      carbsTarget: double.tryParse(_carbsCtrl.text) ?? 200.0,
      fatTarget: double.tryParse(_fatCtrl.text) ?? 60.0,
      fiberTarget: double.tryParse(_fiberCtrl.text) ?? 30.0,
      updatedAt: DateTime.now(),
    ));
  }

  Widget _buildStep0() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.track_changes, size: 80, color: Colors.green),
        const SizedBox(height: 24),
        const Text('Welcome to Macro Tracker', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.shade200)),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Disclaimer: Our app is purely a tracking and data visualization tool, not a medical or dietary advisor. Always consult a professional for dietary guidance.',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKey1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('About You', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameCtrl, 
            decoration: _inputDeco('Your Name'), 
            validator: (v) => v == null || v.isEmpty ? 'Required' : null
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageCtrl, 
            decoration: _inputDeco('Age'), 
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              final age = int.tryParse(v);
              if (age == null || age < 10 || age > 120) return 'Invalid age';
              return null;
            }
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _gender,
            decoration: _inputDeco('Gender'),
            items: ['M', 'F', 'Other'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _gender = v!),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Form(
      key: _formKey2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Your Body & Goals', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _heightCtrl, 
                  decoration: _inputDeco('Height (cm)'), 
                  keyboardType: TextInputType.number, 
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    final h = double.tryParse(v);
                    if (h == null || h < 50 || h > 250) return 'Invalid height';
                    return null;
                  }
                )
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _weightCtrl, 
                  decoration: _inputDeco('Weight (kg)'), 
                  keyboardType: TextInputType.number, 
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    final w = double.tryParse(v);
                    if (w == null || w < 20 || w > 300) return 'Invalid weight';
                    final h = double.tryParse(_heightCtrl.text);
                    if (h != null && h > 0) {
                      final bmi = w / ((h / 100) * (h / 100));
                      if (bmi < 10 || bmi > 70) return 'Physically impossible BMI';
                    }
                    return null;
                  }
                )
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _activityLevel,
            decoration: _inputDeco('Activity Level'),
            items: ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Extremely Active'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) => setState(() => _activityLevel = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _goal,
            decoration: _inputDeco('Goal'),
            items: ['Weight Loss', 'Maintenance', 'Weight Gain'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {
              setState(() {
                _goal = v!;
                if (_goal == 'Maintenance') {
                  _goalRateCtrl.text = '0.0';
                }
              });
            },
          ),
          const SizedBox(height: 16),
          if (_goal != 'Maintenance')
            TextFormField(
              controller: _goalRateCtrl, 
              decoration: _inputDeco('Target Rate (kg/week)'), 
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                final rate = double.tryParse(v);
                if (rate == null || rate <= 0 || rate > 1.5) {
                  return 'Must be between 0.1 and 1.5 kg/week';
                }
                return null;
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Macro Targets', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 8),
        const Text('We calculated these targets using the Mifflin-St Jeor formula based on your metrics. You can manually adjust them below.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(child: TextField(controller: _calCtrl, decoration: _inputDeco('Calories'), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _proteinCtrl, decoration: _inputDeco('Protein (g)'), keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: TextField(controller: _carbsCtrl, decoration: _inputDeco('Carbs (g)'), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _fatCtrl, decoration: _inputDeco('Fat (g)'), keyboardType: TextInputType.number)),
          ],
        ),
        const SizedBox(height: 12),
        TextField(controller: _fiberCtrl, decoration: _inputDeco('Fiber (g)'), keyboardType: TextInputType.number),
      ],
    );
  }

  InputDecoration _inputDeco(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> steps = [_buildStep0(), _buildStep1(), _buildStep2(), _buildStep3()];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey<int>(_currentStep),
                      child: steps[_currentStep],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    TextButton(
                      onPressed: _prevStep,
                      child: const Text('Back', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    )
                  else
                    const SizedBox.shrink(),
                  
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Text(_currentStep == steps.length - 1 ? 'Finish' : 'Next', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
