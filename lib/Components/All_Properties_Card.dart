import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';

// import 'package:usdinfra/conigs/app_colors.dart';

class AllPropertyCard extends StatelessWidget {
  final String imageUrl;
  final String price;
  final String propertyType;
  final String address;
  final String title;

  // final String ownership;
  

  const AllPropertyCard({
    super.key,
    required this.imageUrl,
    required this.price,
    required this.propertyType,
    required this.address,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    // height: screenWidth * 0.3,  // Adjust image size
                    width: screenWidth * 0.3,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        propertyType,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        address,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      // Optionally add more information here
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.arrow_forward_ios))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
