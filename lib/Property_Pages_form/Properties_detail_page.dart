import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usdinfra/Components/inquiry_form.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/admin/expandable_description.dart';
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

  final String phoneNumber = "9876543210"; // Replace with actual number
  final String whatsappNumber = "9876543210"; // Include country code if needed

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

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _launchWhatsApp() async {
    final url = "https://wa.me/${propertyData?["contactDetails"]}";
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // }
  }

  void _showNumberPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Contact Number"),
        content: Text(phoneNumber),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _makePhoneCall() async {
    final url = "tel:$phoneNumber";
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
    // }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  Future<void> submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection('AppContacts').add({
        'serviceName': "Property Inquiry",
        'email': emailController.text,
        'name': nameController.text,
        'mobile': phoneController.text,
        'message': messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inquiry submitted successfully')),
      );

      nameController.clear();
      emailController.clear();
      phoneController.clear();
      messageController.clear();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error submitting inquiry')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
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
                  Row(
                    children: [
                      Text(
                        formatPrice(propertyData?['totalPrice']),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    capitalizeFirstLetter(
                        propertyData?['title']?.toString() ?? 'N/A'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),

                  Text(
                    "${propertyData?['locality'] ?? "N/A"}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
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

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Facing : ${propertyData?['facing']?.isNotEmpty == true ? propertyData!['facing'][0] : 'N/A'}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2),
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          propertyData?['availabilityStatus'] ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      propertyData?['reraApproved']?.toString().toLowerCase() ==
                              'yes'
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "RERA APPROVED",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          6), // Spacing between text and icon
                                  const Icon(
                                    Icons.check_circle,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),

                  const SizedBox(height: 16),

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
                                  "Plot Area",
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
                              "${(propertyData?['expectedPrice'] as String?)?.replaceAll(RegExp(r'\s*SQFT', caseSensitive: false), '') ?? 'N/A'} Price",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
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
                    if ((propertyData?['reraApproved'] ?? '')
                            .toString()
                            .toLowerCase() ==
                        'no')
                      _infoRow("Rera", propertyData?['reraApproved'] ?? 'N/A'),
                    if ((propertyData?['reraApproved'] ?? '')
                            .toString()
                            .toLowerCase() ==
                        'yes')
                      _infoRow(
                          "Rera Number", propertyData?['reraNumber'] ?? 'N/A',
                          highlight: true),
                  ]),
                  Container(
                    child: Text(
                      "Property Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        propertyDetailRow('Ownership',
                            '${propertyData?['ownershipType'] ?? 'N/A'}'),
                        propertyDetailRow('Plot Area',
                            '${propertyData?['plotArea'] ?? 'N/A'} sqft'),
                        propertyDetailRow(
                            'Length', '${propertyData?['length'] ?? 'N/A'} Ft'),
                        propertyDetailRow('Breadth',
                            '${propertyData?['breadth'] ?? 'N/A'} Ft'),
                        propertyDetailRow('Property Approved',
                            '${propertyData?['propertyApproved'] ?? 'N/A'}'),
                        propertyDetailRow(
                            'facing', '${propertyData?['facing'] ?? 'N/A'}'),
                        propertyDetailRow('No. of Open Sides',
                            '${propertyData?['noOfOpenSides'] ?? 'N/A'}'),
                      ],
                    ),
                  ),

                  //_addressSection(),
                  _multiAmenitiesSection("Available Amenities", {
                    "Amenities":
                        List<String>.from(propertyData?['amenities'] ?? []),
                    // "Food Court":
                    //     List<String>.from(propertyData?['foodcourt'] ?? []),
                  }),

                  ExpandableDescription(
                      description: propertyData?['description'] ??
                          "No description available."),
                  const SizedBox(height: 24),

                  Container(
                    child: Text(
                      propertyData?['dealerType'] == null
                          ? "Contact N/A"
                          : "Contact ${propertyData?['dealerType']}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _sectionCard("Owner Info", [
                    // _infoRow("Ownership Type",
                    //     propertyData?['ownershipType'] ?? 'N/A'),
                    _infoRow("Owner", propertyData?['ownerName'] ?? 'N/A'),
                    _infoRow("Contact", propertyData?['dealerType'] ?? 'N/A'),
                  ]),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              height: 16,
            ),
            // _bottomPurchaseSection(),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // =======================
                    // 👤 Name Field
                    // =======================
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Your Name',
                        prefixIcon:
                            const Icon(Icons.person, color: Colors.blue),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // =======================
                    // ✉️ Email Field
                    // =======================
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.deepOrange),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                            .hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // =======================
                    // 📱 Phone Field
                    // =======================
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon:
                            const Icon(Icons.phone, color: Colors.green),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                          return 'Enter a valid 10-digit phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // =======================
                    // 📝 Message Field
                    // =======================
                    TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        prefixIcon:
                            const Icon(Icons.message, color: Colors.orange),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // =======================
                    // 🚀 Submit Button
                    // =======================
                    SizedBox(
                      width: 200,
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isSubmitting ? null : submitInquiry,
                        child: _isSubmitting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Submit Inquiry",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _launchWhatsApp,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.message, color: Colors.green),
                      SizedBox(width: 8),
                      Text("WhatsApp", textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () => _showNumberPopup(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    border: Border.all(color: AppColors.primary, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                  ),
                  child: const Text(
                    "View Number",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _makePhoneCall,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  border: Border.all(color: AppColors.primary, width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: const Icon(Icons.call, color: AppColors.white, size: 20),
              ),
            ),
            const SizedBox(width: 8),
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

  Widget propertyDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            // Positioned(
            //   top: 10,
            //   right: 10,
            //   child: Container(
            //     padding: const EdgeInsets.all(12),
            //     decoration: BoxDecoration(
            //       color: Colors.black54,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Text(
            //       "Rs. ${propertyData?['expectedPrice'] ?? "N/A"}",
            //       style: TextStyle(
            //         fontSize: 18,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //         fontFamily: AppFontFamily.primaryFont,
            //       ),
            //     ),
            //   ),
            // ),
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(title,
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
    return SizedBox(
      width: double.infinity,
      child: _sectionCard(
        title,
        groupedAmenities.entries.map((entry) {
          final amenities = entry.value;

          return amenities.length <= 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Text(
                    //   entry.key,
                    //   style:
                    //       TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    // ),
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




// fhdsjkfhsdkjfskdjfdkjheuireuif h