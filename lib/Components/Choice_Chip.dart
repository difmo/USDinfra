import 'package:flutter/material.dart';
import '../../conigs/app_colors.dart';

class ChoiceChipOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const ChoiceChipOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
      elevation: 1,
      shadowColor: AppColors.shadow,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.white,
    );
  }
}
