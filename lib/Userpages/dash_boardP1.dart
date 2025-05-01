// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:usdinfra/Bottom/bottom_navigation.dart';
// import 'package:usdinfra/Customs/custom_app_bar.dart';
// import 'package:usdinfra/Property_Pages_form/properties_detail_page.dart';
// import 'package:usdinfra/Userpages/dash_bordP2.dart';
// import 'package:usdinfra/Userpages/dummy_profile.dart';
// import 'package:usdinfra/configs/app_colors.dart';
// import 'package:usdinfra/configs/font_family.dart';
// import 'package:usdinfra/routes/app_routes.dart';
// import '../Components/cerosoule.dart';
// import '../Components/property_card.dart';
// import '../Customs/drawer.dart';

// class HomeDashBoard extends StatefulWidget {
//   const HomeDashBoard({super.key});

//   @override
//   State<HomeDashBoard> createState() => _HomeDashBoard();
// }

// class _HomeDashBoard extends State<HomeDashBoard> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int _selectedIndex = 0;
//   String? userId;
//   List<String> favoriteProperties = [];
//   bool isLoading = false;
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _getCurrentUserFavorites();
//   }

//   Future<void> _getCurrentUserFavorites() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       userId = user.uid;
//       final doc = await FirebaseFirestore.instance
//           .collection("AppUsers")
//           .doc(userId)
//           .get();
//       if (doc.exists) {
//         setState(() {
//           favoriteProperties =
//               List<String>.from(doc.data()?["favoriteProperties"] ?? []);
//         });
//       }
//     }
//   }

//   Future<void> _toggleFavorite(String propertyId) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       _showLoginDialog();
//       return;
//     }

//     if (userId == null) return;

//     final docRef =
//         FirebaseFirestore.instance.collection("AppUsers").doc(userId);
//     bool isCurrentlyFavorite = favoriteProperties.contains(propertyId);

//     setState(() {
//       if (favoriteProperties.contains(propertyId)) {
//         favoriteProperties.remove(propertyId);
//       } else {
//         favoriteProperties.add(propertyId);
//       }
//     });

//     try {
//       await docRef.update({"favoriteProperties": favoriteProperties});
//       // await _getCurrentUserFavorites(); // 🔥 Fetch fresh favorites from Firestore
//     } catch (e) {
//       setState(() {
//         if (isCurrentlyFavorite) {
//           favoriteProperties.add(propertyId);
//         } else {
//           favoriteProperties.remove(propertyId);
//         }
//       });
//       print("Error updating favorites: $e");
//     }
//   }

//   void _showLoginDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           title: const Text('You need to log in!'),
//           content:
//               const Text('Please log in to add properties to your favorites.'),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop(); // Close the dialog
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.secondry,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                   ),
//                   child: const Text(
//                     'Cancel',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushNamed(
//                         context, AppRouts.login); // Navigate to login page
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primary,
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 30, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(22),
//                     ),
//                   ),
//                   child: const Text(
//                     'Log In',
//                     style: TextStyle(fontSize: 16, color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });

//     switch (index) {
//       case 0:
//         break;
//       case 1:
//         Navigator.pushNamed(context, AppRouts.chat);
//         break;
//       case 2:
//         Navigator.pushNamed(context, AppRouts.propertyform1);
//         break;
//       case 3:
//         Navigator.pushNamed(context, AppRouts.upgardeservice);
//         break;
//       case 4:
//         Navigator.pushNamed(context, AppRouts.profile);
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     return SafeArea(
//       child: Scaffold(
//         key: _scaffoldKey,
//         appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
//         drawer: CustomDrawer(),
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 10,),
//               Container(
//                 height: screenHeight * 0.28,
//                 child: const Carousel(),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                      Padding(
//                       padding: EdgeInsets.only(left: 9),
//                       child: Text(
//                         'Propertiess',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: AppFontFamily.primaryFont,
//                         ),
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushNamed(context, AppRouts.properties);
//                       },
//                       child: Text(
//                         'View All',
//                         style: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: AppFontFamily.primaryFont,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection("AppProperties")
//                       .where('isDeleted', isEqualTo: false)
//                       .where('isPurchesed', isEqualTo: false)
//                       .where('isApproved', isEqualTo: true)
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return Center(child: _shimmerLoading());
//                     }
//                     if (snapshot.hasError) {
//                       return Center(child: Text('Error: ${snapshot.error}'));
//                     }
//                     if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                       return Align(
//                         alignment: Alignment.center,
//                         child: Text('No properties available'),
//                       );
//                     }
      
