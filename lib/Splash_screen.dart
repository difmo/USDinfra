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
    Timer(const Duration(seconds: 2), () async {
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
            Navigator.pushNamedAndRemoveUntil(
                context, AppRouts.adminProperty, (route) => false);
          } else if (role == "isUser") {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRouts.dashBoard, (route) => false);
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRouts.dashBoard, (route) => false);
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRouts.dashBoard, (route) => false);
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
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
                fontFamily: GoogleFonts.inter().fontFamily,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Where You Find Your Dream Home.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.indigo,
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
