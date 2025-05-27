import 'package:flutter/material.dart';

class PopularBuilders extends StatelessWidget {
  const PopularBuilders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165, // Full width
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://www.axiomlandbase.in/wp-content/uploads/2019/06/signature-global.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Heading
          const Text(
            'Skyline Builders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          // Subheading
          const Text(
            'Delivering quality homes since 1990. Over 200+ projects across India.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
