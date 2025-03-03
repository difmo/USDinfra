import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usdinfra/Admin/adminappbar.dart';
import 'package:usdinfra/routes/app_routes.dart';

class AdminEnquiriesPage extends StatefulWidget {
  @override
  _AdminEnquiriesPageState createState() => _AdminEnquiriesPageState();
}

class _AdminEnquiriesPageState extends State<AdminEnquiriesPage> {
  List<Map<String, dynamic>> enquiriesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEnquiries();
  }

  void fetchEnquiries() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("AppContacts").get();

      setState(() {
        enquiriesList = snapshot.docs
            .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching enquiries: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _deleteEnquiry(String enquiryId) async {
    try {
      await FirebaseFirestore.instance
          .collection("AppContacts")
          .doc(enquiryId)
          .delete();

      setState(() {
        enquiriesList.removeWhere((enquiry) => enquiry["id"] == enquiryId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Inquiry deleted successfully!"),
            backgroundColor: Colors.red),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Failed to delete inquiry: $error"),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdminAppBar(
        title: "Enquiries",
        index: 2,
        onProfileTap: () {
          Navigator.pushNamed(context, AppRouts.profile);
        },
      ),
      body: isLoading
          //     ? ListView.builder(
          //   itemCount: 5, // Show 5 shimmer placeholders
          //   itemBuilder: (context, index) {
          //     return Shimmer.fromColors(
          //       baseColor: Colors.grey[300]!,
          //       highlightColor: Colors.grey[100]!,
          //       child: Padding(
          //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //         child: Container(
          //           // color: Colors.white,
          //           decoration: BoxDecoration(
          //             border: Border.all(color: Colors.black12,
          //                 width: 0.5),
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           child: Padding(
          //             padding: EdgeInsets.all(12),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: [
          //                 Container(
          //                   height: 10,
          //                   width: 100,
          //                   color: Colors.white,
          //                 ),
          //                 SizedBox(height: 10),
          //                 Container(
          //                   height: 12,
          //                   color: Colors.white,
          //                 ),
          //                 SizedBox(height: 8),
          //                 Container(
          //                   height: 12,
          //                   color: Colors.white,
          //                 ),
          //                 SizedBox(height: 10),
          //                 Container(
          //                   height: 12,
          //                   color: Colors.white,
          //                 ),
          //                 SizedBox(height: 10),
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.end,
          //                   children: [
          //                     Container(
          //                       height: 20,
          //                       width: 50,
          //                       color: Colors.white,
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // )
          //     : enquiriesList.isEmpty
          ? Center(child: Text("No enquiries available"))
          : ListView.builder(
              itemCount: enquiriesList.length,
              itemBuilder: (context, index) {
                var enquiry = enquiriesList[index];
                String enquiryId = enquiry["id"];
                String name = enquiry["name"] ?? "Unknown Name";
                String email = enquiry["email"] ?? "No Email";
                String mobile = enquiry["mobile"] ?? "No Phone";
                String message = enquiry["message"] ?? "No Message";
                Timestamp? createdAtTimestamp =
                    enquiry["createdAt"] as Timestamp?;
                DateTime createdAt = createdAtTimestamp != null
                    ? createdAtTimestamp.toDate()
                    : DateTime.now();
                String formattedDate =
                    "${createdAt.day}/${createdAt.month}/${createdAt.year}";

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Container(
                    // color: Colors.white,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12, width: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Name: $name",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteEnquiry(enquiryId),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text("Email: $email", style: TextStyle(fontSize: 14)),
                          Text("Phone: $mobile",
                              style: TextStyle(fontSize: 14)),
                          SizedBox(height: 10),
                          Text("Message:",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Text(message, style: TextStyle(fontSize: 14)),
                          SizedBox(height: 10),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text("Date: $formattedDate",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
