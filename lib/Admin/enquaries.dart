import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usdinfra/admin/adminappbar.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart'; // For email and call actions

class AdminEnquiriesPage extends StatefulWidget {
  const AdminEnquiriesPage({super.key});

  @override
  _AdminEnquiriesPageState createState() => _AdminEnquiriesPageState();
}

class _AdminEnquiriesPageState extends State<AdminEnquiriesPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> enquiriesList = [];
  List<Map<String, dynamic>> legalDocsList = [];
  bool isLoadingEnquiries = true;
  bool isLoadingLegalDocs = true;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchEnquiries();
    fetchLegalDocuments();
  }

  void fetchEnquiries() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("AppContacts").get();

      setState(() {
        enquiriesList = snapshot.docs
            .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
        isLoadingEnquiries = false;
      });
    } catch (error) {
      print("Error fetching enquiries: $error");
      setState(() {
        isLoadingEnquiries = false;
      });
    }
  }

  void fetchLegalDocuments() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("LegalDocuments").get();

      setState(() {
        legalDocsList = snapshot.docs
            .map((doc) => {"id": doc.id, ...doc.data() as Map<String, dynamic>})
            .toList();
        isLoadingLegalDocs = false;
      });
    } catch (error) {
      print("Error fetching legal documents: $error");
      setState(() {
        isLoadingLegalDocs = false;
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

  void _deleteLegalDocument(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("LegalDocuments")
          .doc(docId)
          .delete();

      setState(() {
        legalDocsList.removeWhere((doc) => doc["id"] == docId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Legal document request deleted successfully!"),
          backgroundColor: Colors.red,
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete legal document request: $error"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Launch email
  void _sendEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Legal Document Request',
    );
    await launchUrl(emailUri);
  }

  // Launch phone call
  void _makeCall(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: "+91$phone");
    final phoneUrl = 'tel:$phone';

    launchUrl(Uri.parse(phoneUrl));
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Could not launch phone dialer"),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Enquiries & Legal Requests"),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Enquiries"),
            Tab(text: "Legal Documents"),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, AppRouts.profile);
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Enquiries Tab
          isLoadingEnquiries
              ? const Center(child: CircularProgressIndicator())
              : enquiriesList.isEmpty
                  ? const Center(child: Text("No enquiries available"))
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
                                        onPressed: () =>
                                            _deleteEnquiry(enquiryId),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Text("👤 Name: $name",
                                      style: const TextStyle(fontSize: 14)),
                                  Text("✉️ Email: $email",
                                      style: const TextStyle(fontSize: 14)),
                                  Text("📞 Phone: $mobile",
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 10),
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
          // Legal Documents Tab
          isLoadingLegalDocs
              ? const Center(child: CircularProgressIndicator())
              : legalDocsList.isEmpty
                  ? const Center(
                      child: Text("No legal document requests available"))
                  : ListView.builder(
                      itemCount: legalDocsList.length,
                      itemBuilder: (context, index) {
                        var doc = legalDocsList[index];
                        String title =
                            doc["propertyData"]["title"] ?? "Unknown Property";
                        String mobileNum = doc["propertyData"]
                                ["contactDetails"] ??
                            "No Mobile Number";
                        String docId = doc["id"];
                        String name = doc["name"] ?? "Unknown Name";
                        String email = doc["email"] ?? "No Email";
                        String contact = doc["contact"] ?? "No Contact";
                        String description =
                            doc["description"] ?? "No Description";
                        Timestamp? createdAtTimestamp =
                            doc["timestamp"] as Timestamp?;
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          title ?? "Unknown Property",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () =>
                                            _deleteLegalDocument(docId),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          "Owner : $mobileNum" ??
                                              "Unknown Property",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Text("👤 Name: $name",
                                      style: const TextStyle(fontSize: 14)),
                                  Text("✉️ Email: $email",
                                      style: const TextStyle(fontSize: 14)),
                                  Text("📞 Contact: $contact",
                                      style: const TextStyle(fontSize: 14)),
                                  const SizedBox(height: 10),
                                  const Text(
                                    "📝 Description:",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    description,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.email,
                                            color: Colors.blue),
                                        onPressed: () => _sendEmail(email),
                                        tooltip: "Send Email",
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.phone,
                                            color: Colors.green),
                                        onPressed: () => _makeCall(contact),
                                        tooltip: "Make Call",
                                      ),
                                    ],
                                  ),
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
        ],
      ),
    );
  }
}
