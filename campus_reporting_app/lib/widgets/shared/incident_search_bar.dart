import 'package:flutter/material.dart';

class IncidentSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const IncidentSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: TextStyle(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: 'Search for reports',
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          filled: true,
          fillColor: colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: colorScheme.primary, width: 1),
          ),
        ),
      ),
    );
  }
}
