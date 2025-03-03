import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usdinfra/conigs/app_colors.dart';
import '../Customs/CustomAppBar.dart';
import '../Customs/custom_textfield.dart';
import '../authentication/login_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  File? _selectedImage;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();

  Map<String, dynamic>? userData;
  bool isLoading = true;
  bool isEditable = false;

  @override
  void initState() {
    super.initState();
    _checkUserLoggedIn();
  }

  Future<void> _checkUserLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await _fetchUserData(user);
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData(User user) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.uid)
          .get();
      DocumentSnapshot profileDoc = await FirebaseFirestore.instance
          .collection('AppProfileSetup')
          .doc(user.uid)
          .get();
      if (userDoc.exists || profileDoc.exists) {
        setState(() {
          userData = {
            'name': userDoc.exists ? userDoc['name'] : null,
            'email': userDoc.exists ? userDoc['email'] : null,
            'mobile': userDoc.exists ? userDoc['mobile'] : null,
            'addressLine1':
                profileDoc.exists ? profileDoc['addressLine1'] : null,
            'addressLine2':
                profileDoc.exists ? profileDoc['addressLine2'] : null,
          };
          nameController.text = userDoc.exists ? userDoc['name'] : '';
          emailController.text = userDoc.exists ? userDoc['email'] : '';
          mobileController.text = userDoc.exists ? userDoc['mobile'] : '';
          addressLine1Controller.text =
              profileDoc.exists ? profileDoc['addressLine1'] : '';
          addressLine2Controller.text =
              profileDoc.exists ? profileDoc['addressLine2'] : '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateUserData() async {
    try {
      setState(() {
        isLoading = true;
      });
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && userData != null) {
        await FirebaseFirestore.instance
            .collection('AppUsers')
            .doc(user.uid)
            .update({
          'name': nameController.text,
          'email': emailController.text,
          'mobile': mobileController.text,
        });
        DocumentReference profileDocRef = FirebaseFirestore.instance
            .collection('AppProfileSetup')
            .doc(user.uid);

        DocumentSnapshot profileDoc = await profileDocRef.get();
        if (!profileDoc.exists) {
          await profileDocRef.set({
            'addressLine1': addressLine1Controller.text,
            'addressLine2': addressLine2Controller.text,
          });
        } else {
          await profileDocRef.update({
            'addressLine1': addressLine1Controller.text,
            'addressLine2': addressLine2Controller.text,
          });
        }

        setState(() {
          isEditable = false;
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile updated successfully")),
        );
      }
    } catch (e) {
      print("Error updating user data: $e");
      setState(() {
        isLoading = false;
      });
    }
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
          title: Text("Choose Image Source"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                icon: Icon(Icons.camera_alt, color: Colors.white),
                label: Text("Camera", style: TextStyle(color: Colors.white)),
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
                label: Text("Gallery", style: TextStyle(color: Colors.white)),
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

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Log Out"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Profile Page'),
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
                const Text(
                  'You need to log in to view your Profile.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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
                  child: const Text(
                    'Log In',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          width: double.infinity,
          height:
              MediaQuery.of(context).size.height * 0.33, // 35% of screen height
          padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondry],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: Colors.white),
                    onPressed: () => _logout(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(context),
                    child: ClipOval(
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              'https://holmesbuilders.com/wp-content/uploads/2016/12/male-profile-image-placeholder.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: -18,
                    right: 5,
                    child: Container(
                      // padding: EdgeInsets.only(left: 8, right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30), 
                        color: Colors.white, // Background color for contrast
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => _showImageSourceDialog(context),
                        icon: Icon(Icons.edit, color: AppColors.primary),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 15),
              Text(
                userData?['name'] ?? 'Guest',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    // color: Colors.primary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomInputField(
                                  controller: emailController,
                                  hintText: 'Email',
                                  enable: isEditable,
                                  borderRadius: 25,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mobile',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    // color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomInputField(
                                  controller: mobileController,
                                  hintText: 'Mobile',
                                  enable: isEditable,
                                  borderRadius: 25,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address Line 1',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    // color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomInputField(
                                  controller: addressLine1Controller,
                                  hintText: 'Address Line 1',
                                  enable: isEditable,
                                  borderRadius: 25,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Address Line 2',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    // color: AppColors.primary,
                                  ),
                                ),
                                SizedBox(height: 8),
                                CustomInputField(
                                  controller: addressLine2Controller,
                                  hintText: 'Address Line 2',
                                  enable: isEditable,
                                  borderRadius: 25,
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            isEditable
                                ? SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: _updateUserData,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: isLoading
                                          ? CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppColors.primary),
                                            )
                                          : Text("Save Changes"),
                                    ),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          isEditable = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text("Edit Profile"),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ])),
        ),
      ]),
    );
  }
}
