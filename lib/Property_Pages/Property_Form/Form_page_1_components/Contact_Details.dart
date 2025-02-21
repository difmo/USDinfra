import 'package:flutter/material.dart';
import '../../../Customs/custom_textfield.dart';
// import '../../Controllers/authentication_controller.dart';

class ContactDetailsColumn extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator1;

  const ContactDetailsColumn({
    super.key,
    required this.controller,
    this.validator1,
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
        CustomInputField(
          hintText: 'Phone number / E-mail',
          controller: controller,
        ),
      ],
    );
  }
}
