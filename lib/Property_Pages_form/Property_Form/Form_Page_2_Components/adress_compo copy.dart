import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/form_input_field.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class LabeledFormField2 extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final double borderRadius;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const LabeledFormField2({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.borderRadius = 25.0,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          FormTextField(
            controller: controller,
            hint: hint,
            borderRadius: borderRadius,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
