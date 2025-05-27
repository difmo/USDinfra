import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../Customs/CustomAppBar.dart';
import 'properties_detail_page.dart';

class FavoritePropertiesPage extends StatefulWidget {
  const FavoritePropertiesPage({super.key});

  @override
  State<FavoritePropertiesPage> createState() => _FavoritePropertiesPageState();
}

class _FavoritePropertiesPageState extends State<FavoritePropertiesPage> {
  String? userId;
  List<String> favoritePropertyIds = [];
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _fetchFavoritePropertyIds();
  }

  Future<void> _fetchFavoritePropertyIds() async {
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection("AppUsers")
          .doc(user!.uid)
          .get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        final List<dynamic> favoritesRaw = data['favoriteProperties'] ?? [];
        final List<String> ids = favoritesRaw.map((e) => e.toString()).toList();
        if (mounted) {
          setState(() {
            userId = user!.uid;
            favoritePropertyIds = ids;
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching favoritePropertyIds: $e');
    }
  }

  Future<void> _toggleFavorite(String propertyId) async {
    if (user == null) {
      _showLoginDialog();
      return;
    }

    final docRef =
        FirebaseFirestore.instance.collection("AppUsers").doc(userId);
    final isFavorite = favoritePropertyIds.contains(propertyId);

    try {
      await docRef.update({
        "favoriteProperties": isFavorite
            ? FieldValue.arrayRemove([propertyId])
            : FieldValue.arrayUnion([propertyId])
      });
      if (mounted) {
        setState(() {
          isFavorite
              ? favoritePropertyIds.remove(propertyId)
              : favoritePropertyIds.add(propertyId);
        });
      }
    } catch (e) {
      debugPrint("Error updating favorite list: $e");
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('You need to log in'),
        content: const Text('Log in to add properties to favorites.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRouts.login);
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(height: 100, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(title: "Favorite Properties"),
        body: favoritePropertyIds.isEmpty
            ? const Center(child: Text('No favorite properties'))
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("AppProperties")
                    .where('isDeleted', isEqualTo: false)
                    .where('isPurchesed', isEqualTo: false)
                    .where('isApproved', isEqualTo: true)
                    .where(FieldPath.documentId, whereIn: favoritePropertyIds)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _shimmerLoading();
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No matching properties."));
                  }

                  final properties = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      final doc = properties[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final imageUrl = (data['imageUrl'] is List &&
                              data['imageUrl'].isNotEmpty)
                          ? data['imageUrl'][0]
                          : 'https://via.placeholder.com/150';

                      final isFavorite = favoritePropertyIds.contains(doc.id);

                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      PropertyDetailPage(docId: doc.id)),
                            );
                          },
                          leading: Image.network(imageUrl,
                              width: 60, height: 60, fit: BoxFit.cover),
                          title: Text(data['title'] ?? 'Unnamed'),
                          subtitle: Text(data['city'] ?? 'Unknown'),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(doc.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
