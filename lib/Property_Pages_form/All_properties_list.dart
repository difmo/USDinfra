import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usdinfra/Components/property_card2.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../Components/property_card.dart';
import '../Customs/CustomAppBar.dart';
import 'properties_detail_page.dart';

class AllProperties extends StatefulWidget {
  const AllProperties({super.key});

  @override
  State<AllProperties> createState() => _AllPropertiesState();
}

class _AllPropertiesState extends State<AllProperties> {
  int _selectedIndex = 0;
  String? userId;
  List<String> favoriteProperties = [];

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
              List<String>.from(doc.data()?['favoriteProperties'] ?? []);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              title: 'All Properties',
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("AppProperties")
                    .where('isDeleted', isEqualTo: false)
                    .where('isPurchesed', isEqualTo: false)
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
                      child: Text('No properties available'),
                    );
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
                      'imageUrl': data['imageUrl']?[0] ??
                          'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
                      'expectedPrice': data['expectedPrice'] ?? '₹ 80 Lac',
                      'plotArea': data['plotArea'] ?? '1850 Sqft',
                      'propertyType': data['propertyType'] ?? '2 BHK Flat',
                      'city': data['city'] ?? 'Sector 10 Greater Noida West',
                      'createdAt': createdAtString,
                      'title': data['title'] ?? 'Godrej Aristocrat',
                      'propertyStatus':
                          data['availabilityStatus'] ?? 'Ready to move',
                      'propertyCategory': data['propertyCategory'] ?? 'Plat',
                      'locality': data['locality'] ?? 'Lucknow',
                      'totalPrice': data['totalPrice'] ?? '100000',
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
                            child: Text(
                          'Error: ${asyncSnapshot.error}',
                          style:
                              TextStyle(fontFamily: AppFontFamily.primaryFont),
                        ));
                      }
                      if (!asyncSnapshot.hasData ||
                          asyncSnapshot.data!.isEmpty) {
                        return Center(
                            child: Text(
                          'No properties available',
                          style:
                              TextStyle(fontFamily: AppFontFamily.primaryFont),
                        ));
                      }

                      final properties = asyncSnapshot.data!;

                      return ListView.builder(
                        itemCount: properties.length,
                        itemBuilder: (context, index) {
                          final property = properties[index];
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
                              margin: const EdgeInsets.only(bottom: 16),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    child: PropertyCard2(
                                      imageUrl: property['imageUrl'],
                                      expectedPrice: property['expectedPrice'],
                                      plotArea: property['plotArea'],
                                      propertyType: property['propertyType'],
                                      city: property['city'],
                                      createdAt: property['createdAt'],
                                      title: property['title'],
                                      propertyStatus:
                                          property['propertyStatus'],
                                      contactDetails:
                                          property['contactDetails'],
                                      location: property['locality'],
                                      propertyCategory:
                                          property['propertyCategory'],
                                      totalPrice: property['totalPrice'],
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
                                        _toggleFavorite(property['id']);
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    left: 300,
                                    right: 10,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                              onTap: () => _launchWhatsApp(
                                                  "${property['contactDetails']}"),
                                              child: SvgPicture.asset(
                                                "assets/svg/whatsapp.svg",
                                                width: 30,
                                              )),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => _makePhoneCall(
                                                "${property['contactDetails']}"),
                                            child: Icon(
                                              Icons.phone,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            )));
  }

  void _launchWhatsApp(String whatsappNumber) async {
    final url = "https://wa.me/$whatsappNumber";
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    // }
  }

  void _makePhoneCall(String phoneNumber) async {
    final url = "tel:$phoneNumber";
    // if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
    // }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('You need to log in!'),
        content:
            const Text('Please log in to add properties to your favorites.'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondry,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                ),
                child: const Text('Cancel',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRouts.login),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22)),
                ),
                child: const Text('Log In',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
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
      if (isCurrentlyFavorite) {
        favoriteProperties.remove(propertyId);
      } else {
        favoriteProperties.add(propertyId);
      }
    });

    try {
      await docRef.update({"favoriteProperties": favoriteProperties});
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
