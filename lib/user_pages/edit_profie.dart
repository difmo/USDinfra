import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/Customs/custom_textfield.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController mobileController;
  late TextEditingController addressLine1Controller;
  late TextEditingController addressLine2Controller;

  String? profileImageUrl;
  File? _selectedImage;
  bool isLoading = false;
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'mobile': TextEditingController(),
    'addressLine1': TextEditingController(),
    'addressLine2': TextEditingController(),
  };
  final Map<String, IconData> fieldIcons = {
    'name': Icons.person,
    'email': Icons.email,
    'mobile': Icons.phone,
    'addressLine1': Icons.home,
    'addressLine2': Icons.location_city,
  };
  @override
  void initState() {
    super.initState();
    controllers['name'] = TextEditingController(text: widget.userData['name']);
    controllers['email'] =
        TextEditingController(text: widget.userData['email']);
    controllers['mobile'] =
        TextEditingController(text: widget.userData['mobile']);
    controllers['addressLine1'] =
        TextEditingController(text: widget.userData['addressLine1']);
    controllers['addressLine2'] =
        TextEditingController(text: widget.userData['addressLine2']);

    profileImageUrl = widget.userData['profileImageUrl'];
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    super.dispose();
  }

  Widget _buildProfileField(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: AppFontFamily.primaryFont,
          ),
        ),
        const SizedBox(height: 8),
        CustomInputField(
          controller: controllers[key]!,
          prefixIcon: Icon(fieldIcons[key], color: Colors.black),
          enable: !isLoading,
          prefixIconDisabledColor: Colors.black,
          borderRadius: 10,
          disabledBorderColor: Colors.black,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      String uid = user.uid;
      String? newImageUrl;

      if (_selectedImage != null) {
        final ref =
            FirebaseStorage.instance.ref().child('profile_images/$uid.jpg');
        await ref.putFile(_selectedImage!);
        newImageUrl = await ref.getDownloadURL();
        setState(() {
          profileImageUrl = newImageUrl;
        });
      }
      Map<String, dynamic> updatedData = {
        'name': controllers['name']!.text.trim(),
        'email': controllers['email']!.text.trim(),
        'mobile': controllers['mobile']!.text.trim(),
        'addressLine1': controllers['addressLine1']!.text.trim(),
        'addressLine2': controllers['addressLine2']!.text.trim(),
        'profileImageUrl': newImageUrl ?? profileImageUrl,
      };

      await FirebaseFirestore.instance.collection('AppUsers').doc(uid).update({
        'name': updatedData['name'],
        'email': updatedData['email'],
        'mobile': updatedData['mobile'],
      });

      await FirebaseFirestore.instance
          .collection('AppProfileSetup')
          .doc(uid)
          .update({
        'addressLine1': updatedData['addressLine1'],
        'addressLine2': updatedData['addressLine2'],
        'profileImageUrl': updatedData['profileImageUrl'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context, updatedData);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          title: Text("Choose Profile Image",
              style: TextStyle(fontFamily: AppFontFamily.primaryFont)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: Text("Camera",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFontFamily.primaryFont)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                icon: const Icon(Icons.photo, color: Colors.white),
                label: Text("Gallery",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: AppFontFamily.primaryFont)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(clipBehavior: Clip.none, children: [
                    GestureDetector(
                      onTap: () => _showImageSourceDialog(context),
                      child: Container(
                        width: 130, // Set size
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey, // Background color
                          image: _selectedImage != null
                              ? DecorationImage(
                                  image: FileImage(_selectedImage!),
                                  fit: BoxFit.cover,
                                )
                              : (profileImageUrl != null &&
                                      profileImageUrl!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(profileImageUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null), // No image case
                        ),
                        alignment: Alignment.center, // Center the text
                        child: (_selectedImage == null &&
                                (profileImageUrl == null ||
                                    profileImageUrl!.isEmpty))
                            ? Text(
                                widget.userData['name'] != null &&
                                        widget.userData['name'].isNotEmpty
                                    ? widget.userData['name'][0].toUpperCase()
                                    : '?', // Show first letter or fallback
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // Make text visible
                                ),
                              )
                            : null, // Hide text when an image is present
                      ),
                    ),
                    Positioned(
                      bottom: -18,
                      right: 15,
                      child: ElevatedButton.icon(
                        onPressed: () => _showImageSourceDialog(context),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Colors.white,
                          shadowColor: Colors.black26,
                          elevation: 4,
                          minimumSize: const Size(100, 30),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                        ),
                        icon: const Icon(Icons.edit,
                            color: Color(0xFF133763), size: 18),
                        label: const Text("Edit",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xFF133763))),
                      ),
                    ),
                  ]),
                ],
              ),
              Column(
                children: [
                  const SizedBox(height: 10),
                  _buildProfileField('Name', 'name'),
                  _buildProfileField('Email', 'email'),
                  _buildProfileField('Mobile', 'mobile'),
                  _buildProfileField('Address Line 1', 'addressLine1'),
                  _buildProfileField('Address Line 2', 'addressLine2'),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateUserData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 3,
                    shadowColor: AppColors.shadow,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Save Changes',
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
