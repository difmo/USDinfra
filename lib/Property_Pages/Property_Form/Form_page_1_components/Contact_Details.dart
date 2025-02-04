import 'package:flutter/material.dart';
import '../../../Customs/custom_textfield.dart';

class ContactDetailsColumn extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? contactDetailsValidator; // Added validator

  const ContactDetailsColumn({
    Key? key,
    required this.controller,
    this.contactDetailsValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
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
          validator: contactDetailsValidator,
        ),
      ],
    );
  }
}
