import 'package:flutter/material.dart';
import 'package:usdinfra/conigs/app_colors.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? profileImageUrl;
  final int index; // Determines if back button is shown
  final VoidCallback? onProfileTap;

  const AdminAppBar({
    super.key,
    required this.title,
    this.profileImageUrl,
    required this.index,
    this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.secondry], // Gradient colors
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading:
              index > 0, // 🔥 Hide back button when index == 0
          leading: index > 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : null, // No leading widget when index == 0
          title: Align(
            alignment: Alignment.centerLeft, // 🔥 Title aligned to left
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: onProfileTap ?? () {},
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                    'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-person-icon.png',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
