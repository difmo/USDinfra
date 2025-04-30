import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class PropertyDetailPage extends StatefulWidget {
  final String docId;
  const PropertyDetailPage({super.key, required this.docId});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;
  bool hasError = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
  }

  Future<void> fetchPropertyDetails() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('AppProperties')
          .doc(widget.docId)
          .get();

      if (snapshot.exists) {
        setState(() {
          propertyData = snapshot.data() as Map<String, dynamic>;
          isLoading = false;
          print("Property data: $propertyData");
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (hasError || propertyData == null) {
      return const Scaffold(body: Center(child: Text("Property not found")));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Property Detail"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(),
            const SizedBox(height: 16),
            // _propertyInfoHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${propertyData?['title'] ?? 'N/A'}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "${propertyData?['propertyType'] ?? 'N/A'} ${propertyData?['propertyCategory'] ?? 'N/A'} ${propertyData?['lookingTo'] ?? 'N/A'}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),


                  /// there icon for property type and second icon for rupeess

                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.house,
                                  color: Colors.blue, size: 20),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${propertyData?['plotArea'] ?? 'N/A'} sqft",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Super Area",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 25),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.currency_rupee,
                                  color: Colors.orange, size: 20),
                            ),
                            Text(
                              "${propertyData?['expectedPrice'] ?? 'N/A'} Price",
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              "per sq.ft.",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  
                  // _sectionCard("", [
                  //   _infoRow(
                  //       "Property For", propertyData?['lookingTo'] ?? 'N/A'),
                  //   _infoRow("Property Type",
                  //       propertyData?['propertyType'] ?? 'N/A'),
                  //   _infoRow("Property Category",
                  //       propertyData?['propertyCategory'] ?? 'N/A'),
                  //   _infoRow(
                  //       "Status", propertyData?['availabilityStatus'] ?? 'N/A',
                  //       highlight: true),
                  // ]),
                  // const SizedBox(height: 16),

                  _sectionCard("Approval Details", [
                    _infoRow("Loan Availability",
                        propertyData?['loanAvailable'] ?? 'N/A'),
                    _infoRow("Govt. Approval",
                        propertyData?['propertyApproved'] ?? 'N/A'),
                    _infoRow("Rera", propertyData?['reraApproved'] ?? 'N/A'),
                    if ((propertyData?['reraApproved'] ?? '')
                            .toString()
                            .toLowerCase() ==
                        'yes')
                      _infoRow(
                          "Rera Number", propertyData?['reraNumber'] ?? 'N/A',
                          highlight: true),
                  ]),
                  _addressSection(),
                  _multiAmenitiesSection("Available Amenities", {
                    "Amenities":
                        List<String>.from(propertyData?['amenities'] ?? []),
                    "Food Court":
                        List<String>.from(propertyData?['foodcourt'] ?? []),
                  }),
                  _multiAmenitiesSection("Facing and Furnishing", {
                    "Facing": List<String>.from(propertyData?['facing'] ?? []),
                    "Furnishing":
                        List<String>.from(propertyData?['furnishing'] ?? []),
                  }),

                  const Text("Description",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(
                    propertyData?['description'] ?? "No description available.",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  _sectionCard("Owner Info", [
                    _infoRow("Ownership Type",
                        propertyData?['ownershipType'] ?? 'N/A'),
                    _infoRow("Owner", propertyData?['ownerName'] ?? 'N/A'),
                    _infoRow(
                        "Contact", propertyData?['contactDetails'] ?? 'N/A'),
                  ]),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            _bottomPurchaseSection(),
          ],
        ),
      ),
    );
  }

  Widget _propertyInfoHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const Icon(Icons.bed),
              Text("${propertyData?['bedrooms'] ?? 'N/A'} Beds")
            ],
          ),
          Column(
            children: [
              const Icon(Icons.bathroom),
              Text("${propertyData?['bathrooms'] ?? 'N/A'} Baths")
            ],
          ),
          Column(
            children: [
              const Icon(Icons.vertical_align_top_rounded),
              Text("${propertyData?['plotArea'] ?? 'N/A'} sqft")
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageSection() {
    List<dynamic> imageUrls = propertyData?['imageUrl'] ?? [];

    if (imageUrls.isEmpty) {
      imageUrls = [
        "https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg"
      ];
    }

    return StatefulBuilder(
      builder: (context, setState) {
        return Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                viewportFraction: 1.0,
                autoPlay: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: imageUrls.map((url) {
                return Builder(
                  builder: (BuildContext context) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Rs. ${propertyData?['expectedPrice'] ?? "N/A"}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_currentIndex + 1}/${imageUrls.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _addressSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Address",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          const SizedBox(height: 8),
          _infoRow("City", propertyData?['city'] ?? "N/A"),
          _infoRow("Locality", propertyData?['locality'] ?? "N/A"),
          _infoRow("Sub Locality", propertyData?['subLocality'] ?? "N/A"),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                String city = propertyData?['city'] ?? '';
                String locality = propertyData?['locality'] ?? '';
                String subLocality = propertyData?['subLocality'] ?? '';
                String address = "$subLocality, $locality, $city";
                if (address.isNotEmpty) {
                  final url = 'https://www.google.com/maps/search/?q=$address';
                  launch(
                      url); // Make sure to import url_launcher and set it up.
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondry,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "View on Map",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: AppFontFamily.primaryFont,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomPurchaseSection() {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total: Rs/- ${propertyData?['totalPrice'] ?? 'N/A'}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Buy Now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children,
      {bool isGrid = false}) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 12),
            isGrid
                ? Wrap(spacing: 16, runSpacing: 12, children: children)
                : Column(children: children),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: highlight ? Colors.green : null)),
        ],
      ),
    );
  }

  Widget _multiAmenitiesSection(
      String title, Map<String, List<String>> groupedAmenities) {
    return Container(
      width: double.infinity,
      child: _sectionCard(
        title,
        groupedAmenities.entries.map((entry) {
          final amenities = entry.value;

          return amenities.length <= 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    Chip(
                      label:
                          Text(amenities.isNotEmpty ? amenities.first : 'N/A'),
                      backgroundColor: Colors.grey[200],
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: amenities.map((amenity) {
                        return Chip(
                          label: Text(amenity),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
        }).toList(),
        isGrid: false,
      ),
    );
  }
}
