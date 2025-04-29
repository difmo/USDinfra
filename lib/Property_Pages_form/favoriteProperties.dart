import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/Components/property_card.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

import '../Customs/CustomAppBar.dart';
import 'properties_detail_page.dart';

class FavoritePropertiesPage extends StatefulWidget {
  const FavoritePropertiesPage({super.key});

  @override
  State<FavoritePropertiesPage> createState() => _FavoritePropertiesPageState();
}

class _FavoritePropertiesPageState extends State<FavoritePropertiesPage> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> favoritePropertyIds = [];

  @override
  void initState() {
    super.initState();
    _fetchFavoritePropertyIds();
  }

  Future<void> _fetchFavoritePropertyIds() async {
    if (user == null) return;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('AppUsers')
        .doc(user!.uid)
        .get();
    if (userDoc.exists) {
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

      setState(() {
        favoritePropertyIds =
            List<String>.from(data?['favoriteProperties'] ?? []);
      });
    }
  }

  Future<void> removeFavorite(String propertyId) async {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user!.uid)
          .update({
        'favoriteProperties': FieldValue.arrayRemove([propertyId])
      });

      setState(() {
        favoritePropertyIds.remove(propertyId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    if (user == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: 'Favorite Properties',
        ),
        body: _buildLoginPrompt(),
      );
    }

    if (favoritePropertyIds.isEmpty) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Favorite Properties'),
        body: _buildEmptyState(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Favorite Properties'),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('AppProperties')
            .where(FieldPath.documentId, whereIn: favoritePropertyIds)
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
              var property1 = property.data() as Map<String, dynamic>;

              return _buildPropertyCard(property1, property.id, screenHeight);
            },
          );
        },
      ),
    );
  }

  /// **Login Prompt if Not Logged In**
  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              'You need to log in to view your favorite properties.',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
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
    );
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

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime date = timestamp.toDate();
      DateTime now = DateTime.now();

      int differenceInDays = now.difference(date).inDays;

      return '$differenceInDays days ';
    }
    return 'Date unknown';
  }

  /// **Empty State**
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://cdn-icons-png.flaticon.com/512/4076/4076432.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20),
          Text(
            'No Favorite Properties Yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  /// **Property Card**
  Widget _buildPropertyCard(
      Map<String, dynamic> property, String propertyId, double screenHeight) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
           context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(
              docId: propertyId,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Card
          SizedBox(
              height: screenHeight * 0.28, // Responsive height
              child: Stack(
                children: [
                  // Property Card (Main Content)
                  PropertyCard(
                    imageUrl: property['imageUrl'] ?[0]?? '',
                    expectedPrice: property['expectedPrice'] ?? '',
                    plotArea: property['plotArea'] ?? '',
                    propertyType: property['propertyType'] ?? '',
                    city: property['city'] ?? '',
                    createdAt: _formatTimestamp(property['createdAt']),
                    title: property['title'] ?? '',
                    propertyStatus: property['availabilityStatus'] ?? '',
                    contactDetails: property['contactDetails'] ?? '',
                  ),

                  // Favorite Button (Positioned on Top Right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        removeFavorite(propertyId);
                      },
                    ),
                  ),
                ],
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
