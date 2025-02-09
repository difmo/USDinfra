import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../conigs/app_colors.dart';
import 'contact_details.dart';

class PropertyCard extends StatefulWidget {
  final String imageUrl;
  final String expectedPrice;
  final String plotArea;
  final String propertyType;
  final String address;
  final String updateTime;
  final String title;
  final List<String> features;
  final String propertyStatus;
  final contactDetails;

  const PropertyCard({
    Key? key,
    required this.imageUrl,
    required this.expectedPrice,
    required this.plotArea,
    required this.propertyType,
    required this.address,
    required this.updateTime,
    required this.title,
    required this.features,
    required this.propertyStatus,
    required this.contactDetails,
  }) : super(key: key);

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

  void _shareOnWhatsApp() async {
    final String shareMessage = '''
Property: ${widget.title}
Price: ${widget.expectedPrice}
Size: ${widget.plotArea}
Type: ${widget.propertyType}
Address: ${widget.address}
Status: ${widget.propertyStatus}
Features: ${widget.features.join(', ')}
''';

    final String url =
        'https://wa.me/?text=${Uri.encodeComponent(shareMessage)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'POPULAR PROJECT',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Text(
                          'NEWLY LAUNCHED',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // IconButton(
                      //   icon: Image.asset(
                      //     'assets/icons/share.png',
                      //     width: 30,
                      //     height: 30,
                      //   ),
                      //   onPressed: _shareOnWhatsApp,
                      // ),
                      IconButton(
                        icon: Icon(
                          isFavorited
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: isFavorited ? Colors.red : Colors.black,
                          size: 24,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                ],
              ),
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
                          child: Text(
                            'Updated ${widget.updateTime} ago',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 11),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8)),
                            color: Colors.black54,
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${widget.plotArea} - ${widget.propertyType}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.check_circle,
                                color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Text(widget.propertyStatus),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widget.features
                    .map(
                      (feature) => Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text(feature),
                        ],
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
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
                        side: MaterialStateProperty.all(
                            BorderSide(color: AppColors.primary, width: 2)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ))),
                    child: const Text('Get Phone No.',
                        style: TextStyle(color: AppColors.primary)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
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
                    child: const Text(
                      'Contact Owner',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
