import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/conigs/app_colors.dart';

class PropertyDetailPage extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? address;
  final String? price;
  final String? description;
  final List<dynamic>? amenities;
  final String? builtYear;
  final String? floorNumber;
  final String? totalFloors;
  final String? furnishingStatus;
  final String? ownership;
  final String? monthlyMaintenance;
  final List<dynamic>? nearbyLandmarks;
  final String? contactName;
  final String? contactPhone;
  final String? contactEmail;

  const PropertyDetailPage({
    super.key,
    this.imageUrl,
    this.title,
    this.address,
    this.price,
    this.description,
    this.amenities,
    this.builtYear,
    this.floorNumber,
    this.totalFloors,
    this.furnishingStatus,
    this.ownership,
    this.monthlyMaintenance,
    this.nearbyLandmarks,
    this.contactName,
    this.contactPhone,
    this.contactEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Propert Details"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(),
            _propertyInfoSection(),
            _descriptionSection(),
            _amenitiesSection(),
            _contactSellerSection(context),
          ],
        ),
      ),
      bottomNavigationBar: _bottomPurchaseSection(context),
    );
  }

  // 🔹 Property Image Section (With Default Placeholder)
  Widget _imageSection() {
    return Stack(
      children: [
        Image.network(
          imageUrl ??
              "https://via.placeholder.com/600x400?text=No+Image+Available",
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
              price ?? "Price Not Available",
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // 🔹 Property Details Section
  Widget _propertyInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? "No Title",
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.grey),
              const SizedBox(width: 5),
              Expanded(
                child: Text(address ?? "No Address Provided",
                    style: TextStyle(fontSize: 16, color: Colors.grey[700])),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _infoRow("Built Year", builtYear ?? "N/A"),
          _infoRow("Floor Number",
              "${floorNumber ?? 'N/A'} / ${totalFloors ?? 'N/A'}"),
          _infoRow("Furnishing Status", furnishingStatus ?? "N/A"),
          _infoRow("Ownership", ownership ?? "N/A"),
          _infoRow("Monthly Maintenance", monthlyMaintenance ?? "N/A"),
        ],
      ),
    );
  }

  // 🔹 Property Description Section (Handles Missing Data)
  Widget _descriptionSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(description ?? "No description available for this property.",
              style: TextStyle(fontSize: 16, color: Colors.grey[800])),
        ],
      ),
    );
  }

  // 🔹 Amenities Section (Handles Missing List)
  Widget _amenitiesSection() {
    List<dynamic> availableAmenities = amenities ?? ["No amenities listed"];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Amenities",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Wrap(
            spacing: 8,
            children: availableAmenities.map((amenity) {
              return Chip(
                label: Text(amenity),
                backgroundColor: AppColors.primary.withOpacity(0.1),
                labelStyle: TextStyle(
                    color: AppColors.primary, fontWeight: FontWeight.bold),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // 🔹 Contact Seller Section (Handles Missing Data)
  Widget _contactSellerSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(
                  // contactName ??
                  "Suresh Kumar"),
              subtitle: const Text("Seller"),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: Text(
                  // contactPhone ??
                  "+91 999 999 9999"),
              onTap: () {
                // Implement call functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: Text(
                  // contactEmail ??
                  "contact@default.com"),
              onTap: () {
                // Implement email functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Buy Property Bottom Section
  Widget _bottomPurchaseSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            // price ??
            "Total : Rs/- 1000",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary),
          ),
          ElevatedButton(
            onPressed: () {
              _showPurchaseDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Buy Now",
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Purchase Confirmation Dialog
  void _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Purchase"),
        content: const Text("Are you sure you want to buy this property?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Property purchase initiated!")),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  // 🔹 Info Row Widget (Handles Missing Data)
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text("$label: ",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
