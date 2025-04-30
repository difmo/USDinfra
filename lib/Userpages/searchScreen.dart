import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String searchQuery = "";

  Stream<QuerySnapshot> getProperties() {
    if (searchQuery.isEmpty) {
      return firestore.collection('AppProperties').snapshots();
    } else {
      return firestore
          .collection('AppProperties')
          .where('isDeleted', isEqualTo: false)
          .where('isPurchesed', isEqualTo: false)
          .where('isApproved', isEqualTo: true)
          .where('city', isGreaterThanOrEqualTo: searchQuery)
          .where('city', isLessThan: searchQuery + 'z')
          .snapshots();
    }
  }

  void saveSearchQuery(String query) {
    setState(() {
      searchQuery = query.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Search Properties",
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter city name...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              onChanged: (query) {
                saveSearchQuery(query);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: getProperties(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error loading properties."));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No properties found."));
                }
                var properties = snapshot.data!.docs;

                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    var data = properties[index].data() as Map<String, dynamic>;
                    return PropertyCard(
                      title: data['title'] ?? "N/A",
                      locality: data['locality'] ?? "N/A",
                      expectedPrice: data['expectedPrice'] ?? "N/A",
                      imageUrl:
                          data['imageUrl'] ?? "https://via.placeholder.com/150",
                      city: data['city'] ?? "N/A",
                      availabilityStatus: data['availabilityStatus'] ?? "N/A",
                      propertyType: data['propertyType'] ?? "N/A",
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final String title,
      locality,
      expectedPrice,
      imageUrl,
      city,
      availabilityStatus,
      propertyType;

  PropertyCard({
    required this.title,
    required this.locality,
    required this.expectedPrice,
    required this.imageUrl,
    required this.city,
    required this.availabilityStatus,
    required this.propertyType,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow effect
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
        children: [
          // Property Image (Fixed width)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: screenWidth * 0.3,
              width: screenWidth * 0.3,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),

                  // Location and Price Row
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text("$locality, $city",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(expectedPrice,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Property Type and Availability Status Row
                  Row(
                    children: [
                      const Icon(Icons.business,
                          color: Colors.black54, size: 16),
                      const SizedBox(width: 4),
                      Text(propertyType,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 16),
                      const SizedBox(width: 4),
                      Text(availabilityStatus,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
