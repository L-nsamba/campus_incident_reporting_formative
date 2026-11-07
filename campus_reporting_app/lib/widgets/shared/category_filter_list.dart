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

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 9,
      runSpacing: 9,

      children: [
        _buildCategoryChip(
          context: context,
          label: 'All',
          isSelected: selectedCategory == null,
          onTap: () => onCategorySelected(null),
        ),

        ...IncidentCategoryEnum.values.map((category) {
          return _buildCategoryChip(
            context: context,
            label: category.label,
            isSelected: selectedCategory == category,
            onTap: () => onCategorySelected(category),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.surface
            : AppColors.textSecondary,
      ),
    );
  }
}
