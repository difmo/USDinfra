// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../Components/All_Properties_Card.dart';
// import 'Properties_detail_page.dart';
//
// class AllProperties extends StatefulWidget {
//   const AllProperties({super.key});
//
//   @override
//   State<AllProperties> createState() => _AllPropertiesState();
// }
//
// final List<Map<String, dynamic>> properties = [
//   {
//     'imageUrl': 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//     'price': '₹ 80 Lac',
//     'propertyType': '2 BHK Flat',
//     'address': 'Sector 10, Greater Noida West',
//     'title': 'Godrej Aristocrat',
//     'size': '1250 sq.ft',
//     'amenities': [
//       'Gym', 'Swimming Pool', 'Parking', 'Club House', 'Power Backup', '24x7 Security'
//     ],
//     'builtYear': 2020,
//     'contactInfo': {'name': 'John Doe', 'phone': '+91 9876543210', 'email': 'johndoe@example.com'},
//     'description': 'A spacious 2 BHK flat with modern amenities, located in a prime area of Greater Noida West.',
//     'floorNumber': 5,
//     'totalFloors': 15,
//     'furnishingStatus': 'Semi-Furnished',
//     'ownership': 'Freehold',
//     'monthlyMaintenance': '₹ 3,500',
//     'nearbyLandmarks': [
//       'Close to Metro Station',
//       '5 mins drive to Gaur City Mall',
//       'Nearby Schools and Hospitals'
//     ],
//     'additionalImages': [
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg'
//     ],
//   },
//   {
//     'imageUrl': 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//     'price': '₹ 1.2 Cr',
//     'propertyType': '4 BHK Villa',
//     'address': 'Sector 15, Greater Noida West',
//     'title': 'Emaar Palm Hills',
//     'size': '2000 sq.ft',
//     'amenities': [
//       'Private Garden', 'Swimming Pool', 'CCTV Surveillance', 'Power Backup', 'Club House'
//     ],
//     'builtYear': 2017,
//     'contactInfo': {'name': 'Sneha Gupta', 'phone': '+91 9876543233', 'email': 'snehagupta@example.com'},
//     'description': 'A stunning 4 BHK villa with a private garden and world-class amenities, perfect for a luxurious lifestyle.',
//     'floorNumber': null, // Villas generally don't have floors.
//     'totalFloors': 2,
//     'furnishingStatus': 'Fully Furnished',
//     'ownership': 'Leasehold',
//     'monthlyMaintenance': '₹ 5,000',
//     'nearbyLandmarks': [
//       'Adjacent to Green Belt',
//       '10 mins from Noida City Center',
//       'International Schools within 5 km'
//     ],
//     'additionalImages': [
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg'
//     ],
//   },
//   {
//     'imageUrl': 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//     'price': '₹ 75 Lac',
//     'propertyType': '3 BHK Apartment',
//     'address': 'Sector 7, Greater Noida West',
//     'title': 'Prestige Sunrise Park',
//     'size': '1400 sq.ft',
//     'amenities': [
//       'Lift', 'Parking', 'Gym', 'Indoor Games', 'Children\'s Play Area'
//     ],
//     'builtYear': 2015,
//     'contactInfo': {'name': 'Rahul Mehra', 'phone': '+91 9876543245', 'email': 'rahulmehra@example.com'},
//     'description': 'A modern 3 BHK apartment with excellent amenities, close to key attractions in the city.',
//     'floorNumber': 3,
//     'totalFloors': 12,
//     'furnishingStatus': 'Unfurnished',
//     'ownership': 'Freehold',
//     'monthlyMaintenance': '₹ 2,000',
//     'nearbyLandmarks': [
//       'Near IT Hub',
//       'Close to Noida-Greater Noida Expressway',
//       '10 mins to Metro Station'
//     ],
//     'additionalImages': [
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg'
//     ],
//   },
//   {
//     'imageUrl': 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//     'price': '₹ 65 Lac',
//     'propertyType': '2 BHK Flat',
//     'address': 'Sector 8, Greater Noida West',
//     'title': 'Sobha Eternia',
//     'size': '1200 sq.ft',
//     'amenities': [
//       'Club House', 'CCTV', 'Swimming Pool', 'Parking', '24x7 Security'
//     ],
//     'builtYear': 2018,
//     'contactInfo': {'name': 'Meena Sharma', 'phone': '+91 9876543266', 'email': 'meenasharma@example.com'},
//     'description': 'A budget-friendly 2 BHK flat with all basic amenities, suitable for small families.',
//     'floorNumber': 8,
//     'totalFloors': 20,
//     'furnishingStatus': 'Fully Furnished',
//     'ownership': 'Freehold',
//     'monthlyMaintenance': '₹ 2,500',
//     'nearbyLandmarks': [
//       'Opposite City Park',
//       'Near Shopping Complex',
//       '5 mins to Hospital'
//     ],
//     'additionalImages': [
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//       'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg'
//     ],
//   },
// ];
//
// class _AllPropertiesState extends State<AllProperties> {
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
// return StreamBuilder(
//   stream: FirebaseFirestore.instance.collection('properties').snapshots(),
//   builder: (context, AsyncSnapshot<QuerySnapshot>snapshot){
//     if(snapshot.connectionState == ConnectionState.waiting){
//     return Center(child: CircularProgressIndicator());
//     }
//   },
// );
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: Text(
//           'All Properties',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: properties.map((property) {
//             return
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PropertyDetailPage(
//                         imageUrl: property['imageUrl'],
//                         title: property['title'],
//                         address: property['address'],
//                         price: property['price'],
//                         description: property['description'],
//                         amenities: property['amenities'],
//                         builtYear: property['builtYear'].toString(),
//                         floorNumber: property['floorNumber']?.toString() ?? 'N/A',  // Handle null for floorNumber
//                         totalFloors: property['totalFloors'].toString(),
//                         furnishingStatus: property['furnishingStatus'],
//                         ownership: property['ownership'],
//                         monthlyMaintenance: property['monthlyMaintenance'],
//                         nearbyLandmarks: property['nearbyLandmarks'],
//                         contactName: property['contactInfo']['name'],
//                         contactPhone: property['contactInfo']['phone'],
//                         contactEmail: property['contactInfo']['email'],
//                       ),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   child: AllPropertyCard(
//                     imageUrl: property['imageUrl'],
//                     price: property['price'],
//                     propertyType: property['propertyType'],
//                     address: property['address'],
//                     title: property['title'],
//                   ),
//                 ),
//               );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Components/All_Properties_Card.dart';
import 'Properties_detail_page.dart';

class AllProperties extends StatefulWidget {
  const AllProperties({super.key});

  @override
  State<AllProperties> createState() => _AllPropertiesState();
}

class _AllPropertiesState extends State<AllProperties> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'All Properties',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('properties').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Properties Found'));
          }

          var properties = snapshot.data!.docs;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              var property = properties[index].data() as Map<String, dynamic>;

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailPage(
                        imageUrl: property['imageUrl'] ?? 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
                        title: property['title'] ?? '',
                        address: property['address'] ?? '',
                        price: property['price'] ?? '',
                        description: property['description'] ?? '',
                        amenities: property['amenities'] ?? [],
                        builtYear: property['builtYear']?.toString() ?? 'N/A',
                        floorNumber: property['floorNumber']?.toString() ?? 'N/A',
                        totalFloors: property['totalFloors']?.toString() ?? 'N/A',
                        furnishingStatus: property['furnishingStatus'] ?? '',
                        ownership: property['ownership'] ?? '',
                        monthlyMaintenance: property['monthlyMaintenance'] ?? '',
                        nearbyLandmarks: property['nearbyLandmarks'] ?? [],
                        contactName: property['contactInfo']?['name'] ?? '',
                        contactPhone: property['contactInfo']?['phone'] ?? '',
                        contactEmail: property['contactInfo']?['email'] ?? '',
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: AllPropertyCard(
                    imageUrl: property['imageUrl']??'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
                    price: property['expectedPrice']??'',
                    propertyType: property['propertyType']??'',
                    address: property['city']??'',
                    title: property['title']??'',
                  ),
//                   AllPropertyCard(
//                     imageUrl: property['imageUrl'] ?? 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
//                     price: property['expectedPrice'] ?? '',
//                     propertyType: property['propertyType'] ?? '2 BHK Flat',
//                     address: property['city'] ?? '',
//                     title: property['ownershipType'] ?? '',
//                   ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
