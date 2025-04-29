import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../Components/property_card.dart';
import '../Customs/CustomAppBar.dart';
import 'properties_detail_page.dart';

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
      appBar: CustomAppBar(
        title: 'All Properties',
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('AppProperties')
            .where('isDeleted', isEqualTo: false)
            .where('isPurchesed', isEqualTo: false)
            .where('isApproved', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(
                fontFamily: AppFontFamily.primaryFont,
              ),
            ));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              'No Properties Found',
              style: TextStyle(
                fontFamily: AppFontFamily.primaryFont,
              ),
            ));
          }

          var properties = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: properties.length,
            itemBuilder: (context, index) {
              var property = properties[index].data() as Map<String, dynamic>;
              final Timestamp? createdAtTimestamp =
                  property['createdAt'] as Timestamp?;
              final DateTime createdAtDate =
                  createdAtTimestamp?.toDate() ?? DateTime.now();
              final int daysAgo =
                  DateTime.now().difference(createdAtDate).inDays;
              final String createdAtString =
                  daysAgo > 0 ? '$daysAgo days' : 'Today';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PropertyDetailPage(docId: properties[index].id),
                    ),
                  );
                },
                child: Container(
                  height: screenHeight * 0.28,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: PropertyCard(
                    imageUrl: property['imageUrl']?[0] ??
                        'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
                    expectedPrice:
                        property['expectedPrice']?.toString() ?? 'N/A',
                    plotArea: property['plotArea']?.toString() ?? 'N/A',
                    propertyType: property['propertyType'] ?? 'Unknown',
                    city: property['city'] ?? 'Address not available',
                    createdAt: createdAtString,
                    title: property['title'] ?? 'No Title',
                    // features: property['features'] ?? [],
                    propertyStatus: property['availabilityStatus'] ?? 'Unknown',
                    contactDetails: property['contactDetails'] ?? {},
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
