import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usdinfra/admin/adminappbar.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';

class AdminEnquiriesPage extends StatefulWidget {
  const AdminEnquiriesPage({super.key});

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
        const SnackBar(
          content: Text("Inquiry deleted successfully!"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete inquiry: $error"),
          backgroundColor: Colors.red,
        ),
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : enquiriesList.isEmpty
              ? const Center(
                  child: Text("No enquiries available"),
                )
              : ListView.builder(
                  itemCount: enquiriesList.length,
                  itemBuilder: (context, index) {
                    var enquiry = enquiriesList[index];
                    String enquiryId = enquiry["id"];
                    String name = enquiry["name"] ?? "Unknown Name";
                    String email = enquiry["email"] ?? "No Email";
                    String mobile = enquiry["mobile"] ?? "No Phone";
                    String message = enquiry["message"] ?? "No Message";
                    String serviceType =
                        enquiry["serviceName"] ?? "General Inquiry";
                    Timestamp? createdAtTimestamp =
                        enquiry["timestamp"] as Timestamp?;
                    DateTime createdAt = createdAtTimestamp != null
                        ? createdAtTimestamp.toDate()
                        : DateTime.now();
                    String formattedDate =
                        "${createdAt.day}/${createdAt.month}/${createdAt.year}";

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Row with Title and Delete
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Service: $serviceType",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _deleteEnquiry(enquiryId),
                                  ),
                                ],
                              ),
                              const Divider(),
                              // User Details
                              Text("👤 Name: $name",
                                  style: const TextStyle(fontSize: 14)),
                              Text("✉️ Email: $email",
                                  style: const TextStyle(fontSize: 14)),
                              Text("📞 Phone: $mobile",
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(height: 10),
                              // Message Section
                              const Text(
                                "📝 Message:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                message,
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              // Date at the bottom right
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "📅 Date: $formattedDate",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
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
