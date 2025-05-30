import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../configs/app_colors.dart';
import 'contact_details.dart';

class PropertyCard extends StatefulWidget {
  final String imageUrl;
  final String expectedPrice;
  final String plotArea;
  final String propertyType;
  final String city;
  final String createdAt;
  final String title;
  final String propertyStatus;
  final String contactDetails;
  final bool showButtons;
  final String location;
  final String propertyCategory;
  final String totalPrice;
  const PropertyCard(
      {super.key,
      required this.imageUrl,
      required this.expectedPrice,
      required this.plotArea,
      required this.propertyType,
      required this.city,
      required this.createdAt,
      required this.title,
      required this.propertyStatus,
      required this.contactDetails,
      this.showButtons = true,
      this.location = '',
      this.propertyCategory = "",
      this.totalPrice = '0.0'});

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard> {
  bool isFavorited = false;

  void _toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  String getShortTitle(String title) {
    return title.length > 18 ? '${title.substring(0, 18)}...' : title;
  }

  void _callOwner() async {
    String phoneNumber =
        widget.contactDetails.trim(); // Remove spaces from the start and end
    phoneNumber =
        phoneNumber.replaceAll(' ', ''); // Remove all spaces inside the number

    final Uri phoneUri = Uri.parse("tel:$phoneNumber");
    print("Attempting to launch: $phoneUri"); // Debugging

    if (await canLaunchUrlString(phoneUri.toString())) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      print("canLaunchUrlString() returned false."); // Debugging
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: screenWidth * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.imageUrl,
                        height: screenWidth * 0.4,
                        width: screenWidth * 0.6,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: screenWidth * 0.3,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8)),
                          color: Colors.black54,
                        ),
                        child: Text(
                          'Updated ${widget.createdAt} ago',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: AppFontFamily.primaryFont,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),
                      Text(
                        "${getShortTitle(widget.title)}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      Text(
                        "${widget.propertyCategory} in ${widget.location}",
                        maxLines: 1,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        formatPrice(widget.totalPrice),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFontFamily.primaryFont,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  String formatPrice(dynamic value) {
    if (value == null) return "N/A";

    double price = 0.0;

    try {
      if (value is String) {
        // Remove commas before parsing
        value = value.replaceAll(",", "");
        price = double.parse(value);
      } else if (value is int || value is double) {
        price = value.toDouble();
      } else {
        return "N/A";
      }
    } catch (e) {
      return "N/A";
    }

    if (price >= 10000000) {
      return "₹${(price / 10000000).toStringAsFixed(2)} Cr";
    } else if (price >= 100000) {
      return "₹${(price / 100000).toStringAsFixed(2)} Lac";
    } else {
      return "₹${price.toStringAsFixed(0)}";
    }
  }
}
