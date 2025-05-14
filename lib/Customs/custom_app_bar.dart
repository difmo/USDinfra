import 'package:flutter/material.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool showListPropertyButton;
  final bool showFreeBadge;
  final int notificationCount;

  const CustomAppBar({
    super.key,
    required this.scaffoldKey,
    this.showListPropertyButton = true,
    this.showFreeBadge = true,
    this.notificationCount = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenRatio = screenSize.width / screenSize.height;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: screenSize.height * 0.0055,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.secondry],
            ),
          ),
        ),
        Container(
          height: kToolbarHeight,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.0),
            child: Row(
              children: [
                IconButton(
                  icon: Image.asset(
                    'assets/icons/menu_icon.png',
                    height: screenSize.width * 0.07,
                  ),
                  onPressed: () => scaffoldKey.currentState?.openDrawer(),
                ),
                Text("USD ",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 247, 113, 3),
                      fontFamily: AppFontFamily.primaryFont,
                    )),
                Text("Unique",
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 27, 3, 247),
                      fontFamily: AppFontFamily.primaryFont,
                    )),
                Spacer(),
                const SizedBox(width: 32),
                Row(
                  children: [
                    if (showListPropertyButton)
                      Padding(
                        padding: EdgeInsets.only(left: screenSize.width * 0.02),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRouts.propertyform1);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.02,
                              vertical: screenSize.width * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.lightGrey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Post Property ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: AppFontFamily.primaryFont,
                                  ),
                                ),
                                Text(
                                  'FREE ',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    fontFamily: AppFontFamily.primaryFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRouts.notification);
                          },
                          icon: Icon(
                            Icons.notifications_none_outlined,
                            size: 28,
                            color: Colors.black,
                          ),
                        ),
                        if (notificationCount >= 0)
                          _buildNumericBadge(notificationCount, screenSize),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextBadge(String text, Size screenSize) {
    return Positioned(
      right: screenSize.width * -0.06,
      top: screenSize.width * 0.035,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.015,
            vertical: screenSize.width * 0.005),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.width * 0.02,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNumericBadge(int count, Size screenSize) {
    return Positioned(
      right: 8,
      top: 5,
      child: Container(
        width: 18,
        height: 18,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          count > 9 ? '9+' : '$count',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
