import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final Icon? prefixIcon;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? errorMessage;
  final Function()? onTap;
  final bool enable;
  // final int ? maxlines;

  const CustomInputField({
    Key? key,
    required this.hintText,
    this.prefixIcon,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.errorMessage,
    this.onTap,
    this.enable = true,
   // this.maxlines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 1.0,
                  offset: Offset(0, 0.5),
                ),
              ],
            ),
            child: TextFormField(
              controller: controller,
              obscureText: obscureText,
              onChanged: onChanged,
              validator: validator,
              enabled: enable,
              // maxLines: maxlines,
              decoration: InputDecoration(
                prefixIcon: prefixIcon,
                hintText: hintText,
                border: InputBorder.none,
                suffixIcon: suffixIcon,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ),
        // Error message is displayed outside the text field
        if (errorMessage != null && errorMessage!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.bottomLeft, // Align the error message outside
              child: Text(
                errorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
