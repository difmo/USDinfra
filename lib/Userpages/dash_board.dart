import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/configs/app_colors.dart';
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

  final List<Map<String, dynamic>> properties = [
    {
      'imageUrl': 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
      'price': '₹ 80 Lac',
      'size': '1850 Sqft',
      'propertyType': '2 BHK Flat',
      'address': 'Sector 10 Greater Noida West',
      'updateTime': '6 days',
      'title': 'Godrej Aristocrat',
      'features': ['Lift', 'Parking', 'East Facing'],
      'propertyStatus': 'Ready to move',
    },
    {
      'imageUrl': 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg',
      'price': '₹ 90 Lac',
      'size': '2000 Sqft',
      'propertyType': '3 BHK Flat',
      'address': 'Sector 5 Greater Noida West',
      'updateTime': '10 days',
      'title': 'DLF Garden City',
      'features': ['Lift', 'Parking', 'North Facing'],
      'propertyStatus': 'Ready to move',
    },
    // Add more property maps as needed
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'USD',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(CupertinoIcons.person_circle_fill,
                color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pushNamed(context, AppRouts.profile);
            },
          ),
        ],
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: screenHeight * 0.28,
            child: Carousel(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Properties',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouts.properties);
                  },
                  child: Text(
                    'More...',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: properties.length,
              itemBuilder: (context, index) {
                final property = properties[index];
                return Container(
                  height: screenHeight * 0.39,
                  margin: const EdgeInsets.only(bottom: 6),
                  child: PropertyCard(
                    imageUrl: property['imageUrl'],
                    expectedPrice: property['price'],
                    plotArea: property['size'],
                    propertyType: property['propertyType'],
                    city: property['address'],
                    createdAt: property['updateTime'],
                    title: property['title'],
                    propertyStatus: property['propertyStatus'],
                    contactDetails: property['features'],
                    showButtons: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouts.propertyform1);
        },
        backgroundColor: AppColors.primary,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
