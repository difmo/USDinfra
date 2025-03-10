import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usdinfra/Controllers/authentication_controller.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../Customs/custom_textfield.dart';

class ProfilesetupPage extends StatefulWidget {
  const ProfilesetupPage({super.key});

  @override
  _ProfilesetupPageState createState() => _ProfilesetupPageState();
}

class _ProfilesetupPageState extends State<ProfilesetupPage> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  File? _selectedImage;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final controllers = ControllersManager();

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

  Future<void> _saveUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = '';
      if (_selectedImage != null) {
        final storageRef = _storage
            .ref()
            .child('profile_images/${DateTime.now().millisecondsSinceEpoch}');
        final uploadTask = storageRef.putFile(_selectedImage!);
        final taskSnapshot = await uploadTask.whenComplete(() {});
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      }

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await _firestore.collection('AppProfileSetup').doc(user.uid).set({
          'addressLine1': controllers.addressLine1Controller.text,
          'addressLine2': controllers.addressLine2Controller.text,
          'profileImageUrl':
              'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-person-icon.png',
          // 'profileImageUrl': imageUrl, // Saving the image URL
        });

        // Navigate to dashboard or the next screen
        Navigator.pushNamed(context, AppRouts.dashBoard);
      }
    } catch (e) {
      print('Error saving user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'An error occurred while saving data',
          style: TextStyle(
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        backgroundColor: AppColors.primary,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Stack(
                    clipBehavior: Clip.none, // Allowing the button to overlap
                    children: [
                      GestureDetector(
                        onTap: () => _showImageSourceDialog(context),
                        child: ClipOval(
                          child: _selectedImage != null
                              ? Image.file(
                                  _selectedImage!,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  'https://holmesbuilders.com/wp-content/uploads/2016/12/male-profile-image-placeholder.png',
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Positioned(
                        bottom: -10,
                        child: ElevatedButton(
                          onPressed: () => _showImageSourceDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: AppColors.shadow,
                          ),
                          child: Text(
                            "Upload Image",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontFamily: AppFontFamily.primaryFont,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address Line 1',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomInputField(
                    controller: controllers.addressLine1Controller,
                    hintText: "Address Line1",
                    borderRadius: 25,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Address Line 2',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                  SizedBox(height: 8),
                  CustomInputField(
                    controller: controllers.addressLine2Controller,
                    hintText: "Address Line2",
                    borderRadius: 25,
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveUserData,
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    shadowColor: AppColors.shadow,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                        )
                      : Text(
                          'Save & Next',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFontFamily.primaryFont,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
