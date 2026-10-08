void main() {
  List<Map<String, dynamic>> cases = [
    {"weight": 70.0, "tdee": 2200.0, "goal": "Maintenance", "adj": 0.0},
    {"weight": 70.0, "tdee": 2200.0, "goal": "Weight Loss", "adj": 500.0},
    {"weight": 120.0, "tdee": 2500.0, "goal": "Weight Loss", "adj": 1000.0},
    {"weight": 50.0, "tdee": 1800.0, "goal": "Weight Gain", "adj": 500.0},
    {"weight": 70.0, "tdee": 2200.0, "goal": "Recomposition", "adj": 0.0},
  ];

  for (var c in cases) {
    double weight = c['weight'];
    double targetCals = c['tdee'];
    if (c['goal'] == 'Weight Loss') targetCals -= c['adj'];
    if (c['goal'] == 'Weight Gain') targetCals += c['adj'];
    
    if (targetCals < 1200) targetCals = 1200;
    
    double protein = weight * 2.0;
    double fat = (targetCals * 0.25) / 9.0;
    
    double proteinCals = protein * 4.0;
    double fatCals = fat * 9.0;
    
    double remainingCals = targetCals - proteinCals - fatCals;
    
    if (remainingCals < 0) {
       fat = (targetCals * 0.20) / 9.0;
       fatCals = fat * 9.0;
       remainingCals = targetCals - fatCals;
       if (remainingCals < 0) remainingCals = 0;
       protein = remainingCals / 4.0;
       remainingCals = 0;
    }
    
    double carbs = remainingCals / 4.0;
    
    print("Goal: ${c['goal']} | Weight: ${weight}kg | Cals: $targetCals | P: ${protein.round()}g (${(protein*4/targetCals*100).round()}%) | F: ${fat.round()}g (${(fat*9/targetCals*100).round()}%) | C: ${carbs.round()}g (${(carbs*4/targetCals*100).round()}%)");
  }
}
