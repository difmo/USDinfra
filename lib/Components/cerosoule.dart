import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';

class Carousel extends StatefulWidget {
  const Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  final List<String> imageUrls = [
    'https://www.indiafilings.com/learn/wp-content/uploads/2015/10/Real-Estate-Agent-Business-India.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.02,
        vertical: screenHeight * 0.01,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Responsive Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/first.jpeg',
              fit: BoxFit.cover,
              height: 400,
              width: double.infinity,
            ),
          ),

          // Search Bar (Positioned at bottom center of the image, adaptive to all screens)
          Positioned(
            bottom: -screenHeight * 0.03,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, AppRouts.Search);
              },
              child: Container(
                width: screenWidth * 0.92, // Set relative to screen width
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.015,
                  horizontal: screenWidth * 0.04,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.search,
                        color: Colors.grey, size: screenWidth * 0.06),
                    SizedBox(width: screenWidth * 0.02),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: screenWidth * 0.04,
                        fontFamily: AppFontFamily.primaryFont,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
