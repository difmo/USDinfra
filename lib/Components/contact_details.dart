import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../conigs/app_colors.dart';

class ContactDetailDialog extends StatelessWidget {
  final String phoneNumber;

  const ContactDetailDialog({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), // Rounded corners
      elevation: 5,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title Text
            Text(
              "Contact Details",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 20),
            // Phone number section with a copy button
            Row(
              children: [
                Icon(Icons.phone, color: AppColors.primary),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    phoneNumber,
                    style: TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: AppColors.secondry),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: phoneNumber));
                    // Show a Snackbar to indicate the number was copied
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Phone number copied to clipboard!")),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Close Button
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 16
                  ,color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}