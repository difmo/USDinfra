import 'package:flutter/material.dart';
import 'package:usdinfra/conigs/app_colors.dart';

import 'admin_dashboard.dart';
import 'approved_property.dart';
import 'enquaries.dart';

class AdminBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AdminBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8,
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
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.approval_outlined),
            label: 'Approved',
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
          // const BottomNavigationBarItem(
          //   icon: Icon(Icons.workspace_premium),
          //   label: 'Upgrade',
          // ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Enquery',
          ),
        ],
      ),
    );
  }
}
