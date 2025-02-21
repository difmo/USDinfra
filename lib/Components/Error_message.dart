import 'package:flutter/material.dart';
import '../../conigs/app_colors.dart';

class ErrorMessage extends StatelessWidget {
  final String? errorText;
  const ErrorMessage({super.key, this.errorText});

  @override
  Widget build(BuildContext context) {
    if (errorText == null) {
      return SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Text(
        errorText!,
        style: TextStyle(color: AppColors.primary, fontSize: 12),
      ),
    );
  }
}
