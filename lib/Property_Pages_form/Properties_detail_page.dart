import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usdinfra/configs/font_family.dart';

class PropertyDetailPage extends StatefulWidget {
  final String docId;

  const PropertyDetailPage({super.key, required this.docId});

  @override
  _PropertyDetailPageState createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;
  bool hasError = false;

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
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: CustomAppBar(title: "Property Details"),
      body: isLoading
          ? _shimmerLoading()
          : hasError || propertyData == null
              ? Center(
                  child: Text(
                  "Property not found",
                  style: TextStyle(
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _imageSection(),
                            _propertyInfoSection(),
                            _descriptionSection(),
                            _propertyDetailSection(),
                            _addressSection(),
                            _contactSellerSection(),
                          ],
                        ),
                      ),
                    ),
                    _bottomPurchaseSection(),
                  ],
                ),
    );
  }

  // Address Section
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
          // Optional: You can display a Google Maps link or a map preview here.
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

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(5, (index) => _shimmerItem()),
      ),
    );
  }

  Widget _shimmerItem() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _imageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          child: Image.network(
            propertyData?['imageUrl'] ??
                "https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=",
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 10,
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
      ],
    );
  }

  Widget _propertyInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            propertyData?['title'] ?? "No Title",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          const SizedBox(height: 10),
          _infoRow("Plot Area", propertyData?['plotArea'] ?? "N/A"),
          _infoRow("Total Floors", propertyData?['totalFloors'] ?? "N/A"),
          _infoRow(
              "Availability", propertyData?['availabilityStatus'] ?? "N/A"),
          _infoRow("Ownership", propertyData?['ownershipType'] ?? "N/A"),
        ],
      ),
    );
  }

  Widget _propertyDetailSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Details",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          _infoRow("Property For", propertyData?['lookingTo'] ?? "N/A"),
          _infoRow("Property Type", propertyData?['propertyType'] ?? "N/A"),
          _infoRow(
              "Property Category", propertyData?['propertyCategory'] ?? "N/A"),
        ],
      ),
    );
  }

  Widget _descriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            propertyData?['description'] ?? "No description available.",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _contactSellerSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person, color: Colors.blue),
            title: Text(propertyData?['ownerName'] ?? "Unknown"),
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.green),
            title: Text(propertyData?['contactDetails'] ?? "N/A"),
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
            "Total: Rs/- ${propertyData?['expectedPrice'] ?? 'N/A'}",
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

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
