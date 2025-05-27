import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usdinfra/admin/adminappbar.dart';
import 'package:usdinfra/Property_Pages_form/properties_detail_page.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../routes/app_routes.dart';
import 'admin_bottom_nav.dart';

class AdminPropertyPage extends StatefulWidget {
  const AdminPropertyPage({super.key});

  @override
  _AdminPropertyPageState createState() => _AdminPropertyPageState();
}

class _AdminPropertyPageState extends State<AdminPropertyPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushNamed(context, AppRouts.approvedProperty);
        break;
      case 2:
        Navigator.pushNamed(context, AppRouts.soldProperty);
        break;
      case 3:
        Navigator.pushNamed(context, AppRouts.enquiriesPage);
        break;
    }
  }

  void _updatePropertyStatus(String propertyId, bool isApproved) async {
    await FirebaseFirestore.instance
        .collection("AppProperties")
        .doc(propertyId)
        .update({"isApproved": isApproved}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(isApproved ? "Property Approved!" : "Property Rejected!"),
          backgroundColor: isApproved ? Colors.green : Colors.red,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update property: $error",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Pending Properties",
        index: 0,
        onProfileTap: () {
          Navigator.pushNamed(context, AppRouts.profile);
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("AppProperties")
            .where("isDeleted", isEqualTo: false)
            .where("isApproved", isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "No properties pending approval",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ));
          }

          var properties = snapshot.data!.docs;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              var property = properties[index];
              String docId = property.id;
              String title = property["title"] ?? "Untitled Property";
              String expectedPrice =
                  property["expectedPrice"] ?? "Untitled Property";
              String city = property["city"] ?? "Unknown City";
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

              // String imageUrl =
              //     property["imageUrl"] ?? "https://via.placeholder.com/150";

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailPage(docId: docId),
                    ),
                  );
                },
                child: Container(
                  // color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26, width: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          imageUrl,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                      // Property Title Overlay

                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title: $title",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: AppFontFamily.primaryFont,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "City: $city",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFontFamily.primaryFont,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Price: $expectedPrice",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontFamily: AppFontFamily.primaryFont,
                              ),
                            ),
                            SizedBox(height: 10),

                            // Align the buttons below the price and to the right
                            Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _updatePropertyStatus(docId, true);
                                    },
                                    icon:
                                        Icon(Icons.check, color: Colors.white),
                                    label: Text(
                                      "Approve",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppFontFamily.primaryFont,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 12),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 10), // Add space between buttons
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      _updatePropertyStatus(docId, false);
                                    },
                                    icon:
                                        Icon(Icons.close, color: Colors.white),
                                    label: Text(
                                      "Reject",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppFontFamily.primaryFont,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      ),
      bottomNavigationBar: AdminBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
