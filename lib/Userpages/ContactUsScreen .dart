import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/conigs/app_colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

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
            _contactForm(),
            _mapSection(),
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
          child: const Text(
            "Get in Touch with USD Unique",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
        "title": "+91 98765 43210",
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
          const Text(
            "Contact Details",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['subtitle']),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _contactForm() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController messageController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Send Us a Message",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _customTextField("Full Name", nameController),
          _customTextField("Email Address", emailController),
          _customTextField("Your Message", messageController, maxLines: 5),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add send message function
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            ),
            child: const Text(
              "Send Message",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customTextField(String hint, TextEditingController controller,
      {int maxLines = 1}) {
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

  Widget _mapSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Our Location",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              "https://images.pexels.com/photos/7738879/pexels-photo-7738879.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
