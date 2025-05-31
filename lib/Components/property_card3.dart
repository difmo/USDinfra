import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../configs/app_colors.dart';
import 'contact_details.dart';

class PropertyCard3 extends StatefulWidget {
  final List<String> imageUrl;
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
  final String floorPlan;

  const PropertyCard3({
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
    required this.floorPlan,
  });

  @override
  _PropertyCard3State createState() => _PropertyCard3State();
}

class _PropertyCard3State extends State<PropertyCard3> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  Timer? _timer;
  int _currentIndex = 0;
  late List<int> _durations;

  @override
  void initState() {
    super.initState();
    _durations = _generateRandomDurations(widget.imageUrl.length);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  List<int> _generateRandomDurations(int length) {
    final random = Random();
    return List.generate(
        length, (_) => 1 + random.nextInt(5)); // 1 to 5 seconds
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: _durations[_currentIndex]), () {
      if (!mounted) return;
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imageUrl.length;
      });
      _carouselController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _startAutoPlay(); // Recursive loop with the next duration
    });
  }

  void _callOwner() async {
    String phoneNumber = widget.contactDetails.trim().replaceAll(' ', '');
    final Uri phoneUri = Uri.parse("tel:$phoneNumber");

    if (await canLaunchUrlString(phoneUri.toString())) {
      await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch dialer')),
      );
    }
  }

  String getShortTitle(String title) {
    return title.length > 18 ? '${title.substring(0, 18)}...' : title;
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
                    SizedBox(
                      width: 246,
                      child: CarouselSlider(
                        carouselController: _carouselController,
                        options: CarouselOptions(
                          height: screenWidth * 0.4,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          viewportFraction: 1.0,
                          initialPage: 0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: widget.imageUrl.map((url) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: url,
                              height: screenWidth * 0.4,
                              width: screenWidth * 0.6,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
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
                            bottomRight: Radius.circular(8),
                          ),
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
                        getShortTitle(widget.title),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      Text(
                        widget.propertyCategory != "Plot/Land"
                            ? "${widget.propertyCategory} Flat in ${widget.location}"
                            : "${widget.propertyCategory} in ${widget.location}",
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
                          color: Colors.black,
                        ),
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
}
