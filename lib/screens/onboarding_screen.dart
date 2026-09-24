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

  final _llmPasteCtrl = TextEditingController();
  final _calCtrl = TextEditingController();
  final _proteinCtrl = TextEditingController();
  final _carbsCtrl = TextEditingController();
  final _fatCtrl = TextEditingController();
  final _fiberCtrl = TextEditingController();

  void _nextStep() {
    if (_currentStep == 1 && !_formKey1.currentState!.validate()) return;
    if (_currentStep == 2 && !_formKey2.currentState!.validate()) return;
    
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

  void _showLLMPrompt() {
    final prompt = "Based on a $_gender, ${_ageCtrl.text} years old, ${_heightCtrl.text}cm, ${_weightCtrl.text}kg, with $_activityLevel activity level, aiming for $_goal of ${_goalRateCtrl.text} per week, what should be the daily macro targets for:\n"
                   "- Calories (kcal)\n"
                   "- Protein (g)\n"
                   "- Carbohydrates (g)\n"
                   "- Fat (g)\n"
                   "- Fiber (g)\n\n"
                   "Return ONLY the response in this exact format:\n"
                   "Calories: [NUMBER]\n"
                   "Protein: [NUMBER]\n"
                   "Carbs: [NUMBER]\n"
                   "Fat: [NUMBER]\n"
                   "Fiber: [NUMBER]";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask AI'),
        content: SelectableText(prompt),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: prompt));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Prompt copied! Paste it in ChatGPT or Gemini.')));
              Navigator.pop(context);
            },
            child: const Text('Copy to Clipboard'),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
        ],
      )
    );
  }

  void _extractMacros() {
    final macros = LlmParser.parseMacros(_llmPasteCtrl.text);
    setState(() {
      _calCtrl.text = macros['calories']!.toInt().toString();
      _proteinCtrl.text = macros['protein']!.toString();
      _carbsCtrl.text = macros['carbs']!.toString();
      _fatCtrl.text = macros['fat']!.toString();
      _fiberCtrl.text = macros['fiber']!.toString();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Macros extracted!')));
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
            validator: (v) => v!.isEmpty ? 'Required' : null
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _ageCtrl, 
            decoration: _inputDeco('Age'), 
            keyboardType: TextInputType.number,
            validator: (v) => v!.isEmpty ? 'Required' : null
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
              Expanded(child: TextFormField(controller: _heightCtrl, decoration: _inputDeco('Height (cm)'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
              const SizedBox(width: 16),
              Expanded(child: TextFormField(controller: _weightCtrl, decoration: _inputDeco('Weight (kg)'), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
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
            onChanged: (v) => setState(() => _goal = v!),
          ),
          const SizedBox(height: 16),
          TextFormField(controller: _goalRateCtrl, decoration: _inputDeco('Target Rate (kg/week)'), keyboardType: TextInputType.number),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Macro Targets', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AI Assistant', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('1. Generate and copy the prompt.\n2. Paste it into an AI (ChatGPT/Gemini).\n3. Paste the AI\'s exact response below.', style: TextStyle(fontSize: 13)),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _showLLMPrompt, 
                icon: const Icon(Icons.copy), 
                label: const Text('Copy Prompt'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _llmPasteCtrl,
                      decoration: _inputDeco('Paste AI output here...'),
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.auto_fix_high, color: Colors.green),
                    onPressed: _extractMacros,
                    tooltip: 'Extract',
                  )
                ],
              )
            ],
          ),
        ),
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
