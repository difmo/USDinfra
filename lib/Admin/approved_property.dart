import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usdinfra/Admin/adminappbar.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../Customs/CustomAppBar.dart';

class ApprovedPropertiesPage extends StatefulWidget {
  @override
  _ApprovedPropertiesPageState createState() => _ApprovedPropertiesPageState();
}

class _ApprovedPropertiesPageState extends State<ApprovedPropertiesPage> {
  /// ✅ Function to revert approval (mark as rejected)
  void _rejectProperty(String propertyId) async {
    await FirebaseFirestore.instance
        .collection("AppProperties")
        .doc(propertyId)
        .update({"isApproved": false}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Property Approval Revoked!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to update property: $error"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Approved Properties",
        index: 1,
        onProfileTap: () {
          Navigator.pushNamed(context, AppRouts.profile);
        },
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("AppProperties")
            .where("isDeleted", isEqualTo: false)
            .where("isApproved",
                isEqualTo: true) // ✅ Show only approved properties
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No properties approved yet."));
          }

          var properties = snapshot.data!.docs;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              var property = properties[index];
              String docId = property.id;
              String title = property["title"] ?? "Untitled Property";
              String city = property["city"] ?? "Unknown City";
              String expectedPrice = property["expectedPrice"] != null
                  ? "${property["expectedPrice"]}"
                  : "N/A";
              String imageUrl =
                  property["imageUrl"] ?? "https://via.placeholder.com/150";

              return Container(
                // color: Colors.white,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 0.5),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, size: 60),
                      ),
                    ),
                    // ✅ Property Title Overlay

                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Title: $title",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "City: $city",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Price: $expectedPrice",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                          SizedBox(width: screenWidth * 0.18),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  _rejectProperty(docId);
                                },
                                icon: Icon(Icons.cancel, color: Colors.white),
                                label: Text(
                                  "Revoke Approval",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 2),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
