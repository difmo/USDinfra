import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../../configs/app_colors.dart';
import 'form_page_3_components/image_upload.dart';
import 'form_page_3_components/option_chip.dart';

class AddPhotosDetailsPage extends StatefulWidget {
  final String docId;

  const AddPhotosDetailsPage({Key? key, required this.docId}) : super(key: key);

  @override
  _AddPhotosDetailsPageState createState() => _AddPhotosDetailsPageState();
}

class _AddPhotosDetailsPageState extends State<AddPhotosDetailsPage> {
  bool sendPhotosViaWhatsApp = false;
  int coveredParking = 0;
  int openParking = 0;
  bool isLoading = false;
  bool isApproved = false;

  final List<String> selectedAmenities = [];
  List<String> selectedRooms = [];
  List<String> selectedDirection =[];
  List<String> selectedFoodcourt = [];
  final List<String> furnishingOptions = [];
  List<File> selectedImages = [];
  List<String> uploadedImageUrls = [];

  Future<List<String>> uploadImagesToFirebase(
      List<File> images, String docId) async {
    List<String> uploadedImageUrls = [];

    for (int i = 0; i < images.length; i++) {
      final image = images[i];
      final fileName =
          'property_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';

      final ref = FirebaseStorage.instance
          .ref()
          .child('property_images')
          .child(docId)
          .child(fileName);

      final uploadTask = ref.putFile(image);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      uploadedImageUrls.add(downloadUrl);
    }

    return uploadedImageUrls;
  }

  Future<void> saveToProperties() async {
    setState(() {
      isLoading = true;
    });

    // ✅ Basic Validations
    if (selectedImages.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image.')),
      );
      return;
    }

    if (selectedDirection.isEmpty) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select property facing direction.')),
      );
      return;
    }

    try {
      // 🔥 Get current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

      // 🔥 Get user info
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User details not found.')),
        );
        return;
      }

      String userId = userDoc['userId'] ?? '';
      String name = userDoc['name'] ?? 'Unknown User';

      // ✅ Upload Images and get URLs
      List<String> uploadedImageUrls =
          await uploadImagesToFirebase(selectedImages, widget.docId);

      // ✅ Save all details to Firestore
      await FirebaseFirestore.instance
          .collection('AppProperties')
          .doc(widget.docId)
          .update({
        'imageUrl': uploadedImageUrls.isNotEmpty
            ? uploadedImageUrls
            : [
                'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok='
              ],
        'sendViaWhatsApp': sendPhotosViaWhatsApp,
        'isApproved': isApproved,
        'facing': selectedDirection,
        'selectedRooms': selectedRooms,
        'amenities': selectedAmenities,
        'furnishing': furnishingOptions,
        'foodcourt': selectedFoodcourt,
        'coveredParking': coveredParking,
        'openParking': openParking,
        'createdBy': userId,
        'ownerName': name,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Property details updated successfully!")),
      );

      Navigator.pushNamed(context, AppRouts.dashBoard);
    } catch (e) {
      print("Error updating property: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onSelectRoom(String room) {
    setState(() {
      if (selectedRooms.contains(room)) {
        selectedRooms.remove(room);
      } else {
        selectedRooms.add(room);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Photos & Details',
          style: TextStyle(fontFamily: AppFontFamily.primaryFont),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("STEP 3 OF 3",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: AppFontFamily.primaryFont,
                      )),
                  const SizedBox(height: 8),
                  Text("Add property photos (Optional)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFontFamily.primaryFont,
                      )),
                  const SizedBox(height: 8),
                  MultiImageUploadBox(
                    onImagesSelected: (List<File> images) {
                      setState(() {
                        selectedImages = images;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Upload up to 50 photos of max size 10 MB in PNG, JPG, JPEG format.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                  ChoiceSelectorWidget(
                    title: "Property Facing",
                    options: [
                      "East",
                      "West",
                      "North",
                      "South",
                      "North East",
                      "North West",
                      "South East",
                      "South West",
                    ],
                    selectedOptions: selectedDirection,
                    onSelectionChanged: (facing) {
                      setState(() {
                        selectedDirection = facing;
                      });
                    },
                    isMultiSelect: false,
                  ),
                  const SizedBox(height: 16),
                  ChoiceSelectorWidget(
                    title: "Other rooms (Optional)",
                    options: [
                      "Pooja Room",
                      "Study Room",
                      "Servant Room",
                      "Others"
                    ],
                    selectedOptions: selectedRooms,
                    onSelectionChanged: (rooms) {
                      setState(() {
                        selectedRooms = rooms;
                      });
                    },
                    isMultiSelect: true,
                  ),
                  const SizedBox(height: 16),
                  ChoiceSelectorWidget(
                    title: "Amenities (Feature of Society)",
                    options: [
                      "24 x 7 Security",
                      "Clubhouse",
                      "Balcony",
                      "High Speed Elevators",
                      "Preschool",
                      "Medical Facility",
                      "Day Care Center",
                      "Pet Area",
                      "Indoor Games",
                      "Conference Room",
                      "Large Green Area",
                      "Concierge Desk",
                      "Helipad",
                      "Golf Course",
                      "Multiplex",
                      "Visitor's Parking",
                      "Serviced Apartments",
                      "Service Elevators",
                      "High Street Retail",
                      "Hypermarket",
                      "ATM'S",
                    ],
                    selectedOptions: selectedAmenities,
                    onSelectionChanged: (amenities) {
                      setState(() {
                        selectedAmenities.clear();
                        selectedAmenities.addAll(amenities);
                      });
                    },
                    isMultiSelect: true,
                  ),
                  const SizedBox(height: 16),
                  ChoiceSelectorWidget(
                    title: "Food Court",
                    options: [
                      "Food Court",
                      "Servant Quarter",
                      "Study Room",
                      "Private Pool",
                      "Private Gym",
                      "Private Jacuzzi",
                      "View of Water",
                      "View of Landmark",
                      "Built in Wardrobes",
                      "Walk-in Closet",
                      "Lobby in Building",
                      "Double Glazed Windows",
                      "Centrally Air-Conditioned",
                      "Central Heating",
                      "Day Care Center",
                      "Electricity Backup",
                      "Waste Disposal",
                      "First Aid Medical Center",
                      "Tiles",
                      "Service Elevators",
                      "Broadband Internet",
                    ],
                    selectedOptions: selectedFoodcourt,
                    onSelectionChanged: (foodcourt) {
                      setState(() {
                        selectedFoodcourt = foodcourt;
                      });
                    },
                    isMultiSelect: true,
                  ),
                  const SizedBox(height: 16),
                  ChoiceSelectorWidget(
                    title: "Furnishing (Optional)",
                    options: ["Unfurnished", "Semi-Furnished", "Furnished"],
                    selectedOptions: furnishingOptions,
                    onSelectionChanged: (furnishing) {
                      setState(() {
                        furnishingOptions.clear();
                        furnishingOptions.addAll(furnishing);
                      });
                    },
                    isMultiSelect: false,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveToProperties,
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shadowColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Save Property",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading) const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
