import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';

class FormTextField extends StatefulWidget {
  final String hint;
  final String? Function(String?)? validator; // Make the validator optional
  final TextEditingController controller;
  final int? minLength; // Enforcing minLength
  final int? maxLength;
  final TextInputType inputType;
  final int maxLines;
  final double? borderRadius; // Optional border radius

  // Constructor to initialize parameters
  const FormTextField({
    Key? key,
    required this.hint,
    required this.controller,
    this.validator, // Optional validator
    this.minLength, // Make minLength required
    this.maxLength,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.borderRadius, // Accepting borderRadius as an optional parameter
  }) : super(key: key);

  @override
  _FormTextFieldState createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  String errorMessage = ''; // Error message to show validation errors

  @override
  Widget build(BuildContext context) {
    // Default border radius if none is provided
    double radius = widget.borderRadius ?? 10.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: widget.controller,
        maxLength: widget.maxLength, // Limits the maximum length
        keyboardType: widget.inputType,
        maxLines: widget.maxLines,
        style: TextStyle(
          fontFamily: AppFontFamily.primaryFont,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          errorText: errorMessage.isNotEmpty
              ? errorMessage
              : null, // Display error if any
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                radius), // Apply the optional border radius
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
                radius), // Apply the optional border radius
            borderSide: const BorderSide(color: Colors.black),
          ),
          filled: true,
          fillColor: Colors.white, // Set background color to white
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        onChanged: (value) {
          setState(() {
            // Apply validation on text change
            // If custom validator exists, use it, else fallback to default validation
            if (widget.validator != null) {
              // Use the custom validator if provided
              errorMessage = widget.validator!(value) ?? '';
            } else {
              // Default validation logic for min/max length
              if (value.length < widget.minLength!) {
                errorMessage =
                    'Minimum ${widget.minLength} characters required.';
              } else if (value.length > widget.maxLength!) {
                errorMessage =
                    'Maximum ${widget.maxLength} characters allowed.';
              } else {
                errorMessage = ''; // Clear error when valid
              }
            }
          });
        },
      ),
    );
  }
}
