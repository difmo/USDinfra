import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/Bottom/bottom_navigation.dart';
import 'package:usdinfra/Customs/custom_app_bar.dart';
import 'package:usdinfra/Property_Pages_form/Properties_detail_page.dart';
import 'package:usdinfra/conigs/app_colors.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../Components/cerosoule.dart';
import '../Components/property_card.dart';
import '../Customs/drawer.dart';

class HomeDashBoard extends StatefulWidget {
  const HomeDashBoard({super.key});

  @override
  State<HomeDashBoard> createState() => _HomeDashBoard();
}

class _HomeDashBoard extends State<HomeDashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  String? userId;
  List<String> favoriteProperties = [];
 bool isLoading =false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentUserFavorites();
  }

  Future<void> _getCurrentUserFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      final doc = await FirebaseFirestore.instance
          .collection("AppUsers")
          .doc(userId)
          .get();
      if (doc.exists) {
        setState(() {
          favoriteProperties =
              List<String>.from(doc.data()?["favoriteProperties"] ?? []);
        });
      }
    }
  }

  Future<void> _toggleFavorite(String propertyId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showLoginDialog();
      return;
    }

    if (userId == null) return;

    final docRef =
        FirebaseFirestore.instance.collection("AppUsers").doc(userId);
    bool isCurrentlyFavorite = favoriteProperties.contains(propertyId);

    setState(() {
      if (favoriteProperties.contains(propertyId)) {
        favoriteProperties.remove(propertyId);
      } else {
        favoriteProperties.add(propertyId);
      }
    });

    try {
      await docRef.update({"favoriteProperties": favoriteProperties});
      // await _getCurrentUserFavorites(); // 🔥 Fetch fresh favorites from Firestore
    } catch (e) {
      setState(() {
        if (isCurrentlyFavorite) {
          favoriteProperties.add(propertyId);
        } else {
          favoriteProperties.remove(propertyId);
        }
      });
      print("Error updating favorites: $e");
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('You need to log in!'),
          content:
              const Text('Please log in to add properties to your favorites.'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondry,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AppRouts.login); // Navigate to login page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
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
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, AppRouts.chat);
        break;
      case 2:
        Navigator.pushNamed(context, AppRouts.propertyform1);
        break;
      case 3:
        Navigator.pushNamed(context, AppRouts.upgardeservice);
        break;
      case 4:
        Navigator.pushNamed(context, AppRouts.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenHeight * 0.28, child: const Carousel()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 9),
                    child: Text(
                      'Properties',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRouts.properties);
                    },
                    child: Text(
                      'View More',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("AppProperties")
                    .where('isDeleted', isEqualTo: false)
                    .where('isApproved', isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: _shimmerLoading());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Align(
                      alignment: Alignment.center,
                        child: Text('No properties available'));
                  }
                  final List<Future<Map<String, dynamic>>> futureProperties =
                      snapshot.data!.docs.map((doc) async {
                    final data = doc.data() as Map<String, dynamic>? ?? {};
                    final subCollectionSnapshot = await FirebaseFirestore
                        .instance
                        .collection("AppProperties")
                        .doc(doc.id)
                        .collection("form1Data")
                        .get();
                    final List<Map<String, dynamic>> form1DataList =
                        subCollectionSnapshot.docs.map((subDoc) {
                      return subDoc.data();
                    }).toList();
                    final createdAtTimestamp = data['createdAt'] as Timestamp?;
                    final DateTime createdAtDate =
                        createdAtTimestamp?.toDate() ?? DateTime.now();
                    final int daysAgo =
                        DateTime.now().difference(createdAtDate).inDays;
                    final String createdAtString =
                        daysAgo > 0 ? '$daysAgo days' : 'Today';

                    return {
                      'id': doc.id,
                      'imageUrl': data['imageUrl'] ??
                          'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
                      'expectedPrice': data['expectedPrice'] ?? '₹ 80 Lac',
                      'plotArea': data['plotArea'] ?? '1850 Sqft',
                      'propertyType': data['propertyType'] ?? '2 BHK Flat',
                      'address':
                          data['address'] ?? 'Sector 10 Greater Noida West',
                      'createdAt': createdAtString, // Ensured non-null string
                      'title': data['title'] ?? 'Godrej Aristocrat',
                      // 'features': (data['features'] is List)
                      //     ? List<String>.from(data['features'])
                      //     // : ['Lift', 'Parking', 'East Facing'],
                      'propertyStatus':
                          data['availabilityStatus'] ?? 'Ready to move',
                      'contactDetails': data['contactDetails'] ?? '8875673210',
                      'form1Data': form1DataList,
                    };
                  }).toList();

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(futureProperties),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: _shimmerLoading());
                      }
                      if (asyncSnapshot.hasError) {
                        return Center(
                            child: Text('Error: ${asyncSnapshot.error}'));
                      }
                      if (!asyncSnapshot.hasData ||
                          asyncSnapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No properties available'));
                      }

                      final properties = asyncSnapshot.data!;

                      return Column(
                        children: properties.asMap().entries.map((entry) {
                          Map<String, dynamic> property = entry.value;
                          bool isFavorite =
                              favoriteProperties.contains(property['id']);

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PropertyDetailPage(docId: property['id']),
                                ),
                              );
                            },
                            child: Container(
                              height: screenHeight * 0.30,
                              margin: const EdgeInsets.only(bottom: 6),
                              child: Stack(
                                children: [
                                  Container(
                                    height: screenHeight * 0.28,
                                    margin: const EdgeInsets.only(bottom: 6),
                                    child: PropertyCard(
                                      imageUrl: property['imageUrl'],
                                      expectedPrice: property['expectedPrice'],
                                      plotArea: property['plotArea'],
                                      propertyType: property['propertyType'],
                                      address: property['address'],
                                      createdAt: property['createdAt'],
                                      title: property['title'],
                                      // features: property['features'],
                                      propertyStatus:
                                          property['propertyStatus'],
                                      contactDetails:
                                          property['contactDetails'],
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: IconButton(
                                      icon: Icon(
                                        isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                                      onPressed: () {
                                        print(
                                            "Property ID: ${property['id']}"); // Print the ID
                                        _toggleFavorite(property[
                                            'id']); // Toggle favorite status
                                      },
                                    ),
                                  ),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(5, (index) => _shimmerItem()),
      ),
    );
  }

  Widget _shimmerItem() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
