import 'package:flutter/material.dart';

class PropertyForm3 extends StatelessWidget {
  final Map<String, dynamic> formData;

  const PropertyForm3({super.key, required this.formData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Property Form 2"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Looking To: ${formData['lookingTo']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Property Type: ${formData['propertyType']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Property Category: ${formData['propertyCategory']}", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text("Contact Details: ${formData['contactDetails']}", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
