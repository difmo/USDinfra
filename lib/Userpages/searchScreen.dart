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
                    EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
                    var data =
                        properties[index].data() as Map<String, dynamic>;
                    return PropertyCard(
                      title: data['title'] ?? "N/A",
                      locality: data['locality'] ?? "N/A",
                      expectedPrice: data['expectedPrice'] ?? "N/A",
                      imageUrl: data['imageUrl'] ??
                          "https://via.placeholder.com/150",
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
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text("📍 $locality, $city",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                SizedBox(height: 6),
                Text("💰 $expectedPrice",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                SizedBox(height: 6),
                Text("🏢 $propertyType",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                Text("✔️ $availabilityStatus",
                    style: TextStyle(fontSize: 14, color: Colors.blue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
