import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';

class CustomInputField extends StatefulWidget {
  final String? hintText;
  final Icon? prefixIcon;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? errorMessage;
  final Function()? onTap;
  final bool enable;
  final int maxLines;
  final int? minLength;
  final int? maxLength;
  final double? borderRadius;
  final TextInputType inputType;
  final Color? prefixIconEnabledColor;
  final Color? prefixIconDisabledColor;
  final Color? disabledBorderColor;

  const CustomInputField({
    super.key,
    this.hintText,
    this.prefixIcon,
    required this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.errorMessage,
    this.onTap,
    this.maxLines = 1,
    this.minLength,
    this.maxLength,
    this.enable = true,
    this.borderRadius,
    this.inputType = TextInputType.text,
    this.prefixIconEnabledColor,
    this.prefixIconDisabledColor,
    this.disabledBorderColor,
  });

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  String? _currentErrorMessage;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double radius = widget.borderRadius ?? 8.0;
    bool isFieldEmpty = widget.controller.text.isEmpty;

    // Validation logic
    if (widget.minLength != null &&
        widget.controller.text.length < widget.minLength!) {
      _currentErrorMessage = 'Minimum ${widget.minLength} characters required.';
    } else if (widget.maxLength != null &&
        widget.controller.text.length > widget.maxLength!) {
      _currentErrorMessage = 'Maximum ${widget.maxLength} characters allowed.';
    } else {
      _currentErrorMessage = null;
    }

    // Border color logic
    Color borderColor = widget.enable
        ? (widget.errorMessage != null && widget.errorMessage!.isNotEmpty
            ? Colors.red
            : isFieldEmpty
                ? (_isFocused ? Colors.black : Colors.grey)
                : Colors.grey)
        : Colors.grey.withOpacity(0.5);
    Color disabledBorderColor =
        widget.disabledBorderColor ?? Colors.grey.withOpacity(0.5);

    // Prefix Icon Color logic
    Color prefixIconColor = widget.enable
        ? (widget.prefixIconEnabledColor ?? Colors.black)
        : (widget.prefixIconDisabledColor ?? Colors.grey);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            validator: widget.validator,
            maxLength: widget.maxLength,
            enabled: widget.enable,
            focusNode: _focusNode,
            keyboardType: widget.inputType,
            style: TextStyle(
              color: Colors.black87,
              fontFamily: AppFontFamily.primaryFont,
            ),
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon!.icon,
                      color: prefixIconColor,
                    )
                  : null,
              hintText: widget.hintText,
              border: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(radius),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF133763), width: 1.0),
                borderRadius: BorderRadius.circular(radius),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.0),
                borderRadius: BorderRadius.circular(radius),
              ),
               disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: disabledBorderColor, width: 1.0),
                borderRadius: BorderRadius.circular(radius),
              ),
              suffixIcon: widget.suffixIcon,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onChanged: (value) {
              setState(() {
                if (widget.minLength != null &&
                    value.length < widget.minLength!) {
                  _currentErrorMessage =
                      'Minimum ${widget.minLength} characters required.';
                } else if (widget.maxLength != null &&
                    value.length > widget.maxLength!) {
                  _currentErrorMessage =
                      'Maximum ${widget.maxLength} characters allowed.';
                } else {
                  _currentErrorMessage = null;
                }
              });
              widget.onChanged?.call(value);
            },
          ),
        ),
        if (_currentErrorMessage != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                _currentErrorMessage!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }
}
