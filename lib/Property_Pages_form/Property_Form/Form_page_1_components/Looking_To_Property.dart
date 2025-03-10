import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';

import '../../../Components/Choice_Chip.dart';
import '../../../Components/Error_message.dart';
// import '../../conigs/app_colors.dart';
// import 'error_message.dart';
// import 'choice_chip_option.dart';

class LookingToColumn extends StatelessWidget {
  final String? lookingTo;
  final ValueChanged<String?> onSelectLookingTo;
  final String? lookingToError;

  const LookingToColumn({
    super.key,
    required this.lookingTo,
    required this.onSelectLookingTo,
    this.lookingToError,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "You're looking to?",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
          fontFamily: AppFontFamily.primaryFont,
),
        ),
        const SizedBox(height: 10),
        Row(
          spacing: 10,
          children: ['Sell', 'Rent / Lease', 'Paying Guest']
              .map((option) => ChoiceChipOption(
            label: option,
            isSelected: lookingTo == option,
            labelStyle:TextStyle(fontFamily: AppFontFamily.primaryFont),
            onSelected: (selected) {
              onSelectLookingTo(selected ? option : null);
            },
          ))
              .toList(),
        ),
        ErrorMessage(errorText: lookingToError),
      ],
    );
  }
}
