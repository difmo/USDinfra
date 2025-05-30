import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/configs/font_family.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Notification"),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.settings, color: Colors.black),
      //       onPressed: () {
      //         // Handle settings action
      //       },
      //     ),
      //   ],
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(
                'assets/icons/notification_bell.png',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "You do not have any notification yet",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
