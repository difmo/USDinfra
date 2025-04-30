import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../Customs/CustomAppBar.dart';
import '../Property_Pages_form/edit_property.dart';
import '../configs/app_colors.dart';

class MyPropertiesPage extends StatefulWidget {
  @override
  _MyPropertiesPageState createState() => _MyPropertiesPageState();
}

class _MyPropertiesPageState extends State<MyPropertiesPage> {
  final User? user = FirebaseAuth.instance.currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() {
    setState(() {
      _currentUser = _auth.currentUser;
    });
  }

  Stream<QuerySnapshot> _getPropertiesStream() {
    if (_currentUser == null) {
      return Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection("AppProperties")
        .where("uid", isEqualTo: _currentUser!.uid)
        .where('isDeleted', isEqualTo: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Published Properties',
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                Text(
                  'You need to login to view your published properties.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: "All Listed Properties",
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getPropertiesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error loading properties",
              style: TextStyle(
                fontFamily: AppFontFamily.primaryFont,
              ),
            ));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
                child: Text(
              "No properties listed yet.",
              style: TextStyle(
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

              // Fetch values safely
              String imageUrl = property['imageUrl']?[0] ??
                  'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=';
              String city = property['city'] ?? "No City";
              String locality = property['locality'] ?? "Unknown Location";
              String expectedPrice = "${property['expectedPrice'] ?? 0}";

              // **Determine Property Status**
              bool? isApproved = property['isApproved'];
              String statusText;
              Color statusColor;

              if (isApproved == true) {
                statusText = "Approved";
                statusColor = Colors.green;
              } else if (isApproved == false) {
                statusText = "Under Review";
                statusColor = Colors.orange;
              } else {
                statusText = "Rejected";
                statusColor = Colors.red;
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        // Property Image
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

                        // Positioned Edit & Delete Icons (Top-Right Corner) with Background Color
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.black
                                  .withOpacity(0.3), // Semi-transparent black
                              borderRadius:
                                  BorderRadius.circular(20), // Rounded corners
                            ),
                            child: Row(
                              children: [
                                // Edit Icon
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: AppColors.secondry),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditPropertyPage(docId: docId),
                                      ),
                                    );
                                  },
                                ),

                                // Delete Icon
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: AppColors.primary),
                                  onPressed: () {
                                    _showDeleteConfirmationDialog(
                                        context, property.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "City: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                              Text(
                                city, // Fixed syntax error
                                style: TextStyle(
                                  fontSize: 18,
                                  // fontWeight: FontWeight.bold,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "Locality: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                              Text(
                                locality,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                "Price: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                              Text(
                                expectedPrice,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                            ],
                          ),

                          // **Property Status Row**
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Status: ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: AppFontFamily.primaryFont,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: statusColor),
                                ),
                                child: Text(
                                  statusText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: statusColor,
                                    fontFamily: AppFontFamily.primaryFont,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
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

  void _deleteProperty(String propertyId) async {
    await FirebaseFirestore.instance
        .collection('AppProperties')
        .doc(propertyId)
        .update({
      'isDeleted': true,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
      "Property deleted successfully!",
      style: TextStyle(
        fontFamily: AppFontFamily.primaryFont,
      ),
    )));
  }

  void _showDeleteConfirmationDialog(BuildContext context, String propertyId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Confirm Delete",
        style: TextStyle(fontFamily: AppFontFamily.primaryFont,),),
          content: Text("Are you sure you want to delete this property?",
          style: TextStyle(fontFamily: AppFontFamily.primaryFont,),),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.secondry),
              child: Text("Cancel",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.primaryFont,)),
            ),
            ElevatedButton(
              onPressed: () {
                _deleteProperty(propertyId); // Call delete function
                Navigator.of(context).pop(); // Close the popup after deletion
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: Text("Delete",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.primaryFont,)),
            ),
          ],
        );
      },
    );
  }
}
