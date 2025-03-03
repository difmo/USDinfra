import 'package:flutter/material.dart';
import '../../../Customs/form_input_field.dart';

class ContactDetailsColumn extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const ContactDetailsColumn({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your contact details',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        FormTextField(
          hint: 'Phone number / E-mail',
          controller: controller,
          borderRadius: 25,
          minLength: 10,
          maxLength: 10,
          inputType: TextInputType.phone,
          validator: validator,
        ),
      ],
    );
  }
}
