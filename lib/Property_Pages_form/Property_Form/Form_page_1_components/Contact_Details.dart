import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../../../Customs/form_input_field.dart';

class ContactDetailsColumn extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  const ContactDetailsColumn({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  State<ContactDetailsColumn> createState() => _ContactDetailsColumnState();
}

class _ContactDetailsColumnState extends State<ContactDetailsColumn> {
  @override
  void initState() {
    super.initState();
    fetchUserPhoneNumber();
  }

  Future<void> fetchUserPhoneNumber() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc = await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final phone = userDoc['mobile']; // or 'phone' depending on your schema
        if (phone != null && phone is String) {
          widget.controller.text = phone;
        }
      }
    } catch (e) {
      print('Error fetching user phone: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your contact details',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        const SizedBox(height: 10),
        FormTextField(
          hint: 'Phone number / E-mail',
          controller: widget.controller,
          borderRadius: 25,
          minLength: 10,
          maxLength: 10,
          inputType: TextInputType.phone,
          validator: widget.validator,
          isEditable: true,
        ),
      ],
    );
  }
}
