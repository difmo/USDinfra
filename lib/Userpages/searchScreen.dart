import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/Property_Pages_form/Properties_detail_page.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String searchQuery = "";

  Stream<List<Map<String, dynamic>>> getFilteredProperties() {
    return firestore
        .collection('AppProperties')
        .where('isPurchesed', isEqualTo: false)
        .where('isDeleted', isEqualTo: false)
        .where('isApproved', isEqualTo: true)
        .where('propertyApproved', isEqualTo: 'Yes')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // ✅ Add document ID to the data map
        return data;
      }).where((data) {
        final query = searchQuery.toLowerCase();
        return query.isEmpty ||
            (data['title']?.toString().toLowerCase().contains(query) ??
                false) ||
            (data['description']?.toString().toLowerCase().contains(query) ??
                false) ||
            (data['city']?.toString().toLowerCase().contains(query) ?? false);
      }).toList();
    });
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
      appBar: CustomAppBar(title: "Search Properties"),
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
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
              onChanged: saveSearchQuery,
            ),
          ),
          Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: getFilteredProperties(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text("Error loading properties."));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No properties found."));
              }

              var properties = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: properties.length,
                itemBuilder: (context, index) {
                  var data = properties[index];
                  // Print all data for the current property
                  print('Tapped on property: ${properties[index]['id']}');
                  print('Title: ${data['title']}');
                  print('Locality: ${data['locality']}');
                  print('Expected Price: ${data['expectedPrice']}');
                  print('Image URL: ${data['imageUrl']}');
                  print('City: ${data['city']}');
                  print('Availability Status: ${data['availabilityStatus']}');
                  print('Property Type: ${data['propertyType']}');

                  return GestureDetector(
                    onTap: () => {
                      // print(data[])
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PropertyDetailPage(docId: data['id']),
                        ),
                      )
                    },
                    child: PropertyCard(
                      title: data['title'] ?? "N/A",
                      locality: data['locality'] ?? "N/A",
                      expectedPrice: data['expectedPrice'],
                      imageUrl: (data['imageUrl'] is List &&
                              data['imageUrl'].isNotEmpty)
                          ? data['imageUrl'][0]
                          : "https://via.placeholder.com/150",
                      city: data['city'] ?? "N/A",
                      availabilityStatus: data['availabilityStatus'] ?? "N/A",
                      propertyType: data['propertyType'] ?? "N/A",
                    ),
                  );
                },
              );
            },
          )),
        ],
      ),
    );
  }
}

String formatPrice(dynamic value) {
  try {
    double price = value is num
        ? value.toDouble()
        : double.tryParse(
                value.toString().replaceAll(",", "").replaceAll("₹", "")) ??
            0.0;

    if (price >= 10000000) {
      return "₹${(price / 10000000).toStringAsFixed(2)} Cr";
    } else if (price >= 100000) {
      return "₹${(price / 100000).toStringAsFixed(2)} Lac";
    } else {
      return "₹${price.toStringAsFixed(0)}";
    }
  } catch (_) {
    return "₹N/A";
  }
}

class PropertyCard extends StatelessWidget {
  final String title;
  final String locality;
  final dynamic expectedPrice;
  final String imageUrl;
  final String city;
  final String availabilityStatus;
  final String propertyType;

  const PropertyCard({
    super.key,
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
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              height: screenWidth * 0.28,
              width: screenWidth * 0.28,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: screenWidth * 0.28,
                width: screenWidth * 0.28,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("$locality, $city",
                    style: const TextStyle(fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(formatPrice(expectedPrice),
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                const SizedBox(height: 4),
                Text(propertyType,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(availabilityStatus,
                    style: const TextStyle(fontSize: 13, color: Colors.black)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
