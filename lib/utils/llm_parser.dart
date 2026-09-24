class LlmParser {
  static Map<String, double> parseMacros(String text) {
    final caloriesMatch = RegExp(r'Calories:\s*(\d+(?:\.\d+)?)', caseSensitive: false).firstMatch(text);
    final proteinMatch = RegExp(r'Protein:\s*(\d+(?:\.\d+)?)', caseSensitive: false).firstMatch(text);
    final carbsMatch = RegExp(r'Carbs:\s*(\d+(?:\.\d+)?)', caseSensitive: false).firstMatch(text);
    final fatMatch = RegExp(r'Fat:\s*(\d+(?:\.\d+)?)', caseSensitive: false).firstMatch(text);
    final fiberMatch = RegExp(r'Fiber:\s*(\d+(?:\.\d+)?)', caseSensitive: false).firstMatch(text);

    return {
      'calories': double.tryParse(caloriesMatch?.group(1) ?? '0') ?? 0,
      'protein': double.tryParse(proteinMatch?.group(1) ?? '0') ?? 0,
      'carbs': double.tryParse(carbsMatch?.group(1) ?? '0') ?? 0,
      'fat': double.tryParse(fatMatch?.group(1) ?? '0') ?? 0,
      'fiber': double.tryParse(fiberMatch?.group(1) ?? '0') ?? 0,
    };
  }
}
