import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/conigs/app_colors.dart';

import '../Customs/CustomAppBar.dart';
import '../authentication/dummy.dart';
import 'All_properties_list.dart';
import 'Properties_detail_page.dart';

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
            List<String>.from(data?['favoriteProperties'] ?? []);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                const Text(
                  'You need to log in to view your purchased properties.',
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
    return Scaffold(
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
            'No Purchased Properties Yet!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
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
        ),
      ),
    );
  }
}
