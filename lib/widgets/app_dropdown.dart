import 'package:flutter/material.dart';

/// Single option for [AppDropdown].
class AppDropdownItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final IconData? icon;
  const AppDropdownItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
  });
}

/// Unified polished Material 3 dropdown used across the app.
///
/// Replaces raw DropdownButtonFormField usage so every picker looks the
/// same in light + AMOLED dark, with rounded menu, green focus ring and
/// a check indicator on the selected row.
class AppDropdown<T> extends StatelessWidget {
  final T? value;
  final List<AppDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String label;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;
  final bool enabled;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.label,
    this.prefixIcon,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final green = isDark ? Colors.green.shade400 : Colors.green.shade700;
    final fill = isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade100;
    final menuColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.white60 : Colors.grey.shade600;

    return DropdownButtonFormField<T>(
      initialValue: value,
      isExpanded: true,
      validator: validator,
      onChanged: enabled ? onChanged : null,
      dropdownColor: menuColor,
      borderRadius: BorderRadius.circular(16),
      menuMaxHeight: 340,
      elevation: 8,
      icon: Container(
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
        prefixIconConstraints:
            const BoxConstraints(minWidth: 48, minHeight: 40),
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
      selectedItemBuilder: (context) {
        return items.map((e) {
          return Row(
            children: [
              Expanded(
                child: Text(
                  e.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
            ],
          );
        }).toList();
      },
      items: items.map((e) {
        final isSelected = e.value == value;
        return DropdownMenuItem<T>(
          value: e.value,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                if (e.icon != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? green.withValues(alpha: 0.18)
                          : (isDark
                              ? Colors.white10
                              : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      e.icon,
                      size: 18,
                      color: isSelected ? green : subColor,
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        e.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                      if (e.subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            e.subtitle!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12, color: subColor),
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: green,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
