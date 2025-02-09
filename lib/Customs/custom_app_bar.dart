import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:usdinfra/routes/app_routes.dart';

import '../conigs/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  CustomAppBar({required this.scaffoldKey});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Define the height of the AppBar

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        backgroundColor: Colors.transparent, // Transparent background for gradient
        elevation: 0, // Remove shadow
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondry], // Custom gradient colors
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer(); // Open drawer
          },
        ),
        title: const Text(
          'USD',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24, // Larger font size
          ),
        ),
        actions: <Widget>[
          // List Our Property Button (New)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRouts.propertyform1); // Navigate to list our property screen
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white), // White border color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Border radius
                ),
                // padding: EdgeInsets.symmetric(horizontal: 20, vertical:0), // Optional padding
              ),
              child: Text(
                'List Your Property',
                style: TextStyle(
                  color: Colors.white, // Text color
                  fontWeight: FontWeight.bold,
                  fontSize: 11, // Adjust text size
                ),
              ),
            ),
          ),

          // Notifications Button

        ],
      ),
    );
  }
}
