import 'package:flutter/material.dart';
import 'package:usdinfra/Components/Choice_Chip.dart';
import 'package:usdinfra/configs/font_family.dart';

class CustomMultiSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<List<String>> onOptionsSelected;

  const CustomMultiSelector({
    super.key,
    required this.title,
    required this.options,
    required this.selectedOptions,
    required this.onOptionsSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return ChoiceChipOption(
              label: option,
              isSelected: isSelected,
              onSelected: (selected) {
                final newSelectedOptions = List<String>.from(selectedOptions);
                if (selected) {
                  if (!newSelectedOptions.contains(option)) {
                    newSelectedOptions.add(option);
                  }
                } else {
                  newSelectedOptions.remove(option);
                }
                onOptionsSelected(newSelectedOptions);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
