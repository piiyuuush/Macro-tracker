import 'package:flutter/material.dart';

class AppSelector extends StatelessWidget {
  final String? valueText;
  final String label;
  final IconData? prefixIcon;
  final VoidCallback onTap;

  const AppSelector({
    super.key,
    required this.valueText,
    required this.label,
    this.prefixIcon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final green = isDark ? Colors.green.shade400 : Colors.green.shade700;
    final fill = isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100;
    final textColor = isDark ? Colors.white : Colors.black87;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: IgnorePointer(
        child: TextFormField(
          readOnly: true,
          controller: TextEditingController(text: valueText),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
          decoration: InputDecoration(
            labelText: label,
            filled: true,
            fillColor: fill,
            prefixIcon: prefixIcon != null
                ? Container(
                    margin: const EdgeInsets.only(left: 8, right: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.green.withValues(alpha: 0.15)
                          : Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(prefixIcon, size: 18, color: green),
                  )
                : null,
            suffixIcon: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.green.withValues(alpha: 0.15)
                    : Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: green,
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 48, minHeight: 40),
            suffixIconConstraints:
                const BoxConstraints(minWidth: 40, minHeight: 40),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: isDark ? Colors.white10 : Colors.grey.shade200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: green, width: 1.6),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
