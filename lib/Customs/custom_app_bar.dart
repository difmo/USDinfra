import 'package:flutter/material.dart';
import 'package:usdinfra/conigs/app_colors.dart';
import 'package:usdinfra/routes/app_routes.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  // final String title;
  final bool showListPropertyButton;

  const CustomAppBar({
    super.key,
    required this.scaffoldKey,
    // this.title = 'USD',
    this.showListPropertyButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 49,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
               begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.secondry,
              ])
              ),
        ),
        Container(
          height: kToolbarHeight,
          color: Colors.white, // App bar color
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              ),
              // Text(
              //   title,
              //   style: const TextStyle(
              //     color: Colors.black,
              //     fontWeight: FontWeight.bold,
              //     fontSize: 24,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: showListPropertyButton
                    ? OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRouts.propertyform1);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.black),
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'List Your Property',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 48),
              ), // Placeholder to maintain spacing
            ],
          ),
        ),
      ],
    );
  }
}
