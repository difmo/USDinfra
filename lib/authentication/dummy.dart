// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:usdinfra/Bottom/bottom_navigation.dart';
// import 'package:usdinfra/Customs/custom_app_bar.dart';
// import 'package:usdinfra/Property_Pages_form/Properties_detail_page.dart';
// import 'package:usdinfra/conigs/app_colors.dart';
// import 'package:usdinfra/routes/app_routes.dart';
// import '../Components/cerosoule.dart';
// import '../Components/property_card.dart';
// import '../Customs/drawer.dart';
//
// class HomeDashBoard extends StatefulWidget {
//   const HomeDashBoard({super.key});
//
//   @override
//   State<HomeDashBoard> createState() => _HomeDashBoard();
// }
//
// class _HomeDashBoard extends State<HomeDashBoard> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   int _selectedIndex = 0;
//   String? userId;
//   List<String> favoriteProperties = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentUserFavorites();
//   }
//
//   /// Fetch current user's favorite properties from Firestore
//   Future<void> _getCurrentUserFavorites() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       userId = user.uid;
//       final doc = await FirebaseFirestore.instance.collection("AppUsers").doc(userId).get();
//       if (doc.exists) {
//         setState(() {
//           favoriteProperties = List<String>.from(doc.data()?["favoriteProperties"] ?? []);
//         });
//       }
//     }
//   }
//
//   /// Toggle favorite status of a property
//   Future<void> _toggleFavorite(String propertyId) async {
//     if (userId == null) return;
//
//     final docRef = FirebaseFirestore.instance.collection("AppUsers").doc(userId);
//     if (favoriteProperties.contains(propertyId)) {
//       // Remove property from favorites
//       favoriteProperties.remove(propertyId);
//     } else {
//       // Add property to favorites
//       favoriteProperties.add(propertyId);
//     }
//
//     await docRef.update({"favoriteProperties": favoriteProperties});
//     setState(() {});
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     switch (index) {
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
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
//       drawer: CustomDrawer(),
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: screenHeight * 0.28, child: const Carousel()),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(left: 9),
//                     child: Text(
//                       'Properties',
//                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, AppRouts.properties);
//                     },
//                     child: Text(
//                       'View More',
//                       style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection("AppProperties")
//                     .where('isDeleted', isEqualTo: false)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text('No properties available'));
//                   }
//
//                   final properties = snapshot.data!.docs.map((doc) {
//                     final data = doc.data() as Map<String, dynamic>? ?? {};
//                     final String propertyId = doc.id;
//
//                     return {
//                       'id': propertyId,
//                       'imageUrl': data['imageUrl'] ?? '',
//                       'expectedPrice': data['expectedPrice'] ?? '₹ 80 Lac',
//                       'plotArea': data['plotArea'] ?? '1850 Sqft',
//                       'propertyType': data['propertyType'] ?? '2 BHK Flat',
//                       'address': data['address'] ?? 'Sector 10 Greater Noida West',
//                       'createdAt': data['createdAt']?.toDate().toString() ?? 'Today',
//                       'title': data['title'] ?? 'Property Title',
//                       'features': List<String>.from(data['features'] ?? ['Lift', 'Parking']),
//                       'propertyStatus': data['propertyStatus'] ?? 'Ready to move',
//                       'contactDetails': data['contactDetails'] ?? 'N/A',
//                     };
//                   }).toList();
//
//                   return Column(
//                     children: properties.map((property) {
//                       bool isFavorite = favoriteProperties.contains(property['id']);
//
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => PropertyDetailPage(docId: property['id']),
//                             ),
//                           );
//                         },
//                         child: Stack(
//                           children: [
//                             Container(
//                               height: screenHeight * 0.39,
//                               margin: const EdgeInsets.only(bottom: 6),
//                               child: PropertyCard(
//                                 imageUrl: property['imageUrl'],
//                                 expectedPrice: property['expectedPrice'],
//                                 plotArea: property['plotArea'],
//                                 propertyType: property['propertyType'],
//                                 address: property['address'],
//                                 createdAt: property['createdAt'],
//                                 title: property['title'],
//                                 features: property['features'],
//                                 propertyStatus: property['propertyStatus'],
//                                 contactDetails: property['contactDetails'],
//                               ),
//                             ),
//                             Positioned(
//                               top: 10,
//                               right: 10,
//                               child: IconButton(
//                                 icon: Icon(
//                                   isFavorite ? Icons.favorite : Icons.favorite_border,
//                                   color: isFavorite ? Colors.red : Colors.grey,
//                                 ),
//                                 onPressed: () => _toggleFavorite(property['id']),
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     }).toList(),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 80),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomBottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
