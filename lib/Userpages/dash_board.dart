import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Customs/custom_app_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
      ),
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
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No properties available'));
                  }
                  print(
                      "Total properties fetched: ${snapshot.data!.docs.length}");
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

                    return {
                      'id': doc.id, // Unique ID
                      'imageUrl': data['imageUrl'] ??
                          'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
                      'expectedPrice': data['expectedPrice'] ?? '₹ 80 Lac',
                      'plotArea': data['plotArea'] ?? '1850 Sqft',
                      'propertyType': data['propertyType'] ?? '2 BHK Flat',
                      'address':
                          data['address'] ?? 'Sector 10 Greater Noida West',
                      'updateTime': data['updateTime'] ?? '6 days',
                      'title': data['title'] ?? 'Godrej Aristocrat',
                      'features': (data['features'] is List)
                          ? List<String>.from(data['features'])
                          : ['Lift', 'Parking', 'East Facing'],
                      'propertyStatus':
                          data['propertyStatus'] ?? 'Ready to move',
                      'contactDetails': data['contactDetails'] ?? '8875673210',

                      'form1Data': form1DataList, // Sub-collection data
                    };
                  }).toList();

                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: Future.wait(futureProperties),
                    builder: (context, asyncSnapshot) {
                      if (asyncSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
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
                        children: properties.map((property) {
                          return Container(
                            height: screenHeight * 0.39,
                            margin: const EdgeInsets.only(bottom: 6),
                            child: PropertyCard(
                              imageUrl: property['imageUrl'],
                              expectedPrice: property['expectedPrice'],
                              plotArea: property['plotArea'],
                              propertyType: property['propertyType'],
                              address: property['address'],
                              updateTime: property['updateTime'],
                              title: property['title'],
                              features: property['features'],
                              propertyStatus: property['propertyStatus'],
                              contactDetails: property['contactDetails'],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouts.propertyform1);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
