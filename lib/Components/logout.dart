import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/route_manager.dart';
import 'package:usdinfra/authentication/login_with_mob.dart';
import 'package:usdinfra/configs/font_family.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Log Out",
        style: TextStyle(
          fontFamily: AppFontFamily.primaryFont,
        ),
      ),
      content: Text(
        "Are you sure you want to log out?",
        style: TextStyle(
          fontFamily: AppFontFamily.primaryFont,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Cancel",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Get.to(LoginWithMob());
          },
          child: Text(
            "Log Out",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
        ),
      ],
    );
  }
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (ctx) => const LogoutDialog(),
  );
}
