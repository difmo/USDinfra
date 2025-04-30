import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
  super.initState();
  Timer(const Duration(seconds: 3), () async {
    User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        String role = userDoc['role'];
        if (role == "isAdmin") {
          Navigator.pushReplacementNamed(context, AppRouts.adminProperty);
        } else if (role == "isUser") {
          Navigator.pushReplacementNamed(context, AppRouts.dashBoard);
        }
      } else {
        Navigator.pushReplacementNamed(context, AppRouts.dashBoard);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRouts.dashBoard);
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/animations/logo.png",
              //  width: 250, height: 250
            ),
            // const SizedBox(height: 20),
            Text(
              "USD Unique",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
            const SizedBox(height: 10),
             Text(
              "Your Gateway to Unique Properties & Builders.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
