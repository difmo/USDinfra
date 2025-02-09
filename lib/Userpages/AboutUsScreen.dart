import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/conigs/app_colors.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "About USD Unique"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            _companyDescription(),
            _missionVisionSection(),
            _coreValuesSection(),
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
          "https://images.pexels.com/photos/93400/pexels-photo-93400.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
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
            "USD Unique - Building the Future",
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

  Widget _companyDescription() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            "Who We Are",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "USD Unique is a leading construction company specializing in modern, sustainable, and high-quality infrastructure projects. With years of expertise, we deliver top-notch residential, commercial, and industrial projects that redefine excellence.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }

  Widget _missionVisionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondry],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        children: [
          const Text(
            "Our Mission",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "To construct sustainable, innovative, and high-quality infrastructure that enhances communities and businesses.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 20),
          const Text(
            "Our Vision",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "To be the most trusted and preferred construction partner, delivering excellence and innovation in every project.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _coreValuesSection() {
    final List<Map<String, dynamic>> coreValues = [
      {
        "icon": Icons.verified,
        "title": "Quality",
        "desc":
            "Delivering excellence with high-quality materials & craftsmanship."
      },
      {
        "icon": Icons.lightbulb_outline,
        "title": "Innovation",
        "desc":
            "Adopting modern solutions for smarter, sustainable infrastructure."
      },
      {
        "icon": Icons.handshake,
        "title": "Integrity",
        "desc":
            "Building trust through transparency and ethical business practices."
      },
      {
        "icon": Icons.groups,
        "title": "Customer Focus",
        "desc": "Ensuring customer satisfaction through tailor-made solutions."
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Our Core Values",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Column(
            children: coreValues.map((value) {
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.2),
                    child: Icon(value['icon'], color: AppColors.primary),
                  ),
                  title: Text(
                    value['title'],
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(value['desc']),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _contactUsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            "Get in Touch",
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
                  leading: const Icon(Icons.phone, color: Colors.blue),
                  title: const Text("+91 98765 43210"),
                  subtitle: const Text("Call us for inquiries"),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.red),
                  title: const Text("info@usdunique.com"),
                  subtitle: const Text("Email us for more details"),
                ),
                ListTile(
                  leading: const Icon(Icons.location_on, color: Colors.green),
                  title: const Text("USD Unique, Delhi, India"),
                  subtitle: const Text("Visit our corporate office"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
