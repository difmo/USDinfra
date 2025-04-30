import 'package:flutter/material.dart';
import 'package:usdinfra/Components/Choice_Chip.dart';
import 'package:usdinfra/configs/font_family.dart';

class OwnershipSelector extends StatelessWidget {
  final String title;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String> onOptionSelected;

  const OwnershipSelector({
    Key? key,
    required this.title,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            )),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          children: options.map((option) {
            return ChoiceChipOption(
              label: option,
              isSelected: selectedOption == option,
              onSelected: (selected) {
                if (selected) {
                  onOptionSelected(option);
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
