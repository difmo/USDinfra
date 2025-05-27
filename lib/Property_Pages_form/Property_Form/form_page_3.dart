import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/controllers/user_controller.dart';
import 'package:usdinfra/model/user_modal.dart';
import 'package:usdinfra/routes/app_routes.dart';
import 'package:usdinfra/utils/constants.dart';
import '../../configs/app_colors.dart';
import 'form_page_3_components/image_upload.dart';
import 'form_page_3_components/option_chip.dart';

class AddPhotosDetailsPage extends StatefulWidget {
  final String docId;

  const AddPhotosDetailsPage({super.key, required this.docId});

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
  List<String> selectedDirection = [];
  List<String> selectedFoodcourt = [];
  List<String> selectedFurnishing = [];
  Map<String, int> furnishingQuantities = {
    "Light": 0,
    "Fans": 0,
    "AC": 0,
    "TV": 0,
    "Beds": 0,
    "Wardrobe": 0,
    "Geyser": 0,
    "Sofa": 0,
    "Washing Machine": 0,
    "Stove": 0,
    "Fridge": 0,
    "Water Purifier": 0,
    "Microwave": 0,
    "Modular Kitchen": 0,
    "Chimney": 0,
    "Dining Table": 0,
    "Curtains": 0,
    "Exhaust Fan": 0,
  };
  List<File> selectedImages = [];
  List<String> uploadedImageUrls = [];
  UserController _userController = UserController();

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
    UserModel? userdata = await _userController.fetchCurrentUserData();
    setState(() {
      isLoading = true;
    });

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
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
        return;
      }

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

      List<String> uploadedImageUrls =
          await uploadImagesToFirebase(selectedImages, widget.docId);

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
        'furnishing': selectedFurnishing,
        'furnishingDetails': furnishingQuantities,
        'foodcourt': selectedFoodcourt,
        'coveredParking': coveredParking,
        'openParking': openParking,
        'createdBy': userId,
        'ownerName': name,
        'dealerType': userdata?.dealerType,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Property details updated successfully!")),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouts.dashBoard,
        (route) => isApproved,
      );
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

  void _showFurnishingDetailsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(34))),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Text(
                        "Add Furnishing Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "* Atleast one selection is mandatory",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          children: furnishingQuantities.keys.map((item) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppFontFamily.primaryFont,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setModalState(() {
                                            if (furnishingQuantities[item]! >
                                                0) {
                                              furnishingQuantities[item] =
                                                  furnishingQuantities[item]! -
                                                      1;
                                            }
                                          });
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                      Text(
                                        "${furnishingQuantities[item]}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setModalState(() {
                                            furnishingQuantities[item] =
                                                furnishingQuantities[item]! + 1;
                                          });
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              setModalState(() {
                                furnishingQuantities
                                    .updateAll((key, value) => 0);
                              });
                              setState(() {});
                            },
                            child: Text(
                              "Clear All",
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: AppFontFamily.primaryFont,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              bool hasSelection = furnishingQuantities.values
                                  .any((quantity) => quantity > 0);
                              if (!hasSelection) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please select at least one furnishing item."),
                                  ),
                                );
                                return;
                              }
                              Navigator.pop(context);
                              setState(
                                  () {}); // Refresh the parent state to show selected items
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "SUBMIT",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: AppFontFamily.primaryFont,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  // Widget to display selected furnishing items with quantities
  Widget _buildSelectedFurnishingItems() {
    // Filter items with quantity > 0
    final selectedItems = furnishingQuantities.entries
        .where((entry) => entry.value > 0)
        .map((entry) => "${entry.key}: ${entry.value}")
        .toList();

    if (selectedItems.isEmpty) {
      return const SizedBox
          .shrink(); // Don't show anything if no items are selected
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Selected Furnishing Items:",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedItems
                .map(
                  (item) => Chip(
                    label: Text(
                      item,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppFontFamily.primaryFont,
                      ),
                    ),
                    backgroundColor: Colors.grey[200],
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
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
                  Text(
                    "STEP 3 OF 3",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add property photos (Optional)",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
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
                    options: AppConstants.PropertyFacing,
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
                    title: "Furnishing (Optional)",
                    options: ["Unfurnished", "Semi-Furnished", "Furnished"],
                    selectedOptions: selectedFurnishing,
                    onSelectionChanged: (furnishing) {
                      setState(() {
                        selectedFurnishing.clear();
                        selectedFurnishing.addAll(furnishing);
                        if (furnishing.contains("Furnished") ||
                            furnishing.contains("Semi-Furnished")) {
                          _showFurnishingDetailsBottomSheet();
                        } else {
                          furnishingQuantities.updateAll((key, value) => 0);
                        }
                      });
                    },
                    isMultiSelect: false,
                  ),
                  _buildSelectedFurnishingItems(),

                  const SizedBox(height: 16),
                  ChoiceSelectorWidget(
                    title: "Amenities (Feature of Society)",
                    options: AppConstants.otherRoomOptions1,
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
                      "Electric Backup",
                      "Fire Alarm",
                      "Fire Safety",
                    ],
                    selectedOptions: selectedFoodcourt,
                    onSelectionChanged: (foodcourt) {
                      setState(() {
                        selectedFoodcourt = foodcourt;
                      });
                    },
                    isMultiSelect: true,
                  ),

                  // Display selected furnishing items
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
