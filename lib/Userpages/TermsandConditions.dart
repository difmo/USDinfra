import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/conigs/app_colors.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Terms & Conditions"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            _termsSection("1. Introduction",
                "Welcome to USD Unique. By accessing our services, you agree to abide by these terms and conditions."),
            _termsSection("2. Use of Services",
                "USD Unique provides construction and real estate services. You agree to use our platform lawfully and ethically."),
            _termsSection("3. User Responsibilities",
                "Users must provide accurate information and comply with all applicable laws while using our services."),
            _termsSection("4. Payment Terms",
                "All transactions are securely processed. Users are responsible for payments related to services rendered."),
            _termsSection("5. Intellectual Property",
                "All content, including logos and designs, are the property of USD Unique. Unauthorized use is prohibited."),
            _termsSection("6. Limitation of Liability",
                "USD Unique is not liable for any indirect damages resulting from the use of our services."),
            _termsSection("7. Termination of Services",
                "We reserve the right to terminate access if users violate these terms."),
            _termsSection("8. Changes to Terms",
                "USD Unique may update these terms at any time. Continued use of our services implies acceptance of the updated terms."),
            _contactUsSection(),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Stack(
      children: [
        Image.network(
          "https://images.pexels.com/photos/7841415/pexels-photo-7841415.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
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
            "USD Unique - Terms & Conditions",
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

  Widget _termsSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _contactUsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text(
            "Contact Us",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.red),
                  title: const Text("support@usdunique.com"),
                  subtitle: const Text("For terms-related inquiries"),
                ),
                ListTile(
                  leading: const Icon(Icons.phone, color: Colors.blue),
                  title: const Text("+91 98765 43210"),
                  subtitle: const Text("Call us for further assistance"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
