import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/components/property_card.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

import '../Customs/CustomAppBar.dart';
import 'properties_detail_page.dart';

class PurchesedPropertiesPage extends StatefulWidget {
  const PurchesedPropertiesPage({super.key});

  @override
  State<PurchesedPropertiesPage> createState() =>
      _PurchesedPropertiesPageState();
}

class _PurchesedPropertiesPageState extends State<PurchesedPropertiesPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> purchesedPropertyIds = [];

  @override
  void initState() {
    super.initState();
    _fetchpurchesedPropertyIds();
  }

  Future<void> _fetchpurchesedPropertyIds() async {
    if (user == null) return;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('AppUsers')
        .doc(user!.uid)
        .get();
    if (userDoc.exists) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      setState(() {
        purchesedPropertyIds =
            List<String>.from(data?['purchesedProperties'] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    if (user == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Purchased  Properties'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                Text(
                  'You need to log in to view your purchased properties.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Purchesed Properties'),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('AppProperties')
            .where(FieldPath.documentId,
                whereIn: purchesedPropertyIds.isEmpty
                    ? ['dummy']
                    : purchesedPropertyIds)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerLoading();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          var favoriteProperties = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: favoriteProperties.length,
            itemBuilder: (context, index) {
              var property = favoriteProperties[index];
              var propertyData = property.data() as Map<String, dynamic>;

              return _buildPropertyCard(
                  propertyData, property.id, screenHeight);
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      DateTime now = DateTime.now();

      int differenceInDays = now.difference(date).inDays;

      return '$differenceInDays days ';
    }
    return 'Date unknown';
  }

  /// **Shimmer Loading Effect**
  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      },
    );
  }

  /// **Empty State with Illustration & CTA**
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/4076/4076432.png', // Change to an appropriate illustration
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20),
          Text(
            'No Purchased Properties Yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> propertyData,
      String propertyId, double screenHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PropertyDetailPage(docId: propertyId)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Card
          SizedBox(
              height: screenHeight * 0.23,
              child: Stack(
                children: [
                  PropertyCard(
                    imageUrl: propertyData['imageUrl']? [0]?? '',
                    expectedPrice: propertyData['expectedPrice'] ?? '',
                    plotArea: propertyData['plotArea'] ?? '',
                    propertyType: propertyData['propertyType'] ?? '',
                    city: propertyData['city'] ?? '',
                    createdAt: _formatTimestamp(propertyData['createdAt']),
                    title: propertyData['title'] ?? '',
                    propertyStatus: propertyData['availabilityStatus'] ?? '',
                    contactDetails: propertyData['contactDetails'] ?? '',
                    showButtons: false,
                    
                  ),
                ],
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
