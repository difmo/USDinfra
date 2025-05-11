import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usdinfra/Admin/adminappbar.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';

class SoldPropertiesPage extends StatefulWidget {
  const SoldPropertiesPage({super.key});

  @override
  _SoldPropertiesPageState createState() => _SoldPropertiesPageState();
}

class _SoldPropertiesPageState extends State<SoldPropertiesPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight =
        MediaQuery.of(context).size.height; // 🔥 Get screen height
    double screenWidth =
        MediaQuery.of(context).size.width; // 🔥 Get screen width

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Sold Properties",
        index: 1,
        onProfileTap: () {
          Navigator.pushNamed(context, AppRouts.profile);
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("AppProperties")
            .where("isApproved", isEqualTo: true)
            .where("isDeleted", isEqualTo: false)
            .where("isPurchesed",
                isEqualTo: true) // ✅ Show only Sold Properties
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "No properties sold yet.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ));
          }

          var properties = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: properties.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth > 600
                    ? 3
                    : 2, // ✅ 3 columns on large screens, 2 on small
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9, // ✅ Maintain aspect ratio
              ),
              itemBuilder: (context, index) {
                var property = properties[index];
                // String docId = property.id;
                String title = property["title"] ?? "Untitled Property";
                String city = property["city"] ?? "Unknown City";
                String expectedPrice = property["expectedPrice"] != null
                    ? "${property["expectedPrice"]}"
                    : "N/A";
                dynamic imageData = property["imageUrl"];

                String imageUrl;

                if (imageData is String) {
                  imageUrl = imageData;
                } else if (imageData is List &&
                    imageData.isNotEmpty &&
                    imageData[0] is String) {
                  imageUrl = imageData[0];
                } else {
                  imageUrl = "https://via.placeholder.com/150";
                }

                return GestureDetector(
                  onTap: () {
                    // Handle property click (e.g., navigate to details page)
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                              child: Image.network(
                                imageUrl,
                                height: screenHeight * 0.12,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.broken_image, size: 60),
                              ),
                            ),
                            Container(
                              height: screenHeight * 0.12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [Colors.black45, Colors.transparent],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth *
                                        0.04, // 🔥 Responsive font
                                    color: Colors.black87,
                                    fontFamily: AppFontFamily.primaryFont,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 16, color: Colors.grey),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        city,
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.035,
                                          color: Colors.grey[700],
                                          fontFamily: AppFontFamily.primaryFont,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  expectedPrice,
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.04,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFontFamily.primaryFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
