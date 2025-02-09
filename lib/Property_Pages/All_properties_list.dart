import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Components/property_card.dart';
import 'Properties_detail_page.dart';

class AllProperties extends StatefulWidget {
  const AllProperties({super.key});

  @override
  State<AllProperties> createState() => _AllPropertiesState();
}

class _AllPropertiesState extends State<AllProperties> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'All Properties',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('AppProperties').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Properties Found'));
          }

          var properties = snapshot.data!.docs;
          return SingleChildScrollView(
            child: Column(
              children: properties.map((doc) {
                var property = doc.data() as Map<String, dynamic>;
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PropertyDetailPage(
                          imageUrl: property['imageUrl'] ??
                              'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
                          title: property['title'] ?? '',
                          address: property['address'] ?? '',
                          price: property['price'] ?? '',
                          description: property['description'] ?? '',
                          amenities: property['amenities'] ?? [],
                          builtYear: property['builtYear']?.toString() ?? '',
                          floorNumber:
                              property['floorNumber']?.toString() ?? '',
                          totalFloors:
                              property['totalFloors']?.toString() ?? '',
                          furnishingStatus: property['furnishingStatus'] ?? '',
                          ownership: property['ownership'] ?? '',
                          monthlyMaintenance:
                              property['monthlyMaintenance'] ?? '',
                          nearbyLandmarks: property['nearbyLandmarks'] ?? [],
                          contactName: property['contactInfo']?['name'] ?? '',
                          contactPhone: property['contactInfo']?['phone'] ?? '',
                          contactEmail: property['contactInfo']?['email'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: screenHeight * 0.39,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: PropertyCard(
                      imageUrl: property['imageUrl'] ??
                          'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
                      expectedPrice: property['expectedPrice']?.toString() ?? 'N/A',
                      plotArea: property['plotArea']?.toString() ?? 'N/A',
                      propertyType: property['propertyType'] ?? 'Unknown',
                      address: property['address'] ?? 'Address not available',
                      updateTime: property['updateTime'] ?? 'N/A',
                      title: property['title'] ?? 'No Title',
                      features: property['features'] ?? [],
                      propertyStatus: property['propertyStatus'] ?? 'Unknown',
                      contactDetails: property['contactDetails'] ?? {},
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
