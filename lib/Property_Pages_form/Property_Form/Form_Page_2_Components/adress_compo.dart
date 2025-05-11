import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/form_input_field.dart';
import 'package:usdinfra/configs/font_family.dart';

class LabeledFormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final double borderRadius;

  const LabeledFormField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.borderRadius = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: AppFontFamily.primaryFont,
              )),
          const SizedBox(height: 8),
          FormTextField(
            controller: controller,
            hint: hint,
            borderRadius: borderRadius,
          ),
        ],
      ),
    );
  }
}
