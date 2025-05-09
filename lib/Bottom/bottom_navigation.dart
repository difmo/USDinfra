import 'package:flutter/material.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 8,
      ), // Added padding
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: AppFontFamily.primaryFont,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: AppFontFamily.primaryFont,
          fontSize: 12,
        ),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Buy',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          // BottomNavigationBarItem(
          //   icon: Container(
          //     padding: const EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: AppColors.primary,
          //       shape: BoxShape.circle,
          //       boxShadow: [
          //         BoxShadow(
          //           color: AppColors.primary.withOpacity(0.5),
          //           blurRadius: 8,
          //           spreadRadius: 2,
          //         ),
          //       ],
          //     ),
          //     child: const Icon(Icons.add, color: Colors.white, size: 32),
          //   ),
          //   label: '',
          // ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.offline_bolt_rounded),
            label: 'Plan',
          ),

          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