//                     final List<Future<Map<String, dynamic>>> futureProperties =
//                         snapshot.data!.docs.map((doc) async {
//                       final data = doc.data() as Map<String, dynamic>? ?? {};
//                       final subCollectionSnapshot = await FirebaseFirestore
//                           .instance
//                           .collection("AppProperties")
//                           .doc(doc.id)
//                           .collection("form1Data")
//                           .get();
//                       final List<Map<String, dynamic>> form1DataList =
//                           subCollectionSnapshot.docs.map((subDoc) {
//                         return subDoc.data();
//                       }).toList();
      
//                       final createdAtTimestamp = data['createdAt'] as Timestamp?;
//                       final DateTime createdAtDate =
//                           createdAtTimestamp?.toDate() ?? DateTime.now();
//                       final int daysAgo =
//                           DateTime.now().difference(createdAtDate).inDays;
//                       final String createdAtString =
//                           daysAgo > 0 ? '$daysAgo days' : 'Today';
      
//                       return {
//                         'id': doc.id,
//                         // ?[0]
//                         'imageUrl': data['imageUrl']?[0]??
//                             'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
//                         'expectedPrice': data['expectedPrice'] ?? '₹ 80 Lac',
//                         'plotArea': data['plotArea'] ?? '1850 Sqft',
//                         'propertyType': data['propertyType'] ?? '2 BHK Flat',
//                         'city':
//                             data['city'] ?? 'Sector 10 Greater Noida West',
//                         'createdAt': createdAtString,
//                         'title': data['title'] ?? 'Godrej Aristocrat',
//                         'propertyStatus':
//                             data['availabilityStatus'] ?? 'Ready to move',
//                         'contactDetails': data['contactDetails'] ?? '8875673210',
//                         'form1Data': form1DataList,
//                       };
//                     }).toList();
      
//                     return FutureBuilder<List<Map<String, dynamic>>>(
//                       future: Future.wait(futureProperties),
//                       builder: (context, asyncSnapshot) {
//                         if (asyncSnapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return Center(child: _shimmerLoading());
//                         }
//                         if (asyncSnapshot.hasError) {
//                           return Center(
//                               child: Text(
//                             'Error: ${asyncSnapshot.error}',
//                             style: TextStyle(
//                               fontFamily: AppFontFamily.primaryFont,
//                             ),
//                           ));
//                         }
//                         if (!asyncSnapshot.hasData ||
//                             asyncSnapshot.data!.isEmpty) {
//                           return Center(
//                               child: Text(
//                             'No properties available',
//                             style: TextStyle(
//                               fontFamily: AppFontFamily.primaryFont,
//                             ),
//                           ));
//                         }
      
//                         final properties = asyncSnapshot.data!;
      
//                         return SingleChildScrollView(
//                           scrollDirection:
//                               Axis.horizontal, // Enable horizontal scrolling
//                           child: Row(
//                             children: properties.map((property) {
//                               bool isFavorite =
//                                   favoriteProperties.contains(property['id']);
      
//                               return GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => PropertyDetailPage(
//                                           docId: property['id']),
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   width: MediaQuery.of(context).size.width * 0.93,
//                                   margin: const EdgeInsets.only(right: 8),
//                                   child: Stack(
//                                     children: [
//                                       Container(
//                                         height: screenHeight * 0.28,
//                                         child: PropertyCard(
//                                           imageUrl: property['imageUrl'],
//                                           expectedPrice:
//                                               property['expectedPrice'],
//                                           plotArea: property['plotArea'],
//                                           propertyType: property['propertyType'],
//                                           city: property['city'],
//                                           createdAt: property['createdAt'],
//                                           title: property['title'],
//                                           propertyStatus:
//                                               property['propertyStatus'],
//                                           contactDetails:
//                                               property['contactDetails'],
                                          
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 10,
//                                         right: 10,
//                                         child: IconButton(
//                                           icon: Icon(
//                                             isFavorite
//                                                 ? Icons.favorite
//                                                 : Icons.favorite_border,
//                                             color: isFavorite
//                                                 ? Colors.red
//                                                 : Colors.grey,
//                                           ),
//                                           onPressed: () {
//                                             _toggleFavorite(property['id']);
//                                           },
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//               // Container(
//               //   height: screenHeight * 0.26,
//               //   child: RatingSection(),
//               // ),
//               Container(
//                 height: screenHeight * 0.24,
//                 child: PostPropertySection(),
//               ),
//               Container(
//                 height: screenHeight * 0.3,
//                 child: BossPlanSection(),
//               ),
//               Container(
//                 height: screenHeight * 0.6,
//                 child: PropertyOfferingsSection(),
//               ),
//               Container(
//                 height: screenHeight * 0.24,
//                 child: PopularCitiesSection(),
//               ),
//               Container(
//                 height: screenHeight * 0.27,
//                 child: FeedbackSection(),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: CustomBottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }

