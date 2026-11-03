import 'package:campus_reporting_app/core/theme/app_colors.dart';
import 'package:campus_reporting_app/enum/incident_category_enum.dart';
import 'package:flutter/material.dart';

class CategoryFilterList extends StatelessWidget {
  final IncidentCategoryEnum? selectedCategory;
  final ValueChanged<IncidentCategoryEnum?> onCategorySelected;
  const CategoryFilterList({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  String _categoryLabel(IncidentCategoryEnum category) {
    switch (category) {
      case IncidentCategoryEnum.facilities:
        return 'Facilities';
      case IncidentCategoryEnum.water:
        return 'Water';
      case IncidentCategoryEnum.electricity:
        return 'Electricity';
      case IncidentCategoryEnum.furniture:
        return 'Furniture';
      case IncidentCategoryEnum.sanitation:
        return 'Sanitation';
      case IncidentCategoryEnum.safety:
        return 'Safety';
      case IncidentCategoryEnum.other:
        return 'Other';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,

      children: [
        _buildCategoryChip(
          label: 'All',
          isSelected: selectedCategory == null,
          onTap: () => onCategorySelected(null),
        ),

        ...IncidentCategoryEnum.values.map((category) {
          return _buildCategoryChip(
            label: _categoryLabel(category),
            isSelected: selectedCategory == category,
            onTap: () => onCategorySelected(category),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
    );
  }
}
