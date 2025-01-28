// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: PropertyDetailPage(
//         imageUrl: 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//         title: 'Charming Single-Family Home',
//         address: '3703 Castle Rock Dr\nRound Rock, TX 78681',
//         price: '\$267,000',
//         description: 'Very charming 3 bed/2 bath renovated single-family home with open new kitchen with brand new appliances and fixtures...',
//         amenities: ['Swimming Pool', 'Gym', 'Playground'],
//         builtYear: '2005',
//         floorNumber: '1',
//         totalFloors: '2',
//         furnishingStatus: 'Furnished',
//         ownership: 'Freehold',
//         monthlyMaintenance: '\$200',
//         nearbyLandmarks: ['Park', 'Shopping Mall', 'School'],
//         contactName: 'John Doe',
//         contactPhone: '(123) 456-7890',
//         contactEmail: 'john.doe@example.com',
//       ),
//     );
//   }
// }
//
// class PropertyDetailPage extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String address;
//   final String price;
//   final String description;
//   final List<String> amenities;
//   final String builtYear;
//   final String floorNumber;
//   final String totalFloors;
//   final String furnishingStatus;
//   final String ownership;
//   final String monthlyMaintenance;
//   final List<String> nearbyLandmarks;
//   final String contactName;
//   final String contactPhone;
//   final String contactEmail;
//
//   const PropertyDetailPage({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//     required this.address,
//     required this.price,
//     required this.description,
//     required this.amenities,
//     required this.builtYear,
//     required this.floorNumber,
//     required this.totalFloors,
//     required this.furnishingStatus,
//     required this.ownership,
//     required this.monthlyMaintenance,
//     required this.nearbyLandmarks,
//     required this.contactName,
//     required this.contactPhone,
//     required this.contactEmail,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[50],
//       body: NestedScrollView(
//         headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//           return [
//             SliverAppBar(
//               backgroundColor: Colors.transparent,
//               expandedHeight: 250.0,
//               floating: false,
//               pinned: true,
//               title: innerBoxIsScrolled ? Text(title) : null,
//               actions: innerBoxIsScrolled
//                   ? [
//                 IconButton(
//                   icon: Icon(Icons.phone),
//                   onPressed: () {
//                     // Handle contact button
//                   },
//                 ),
//               ]
//                   : null,
//               flexibleSpace: FlexibleSpaceBar(
//                 background: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     Image.network(
//                       imageUrl,
//                       fit: BoxFit.cover,
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.black.withOpacity(0.5),
//                             Colors.transparent,
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 10,
//                       right: 10,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'Self-tour',
//                           style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ];
//         },
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   address,
//                   style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                 ),
//                 SizedBox(height: 16),
//                 Text(description, style: TextStyle(fontSize: 16)),
//                 SizedBox(height: 16),
//                 Text('Amenities:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(amenities.join(', ')),
//                 SizedBox(height: 16),
//                 Text('Details:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text('Year Built: $builtYear'),
//                 Text('Floor: $floorNumber of $totalFloors'),
//                 Text('Furnishing: $furnishingStatus'),
//                 Text('Ownership: $ownership'),
//                 Text('Maintenance: $monthlyMaintenance'),
//                 SizedBox(height: 16),
//                 Text('Nearby Landmarks:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text(nearbyLandmarks.join(', ')),
//                 SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       price,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green,
//                       ),
//                     ),
//                     ElevatedButton.icon(
//                       onPressed: () {},
//                       icon: Icon(Icons.flash_on),
//                       label: Text('Self-tour'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//                 Text('Contact:', style: TextStyle(fontWeight: FontWeight.bold)),
//                 Text('Name: $contactName'),
//                 Text('Phone: $contactPhone'),
//                 Text('Email: $contactEmail'),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
