import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

import '../Controllers/authentication_controller.dart';

class ContactUsScreen extends StatelessWidget {
  ContactUsScreen({super.key});

  final controllers = ControllersManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Contact Us"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            _contactDetails(),
            _contactForm(context),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Stack(
      children: [
        Image.network(
          "https://images.pexels.com/photos/176342/pexels-photo-176342.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
          height: 200,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.black.withOpacity(0.5),
          alignment: Alignment.center,
          child: Text(
            "Get in Touch with USD Unique",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactDetails() {
    final List<Map<String, dynamic>> contactItems = [
      {
        "icon": Icons.phone,
        "title": "+91 800 427 5740",
        "subtitle": "Call us for inquiries",
        "color": Colors.blue,
      },
      {
        "icon": Icons.email,
        "title": "info@usdunique.com",
        "subtitle": "Email us for more details",
        "color": Colors.red,
      },
      {
        "icon": Icons.location_on,
        "title": "USD Unique, Delhi, India",
        "subtitle": "Visit our corporate office",
        "color": Colors.green,
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Contact Details",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          const SizedBox(height: 10),
          Column(
            children: contactItems.map((item) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: item['color'].withOpacity(0.2),
                    child: Icon(item['icon'], color: item['color']),
                  ),
                  title: Text(item['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFontFamily.primaryFont,
                      )),
                  subtitle: Text(
                    item['subtitle'],
                    style: TextStyle(
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _contactForm(context) {
    void sendMessage(
      BuildContext context,
      String name,
      String email,
      String mobile,
      String message,
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController mobileController,
      TextEditingController messageController,
    ) async {
      if (name.isEmpty || email.isEmpty || mobile.isEmpty || message.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            "All fields are required!",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          )),
        );
        return;
      }
      try {
        await FirebaseFirestore.instance.collection("AppContacts").add({
          'serviceName': "Contact Us",
          'name': name,
          'email': email,
          'mobile': mobile,
          'message': message,
          'timestamp': FieldValue.serverTimestamp(),
        });
        nameController.clear();
        emailController.clear();
        mobileController.clear();
        messageController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            "Message sent successfully!",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          )),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            "Error: $e",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          )),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            "Send Us a Message",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          const SizedBox(height: 10),
          _customTextField("Full Name", controllers.nameController,
              inputType: TextInputType.text),
          _customTextField("Email Address", controllers.emailController,
              inputType: TextInputType.emailAddress),
          _customTextField("Mobile Number", controllers.mobileController,
              inputType: TextInputType.phone),
          _customTextField("Your Message", controllers.messageController,
              maxLines: 5, inputType: TextInputType.text),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              sendMessage(
                context,
                controllers.nameController.text,
                controllers.emailController.text,
                controllers.mobileController.text,
                controllers.messageController.text,
                controllers.nameController,
                controllers.emailController,
                controllers.mobileController,
                controllers.messageController,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            child: Text(
              "Send Message",
              style: TextStyle(
                color: AppColors.white,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customTextField(
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
