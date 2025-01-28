import 'package:flutter/material.dart';

import '../../../Components/Choice_Chip.dart';
import '../../../Components/Error_message.dart';

class PropertyTypeColumn extends StatelessWidget {
  final String? propertyType;
  final ValueChanged<String?> onSelectPropertyType;
  final List<String> propertyTypes;
  final String? propertyTypeError;

  const PropertyTypeColumn({
    Key? key,
    required this.propertyType,
    required this.onSelectPropertyType,
    required this.propertyTypes,
    this.propertyTypeError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What kind of property?',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: propertyTypes
              .map((option) => ChoiceChipOption(
            label: option,
            isSelected: propertyType == option,
            onSelected: (selected) {
              onSelectPropertyType(selected ? option : null);
            },
          ))
              .toList(),
        ),
        ErrorMessage(errorText: propertyTypeError),
      ],
    );
  }
}
