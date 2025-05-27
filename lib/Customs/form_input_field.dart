import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';

class FormTextField extends StatefulWidget {
  final String hint;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final int? minLength;
  final int? maxLength;
  final TextInputType inputType;
  final int maxLines;
  final double? borderRadius;
  final bool isEditable; // ✅ New parameter

  const FormTextField({
    super.key,
    required this.hint,
    this.controller,
    this.validator,
    this.minLength,
    this.maxLength,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.borderRadius,
    this.isEditable = true, // ✅ Default editable
  });

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    double radius = widget.borderRadius ?? 10.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: widget.controller,
        maxLength: widget.maxLength,
        keyboardType: widget.inputType,
        maxLines: widget.maxLines,
        readOnly: !widget.isEditable, // ✅ Make it non-editable if needed
        style: TextStyle(
          fontFamily: AppFontFamily.primaryFont,
          color: widget.isEditable
              ? Colors.black
              : Colors.grey[600], // optional color change
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: errorMessage.isNotEmpty ? errorMessage : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(color: Colors.black),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        onChanged: (value) {
          if (!widget.isEditable) return; // ✅ Prevent validation if read-only

          setState(() {
            if (widget.validator != null) {
              errorMessage = widget.validator!(value) ?? '';
            } else {
              if (widget.minLength != null &&
                  value.length < widget.minLength!) {
                errorMessage =
                    'Minimum ${widget.minLength} characters required.';
              } else if (widget.maxLength != null &&
                  value.length > widget.maxLength!) {
                errorMessage =
                    'Maximum ${widget.maxLength} characters allowed.';
              } else {
                errorMessage = '';
              }
            }
          });
        },
      ),
    );
  }
}
