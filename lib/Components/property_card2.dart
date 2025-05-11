import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../configs/app_colors.dart';

class PropertyCard2 extends StatefulWidget {
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

  const PropertyCard2({
    super.key,
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
    this.totalPrice = '0.0',
  });

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard2> {
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
    String phoneNumber = widget.contactDetails.trim();
    phoneNumber = phoneNumber.replaceAll(' ', '');

    final Uri phoneUri = Uri.parse("tel:$phoneNumber");

    if (await canLaunchUrlString(phoneUri.toString())) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: Image.network(
              widget.imageUrl,
              height: screenWidth * 0.4,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getShortTitle(widget.title),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.propertyCategory} in ${widget.location}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  formatPrice(widget.totalPrice),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.primaryFont,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Updated ${widget.createdAt} ago',
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: _toggleFavorite,
                    //   icon: Icon(
                    //     isFavorited ? Icons.favorite : Icons.favorite_border,
                    //     color: isFavorited ? Colors.red : Colors.grey,
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatPrice(dynamic value) {
    if (value == null) return "N/A";
    double price = 0.0;

    try {
      if (value is String) {
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
