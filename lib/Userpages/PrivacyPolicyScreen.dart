import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/conigs/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Privacy Policy"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            _policySection("1. Introduction",
                "USD Unique is committed to protecting your privacy. This Privacy Policy outlines how we collect, use, and safeguard your personal information."),
            _policySection("2. Information We Collect",
                "We collect information such as your name, email, phone number, and address when you register or use our services. We may also collect location data and usage analytics."),
            _policySection("3. How We Use Your Information",
                "We use your information to provide and improve our services, process transactions, send important notifications, and ensure security compliance."),
            _policySection("4. Data Security",
                "USD Unique follows strict security measures to protect your data from unauthorized access, alteration, disclosure, or destruction."),
            _policySection("5. Third-Party Sharing",
                "We do not sell or share your personal data with third parties, except where required by law or to provide essential services (e.g., payment processing)."),
            _policySection("6. Cookies and Tracking Technologies",
                "Our platform may use cookies and analytics tools to improve user experience. You can control these settings through your browser."),
            _policySection("7. Your Rights",
                "You have the right to access, update, or delete your personal data. Contact us at privacy@usdunique.com for any requests."),
            _policySection("8. Changes to this Policy",
                "We may update this Privacy Policy from time to time. Any changes will be posted here with a revised effective date."),
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
          "https://images.pexels.com/photos/430208/pexels-photo-430208.jpeg",
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
            "USD Unique - Privacy Policy",
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

  Widget _policySection(String title, String content) {
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
                  title: const Text("privacy@usdunique.com"),
                  subtitle: const Text("For privacy-related inquiries"),
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
