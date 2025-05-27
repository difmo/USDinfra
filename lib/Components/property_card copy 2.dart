import 'package:flutter/cupertino.dart';
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

  const PropertyCard({
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
  });

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
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(12),
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
                        height: screenWidth * 0.3,
                        width: screenWidth * 0.3,
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
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.expectedPrice,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFontFamily.primaryFont,
                            color: Colors.black),
                      ),
                      Text(
                        '${widget.plotArea} - ${widget.propertyType}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        getShortTitle(widget.title),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      Text(
                        widget.city,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            widget.propertyStatus,
                            style: TextStyle(
                              fontFamily: AppFontFamily.primaryFont,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.showButtons)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ContactDetailDialog(
                            phoneNumber: widget.contactDetails,
                          );
                        },
                      )
                    },
                    style: ButtonStyle(
                        side: WidgetStateProperty.all(
                            BorderSide(color: AppColors.primary, width: 2)),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))),
                    child: Text('Get Phone No.',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontFamily: AppFontFamily.primaryFont,
                        )),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: _callOwner, // Calls the owner directly
                    child: Text(
                      'Contact Owner',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFontFamily.primaryFont,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
