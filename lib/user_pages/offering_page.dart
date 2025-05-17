import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Components/property_card.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/Property_Pages_form/properties_detail_page.dart';
import 'package:shimmer/shimmer.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const DetailPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late String title;
  late String subtitle;
  late String imageUrl;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    subtitle = widget.subtitle;
    imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: title),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: FirebaseFirestore.instance
            .collection('AppProperties')
            .where('isDeleted', isEqualTo: false)
            .where('isPurchesed', isEqualTo: false)
            .where('isApproved', isEqualTo: true)
            .snapshots()
            .asyncMap((querySnapshot) async {
          var query1 = await FirebaseFirestore.instance
              .collection('AppProperties')
              .where('isDeleted', isEqualTo: false)
              .where('isPurchesed', isEqualTo: false)
              .where('lookingTo', isEqualTo: title)
              .where('isApproved', isEqualTo: true)
              .get();

          var query2 = await FirebaseFirestore.instance
              .collection('AppProperties')
              .where('isDeleted', isEqualTo: false)
              .where('isPurchesed', isEqualTo: false)
              .where('propertyCategory', isEqualTo: title)
              .where('isApproved', isEqualTo: true)
              .get();

          var query3 = await FirebaseFirestore.instance
              .collection('AppProperties')
              .where('isDeleted', isEqualTo: false)
              .where('isPurchesed', isEqualTo: false)
              .where('propertyType', isEqualTo: title)
              .where('isApproved', isEqualTo: true)
              .get();

          var combinedDocs = List<DocumentSnapshot>.from(query1.docs);
          combinedDocs.addAll(query2.docs);
          combinedDocs.addAll(query3.docs);
          var uniqueDocs = combinedDocs.toSet().toList();
          return uniqueDocs;
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: screenHeight * 0.28,
                    margin: const EdgeInsets.only(bottom: 16),
                    color: Colors.white,
                  ),
                );
              },
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Properties Found'));
          }

          var properties = snapshot.data!;

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
                      builder: (context) => PropertyDetailPage(
                        docId: properties[index].id,
                      ),
                    ),
                  );
                },
                child: Container(
                  height: screenHeight * 0.28,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: PropertyCard(
                    imageUrl: (property['imageUrl'] is List && property['imageUrl'].isNotEmpty)
                        ? property['imageUrl'][0]
                        : property['imageUrl']?.toString() ??
                            'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
                    expectedPrice:
                        property['expectedPrice']?.toString() ?? 'N/A',
                    plotArea: property['plotArea']?.toString() ?? 'N/A',
                    propertyType: property['propertyType']?.toString() ?? 'Unknown',
                    city: (property['address'] is List)
                        ? property['address'].join(', ')
                        : property['address']?.toString() ?? 'Address not available',
                    createdAt: createdAtString,
                    title: property['title']?.toString() ?? 'No Title',
                    propertyStatus: property['availabilityStatus']?.toString() ?? 'Unknown',
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
