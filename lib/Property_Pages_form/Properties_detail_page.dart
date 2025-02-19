import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/conigs/app_colors.dart';

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
      appBar: CustomAppBar(title: "Property Details"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError || propertyData == null
          ? const Center(child: Text("Property not found"))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(),
            _propertyInfoSection(),
            _descriptionSection(),
            _amenitiesSection(),
            _contactSellerSection(),
            _bottomPurchaseSection(),
          ],
        ),
      ),
    );
  }

  Widget _imageSection() {
    return Stack(
      children: [
        Image.network(
          propertyData?['imageUrl'] ?? "https://via.placeholder.com/600x400?text=No+Image+Available",
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Rs. ${propertyData?['price'] ?? "N/A"}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
          Text(propertyData?['title'] ?? "No Title", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey),
              const SizedBox(width: 5),
              Expanded(
                child: Text(propertyData?['address'] ?? "No Address Provided", style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ),
            ],
          ),
          _infoRow("Built Year", propertyData?['builtYear'] ?? "N/A"),
          _infoRow("Floor Number", "${propertyData?['floorNumber'] ?? 'N/A'} / ${propertyData?['totalFloors'] ?? 'N/A'}"),
          _infoRow("Furnishing Status", propertyData?['furnishingStatus'] ?? "N/A"),
          _infoRow("Ownership", propertyData?['ownership'] ?? "N/A"),
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
          const Text("Description", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(propertyData?['description'] ?? "No description available.", style: TextStyle(fontSize: 16, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _amenitiesSection() {
    List<dynamic> amenities = propertyData?['amenities'] ?? ["No amenities listed"];
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Amenities", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Wrap(
            spacing: 8,
            children: amenities.map((amenity) => Chip(label: Text(amenity))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _contactSellerSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(propertyData?['contactName'] ?? "Unknown"),
              subtitle: const Text("Seller"),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text(propertyData?['contactPhone'] ?? "N/A"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomPurchaseSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total: Rs/- ${propertyData?['price'] ?? 'N/A'}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Buy Now", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}