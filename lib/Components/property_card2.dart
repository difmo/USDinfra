import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usdinfra/Property_Pages_form/Properties_detail_page.dart';
import 'package:usdinfra/configs/app_text_style.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/utils/constants.dart';
import 'package:usdinfra/utils/formatters.dart';

class PropertyCard2 extends StatefulWidget {
  final String docId;
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
  final int autoPlayInterval;

  const PropertyCard2({
    super.key,
    required this.docId,
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
    this.autoPlayInterval = 3000,
  });

  @override
  _PropertyCardState createState() => _PropertyCardState();
}

class _PropertyCardState extends State<PropertyCard2> {
  bool isFavorited = false;
  Formatters formatters = Formatters();
  AppConstants appConstants = AppConstants();

  String getShortTitle(String title) {
    return title.length > 18 ? '${title.substring(0, 18)}...' : title;
  }

  void _navigateToDetailPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PropertyDetailPage(docId: widget.docId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => _navigateToDetailPage(
          context), // Single GestureDetector for navigation
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: screenWidth * 0.4,
                autoPlay: true,
                enlargeCenterPage: true,
                autoPlayInterval:
                    Duration(milliseconds: widget.autoPlayInterval),
                enableInfiniteScroll: true,
                viewportFraction: 1.0,
              ),
              items: widget.imageUrl.map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    height: screenWidth * 0.4,
                    width: screenWidth * 0.88,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        "${widget.propertyCategory} in ${widget.location}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formatters.formatPrice(widget.totalPrice),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFontFamily.primaryFont,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${widget.plotArea} SQ FT.  ${widget.propertyCategory}",
                            style: AppTextStyle.Text14500,
                          ),
                        ],
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
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  if (widget.showButtons) // Conditionally show buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final whatsappUrl =
                                  'https://wa.me/${widget.contactDetails}';
                              launchUrl(Uri.parse(whatsappUrl));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.green,
                              ),
                              child: SvgPicture.asset(
                                "assets/svg/whatsapp.svg",
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              final phoneUrl = 'tel:${widget.contactDetails}';
                              launchUrl(Uri.parse(phoneUrl));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.black,
                              ),
                              child: const Icon(
                                Icons.call,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
