import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/conigs/app_colors.dart';

import '../Customs/CustomAppBar.dart';
import 'Properties_detail_page.dart';

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
    if (user == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Favorite Properties'),
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
                const Text(
                  'You need to log in to view your favorite properties.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // The rest of the code for fetching favorites and displaying them.
    // return Scaffold(
    //   appBar: CustomAppBar(title: 'Favorite Properties'),
    //   body: FutureBuilder<QuerySnapshot>(
    //     future: FirebaseFirestore.instance
    //         .collection('AppProperties')
    //         .where(FieldPath.documentId,
    //         whereIn: favoritePropertyIds.isEmpty
    //             ? ['dummy']
    //             : favoritePropertyIds)
    //         .get(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return _buildShimmerLoading();
    //       }
    //
    //       if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
    //         return _buildEmptyState();
    //       }
    //
    //       var favoriteProperties = snapshot.data!.docs;
    //
    //       return ListView.builder(
    //         padding: const EdgeInsets.all(10),
    //         itemCount: favoriteProperties.length,
    //         itemBuilder: (context, index) {
    //           var property = favoriteProperties[index];
    //           var propertyData = property.data() as Map<String, dynamic>;
    //
    //           return _buildPropertyCard(propertyData, property.id);
    //         },
    //       );
    //     },
    //   ),
    // );

    return Scaffold(
      appBar: CustomAppBar(title: 'Favorite Properties'),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('AppProperties')
            .where(FieldPath.documentId,
                whereIn: favoritePropertyIds.isEmpty
                    ? ['dummy']
                    : favoritePropertyIds)
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

              return _buildPropertyCard(propertyData, property.id);
            },
          );
        },
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
          const Text(
            'No Favorite Properties Yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          // const Text(
          //   'Browse and save properties you like.',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(fontSize: 16, color: Colors.grey),
          // ),
          // const SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/properties'); // Replace with the actual navigation route
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.blue,
          //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   child: const Text(
          //     'Browse Properties',
          //     style: TextStyle(fontSize: 16, color: Colors.white),
          //   ),
          // ),
        ],
      ),
    );
  }

  /// **Property Card**
  Widget _buildPropertyCard(
      Map<String, dynamic> propertyData, String propertyId) {
    return InkWell(
      onTap: () {
        // Handle the card click action, e.g., navigate to details page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyDetailPage(
              docId: propertyId,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              propertyData['imageUrl'] ?? 'https://via.placeholder.com/150',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            propertyData['title'] ?? 'Unknown Property',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            propertyData['expectedPrice'] ?? 'Price not available',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              removeFavorite(propertyId);
            },
          ),
        ),
      ),
    );
  }
}
