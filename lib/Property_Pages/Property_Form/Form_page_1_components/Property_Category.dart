import 'package:flutter/material.dart';

import '../../../Components/Choice_Chip.dart';
import '../../../Components/Error_message.dart';
// import 'error_message.dart';
// import 'choice_chip_option.dart';

class PropertyCategoryColumn extends StatelessWidget {
  final String? propertyCategory;
  final ValueChanged<String?> onSelectPropertyCategory;
  final List<String> propertyCategories;
  final String? propertyCategoryError;

  const PropertyCategoryColumn({
    super.key,
    required this.propertyCategory,
    required this.onSelectPropertyCategory,
    required this.propertyCategories,
    this.propertyCategoryError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Property Category',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: propertyCategories
              .map((option) => ChoiceChipOption(
            label: option,
            isSelected: propertyCategory == option,
            onSelected: (selected) {
              onSelectPropertyCategory(selected ? option : null);
            },
          ))
              .toList(),
        ),
        ErrorMessage(errorText: propertyCategoryError),
      ],
    );
  }
}
