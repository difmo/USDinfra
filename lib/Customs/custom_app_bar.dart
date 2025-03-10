import 'package:flutter/material.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showListPropertyButton;

  const CustomAppBar({
    super.key,
    required this.scaffoldKey,
    this.showListPropertyButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Colored gradient bar at the top
        Container(
          height: kToolbarHeight * 0.85,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondry],
            ),
          ),
        ),
        // Main app bar
        Container(
          height: kToolbarHeight,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.001),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu Button
              IconButton(
                icon: Image.asset(
                  'assets/icons/menu_icon.png',
                  height: screenWidth * 0.08,
                ),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              ),
              Row(
                children: [
                  if (showListPropertyButton)
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.02),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouts.propertyform1);
                        },
                        child: Text(
                          'Post Property',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
                            fontFamily: AppFontFamily.primaryFont,
                          ),
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouts.notification);
                    },
                    icon: Icon(
                      Icons.notifications_none_outlined,
                      size: screenWidth * 0.07, // Responsive icon size
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
