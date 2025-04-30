import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';

import '../../Components/Choice_Chip.dart';
import '../../configs/app_colors.dart';

class AddPhotosDetailsPage extends StatefulWidget {
  final String docId; // 🔥 Pass this document ID when navigating

  const AddPhotosDetailsPage({Key? key, required this.docId}) : super(key: key);

  @override
  _AddPhotosDetailsPageState createState() => _AddPhotosDetailsPageState();
}

class _AddPhotosDetailsPageState extends State<AddPhotosDetailsPage> {
  File? _selectedImage;
  bool sendPhotosViaWhatsApp = false;
  int coveredParking = 0;
  int openParking = 0;
  bool isLoading = false;
  bool isApproved = false;

  final List<String> selectedRooms = [];
  final List<String> furnishingOptions = [
    "Unfurnished",
    "Semi-Furnished",
    "Furnished"
  ];
  String selectedFurnishing = "Unfurnished";
  final List<String> photos = []; // 🔥 Store image URLs here

  Future<void> saveToProperties() async {
    setState(() {
      isLoading = true; // Show loader
    });

    try {
      // 🔥 Get Current User
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not logged in.')),
        );
        return;
      }

      // 🔥 Fetch User Details from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        print("User document not found in AppUsers collection.");
        return;
      }

      String userId = userDoc['userId'] ?? "";
      String name = userDoc['name'] ?? "Unknown User";

      print("User Name: $name"); // Debugging purpose

      await FirebaseFirestore.instance
          .collection('AppProperties')
          .doc(widget.docId)
          .update({
        // 'photos': photos,
        'imageUrl':
            'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',
        'sendViaWhatsApp': sendPhotosViaWhatsApp,
        'isApproved': isApproved,
        'selectedRooms': selectedRooms,
        'furnishing': selectedFurnishing,
        'coveredParking': coveredParking,
        'openParking': openParking,
        'createdBy': userId,
        'ownerName': name,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          "Property details updated successfully!",
          style: TextStyle(
            fontFamily: AppFontFamily.primaryFont,
          ),
        )),
      );

      Navigator.pushNamed(
          context, AppRouts.dashBoard); // 🔥 Go back after submission
    } catch (e) {
      print("Error updating property: $e");
    } finally {
      setState(() {
        isLoading = false; // Hide loader
      });
    }
  }

  // Function to handle the selection/deselection of rooms
  void onSelectRoom(String room) {
    setState(() {
      if (selectedRooms.contains(room)) {
        selectedRooms.remove(room); // Deselect the room
      } else {
        selectedRooms.add(room); // Select the room
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Choose Image Source",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                icon: Icon(Icons.camera_alt, color: Colors.white),
                label: Text("Camera",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                icon: Icon(Icons.photo, color: Colors.white),
                label: Text("Gallery",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Photos & Details',
          style: TextStyle(
            fontFamily: AppFontFamily.primaryFont,
          ),
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

                  // 🔥 Image Upload Box
                  GestureDetector(
                      onTap: () {
                        // Implement Image Picker Logic
                      },
                      child: GestureDetector(
                        onTap: () => _showImageSourceDialog(context),

                        // onTap: () {
                        //
                        //     print("Container clicked. Open photo picker.");
                        //  },
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade100,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt,
                                  size: 40, color: Colors.grey),
                              const SizedBox(height: 8),
                              Text("+ Add at least 5 photos",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: AppFontFamily.primaryFont,
                                  )),
                              Text("Click from camera or browse to upload",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: AppFontFamily.primaryFont,
                                  )),
                            ],
                          ),
                        ),
                      )),

                  const SizedBox(height: 8),
                  Text(
                      "Upload up to 50 photos of max size 10 MB in PNG, JPG, JPEG format.",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontFamily: AppFontFamily.primaryFont,
                      )),

                  // 🔥 WhatsApp Checkbox
                  CheckboxListTile(
                    title: Text(
                      "I will send photos over WhatsApp",
                      style: TextStyle(
                        fontFamily: AppFontFamily.primaryFont,
                      ),
                    ),
                    value: sendPhotosViaWhatsApp,
                    onChanged: (bool? value) {
                      setState(() {
                        sendPhotosViaWhatsApp = value!;
                      });
                    },
                  ),

                  Text("With your registered number 91-9454310605",
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: AppFontFamily.primaryFont,
                      )),

                  const SizedBox(height: 16),

                  // 🔥 Other Rooms Selection
                  Text("Other rooms (Optional)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFontFamily.primaryFont,
                      )),
                  Wrap(
                    spacing: 8,
                    children:
                        ["Pooja Room", "Study Room", "Servant Room", "Others"]
                            .map((option) => ChoiceChipOption(
                                  label: option,
                                  isSelected: selectedRooms.contains(option),
                                  onSelected: (selected) {
                                    onSelectRoom(option);
                                  },
                                ))
                            .toList(),
                  ),

                  const SizedBox(height: 16),

                  // 🔥 Furnishing Selection
                  Text("Furnishing (Optional)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFontFamily.primaryFont,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: furnishingOptions.map((option) {
                      return ChoiceChipOption(
                        label: option,
                        isSelected: selectedFurnishing == option,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              selectedFurnishing = option;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // 🔥 Parking Section
                  Text("Reserved Parking (Optional)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFontFamily.primaryFont,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Covered Parking",
                        style: TextStyle(
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      Row(
                        children: [
                          _buildCounterButton(
                              () => setState(() => coveredParking--),
                              Icons.remove,
                              coveredParking > 0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text("$coveredParking",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppFontFamily.primaryFont,
                                )),
                          ),
                          _buildCounterButton(
                              () => setState(() => coveredParking++),
                              Icons.add,
                              true),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Open Parking",
                        style: TextStyle(
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      Row(
                        children: [
                          _buildCounterButton(
                              () => setState(() => openParking--),
                              Icons.remove,
                              openParking > 0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text("$openParking",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppFontFamily.primaryFont,
                                )),
                          ),
                          _buildCounterButton(
                              () => setState(() => openParking++),
                              Icons.add,
                              true),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 🔥 Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: saveToProperties,
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shadowColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ), // Make sure to call the saveToFirestore function

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
            if (isLoading)
              const Center(
                  child:
                      CircularProgressIndicator()), // 🔥 Show loader while saving
          ],
        ),
      ),
    );
  }

  Widget _buildCounterButton(
      VoidCallback onPressed, IconData icon, bool enabled) {
    return IconButton(
        icon: Icon(icon),
        onPressed: enabled ? onPressed : null,
        color: enabled ? AppColors.primary : Colors.grey);
  }
}