//   Widget _shimmerLoading() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Column(
//         children: List.generate(5, (index) => _shimmerItem()),
//       ),
//     );
//   }

//   Widget _shimmerItem() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         width: double.infinity,
//         height: 100,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//     );
//   }
// }



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/Bottom/bottom_navigation.dart';
import 'package:usdinfra/Customs/custom_app_bar.dart';
import 'package:usdinfra/Property_Pages_form/properties_detail_page.dart';
import 'package:usdinfra/Userpages/dash_bordP2.dart';
import 'package:usdinfra/Userpages/dummy_profile.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getCurrentUserFavorites();
  }

  Future<void> _getCurrentUserFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      final doc = await FirebaseFirestore.instance.collection("AppUsers").doc(userId).get();
      if (doc.exists) {
        setState(() {
          favoriteProperties = List<String>.from(doc.data()?['favoriteProperties'] ?? []);
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

    final docRef = FirebaseFirestore.instance.collection("AppUsers").doc(userId);
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

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('You need to log in!'),
        content: const Text('Please log in to add properties to your favorites.'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondry,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, AppRouts.login),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                ),
                child: const Text('Log In', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
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

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
        drawer: CustomDrawer(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 80),
                children: [
                  const SizedBox(height: 10),
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
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              // fontFamily: AppFontFamily.primaryFont,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRouts.properties),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppFontFamily.primaryFont,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _buildPropertyStreamBuilder(screenHeight),
                  ),
                  PostPropertySection(),
                  BossPlanSection(),
                  PropertyOfferingsSection(),
                  PopularCitiesSection(),
                  FeedbackSection(),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Widget _buildPropertyStreamBuilder(double screenHeight) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("AppProperties")
          .where('isDeleted', isEqualTo: false)
          .where('isPurchesed', isEqualTo: false)
          .where('isApproved', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _shimmerLoading();
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No properties available'));
        }

        final futures = snapshot.data!.docs.map((doc) async {
          final data = doc.data() as Map<String, dynamic>? ?? {};
          final subCollection = await FirebaseFirestore.instance
              .collection("AppProperties")
              .doc(doc.id)
              .collection("form1Data")
              .get();

          final createdAt = (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();
          final daysAgo = DateTime.now().difference(createdAt).inDays;
          final createdAtString = daysAgo > 0 ? '$daysAgo days' : 'Today';

          return {
            'id': doc.id,
            'imageUrl': data['imageUrl']?[0] ??
                'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg',
            'expectedPrice': data['expectedPrice'] ?? '₹ 80 Lac',
            'plotArea': data['plotArea'] ?? '1850 Sqft',
            'propertyType': data['propertyType'] ?? '2 BHK Flat',
            'city': data['city'] ?? 'Greater Noida West',
            'createdAt': createdAtString,
            'title': data['title'] ?? 'Property Title',
            'propertyStatus': data['availabilityStatus'] ?? 'Ready to move',
            'contactDetails': data['contactDetails'] ?? 'N/A',
          };
        }).toList();

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: Future.wait(futures),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return _shimmerLoading();
            }

            final properties = asyncSnapshot.data ?? [];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: properties.map((property) {
                  bool isFav = favoriteProperties.contains(property['id']);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PropertyDetailPage(docId: property['id']),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.93,
                      margin: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.28,
                            child: PropertyCard(
                              imageUrl: property['imageUrl'],
                              expectedPrice: property['expectedPrice'],
                              plotArea: property['plotArea'],
                              propertyType: property['propertyType'],
                              city: property['city'],
                              createdAt: property['createdAt'],
                              title: property['title'],
                              propertyStatus: property['propertyStatus'],
                              contactDetails: property['contactDetails'],
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => _toggleFavorite(property['id']),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _shimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(3, (index) => _shimmerItem()),
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
