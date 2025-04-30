import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/Components/logout.dart';
import 'package:usdinfra/Components/user_not_login.dart';
import 'package:usdinfra/Customs/CustomAppBar.dart';
import 'package:usdinfra/Userpages/edit_profie.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../Customs/custom_textfield.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'mobile': TextEditingController(),
    'addressLine1': TextEditingController(),
    'addressLine2': TextEditingController(),
  };

  final Map<String, IconData> fieldIcons = {
    'email': Icons.email,
    'mobile': Icons.phone,
    'addressLine1': Icons.home,
    'addressLine2': Icons.location_city,
  };
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    if (user != null) _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user!.uid)
          .get();
      final profileDoc = await FirebaseFirestore.instance
          .collection('AppProfileSetup')
          .doc(user!.uid)
          .get();

      if (userDoc.exists || profileDoc.exists) {
        setState(() {
          userData = {
            'name': userDoc.exists ? userDoc['name'] : '',
            'email': userDoc.exists ? userDoc['email'] : '',
            'mobile': userDoc.exists ? userDoc['mobile'] : '',
            'addressLine1': profileDoc.exists ? profileDoc['addressLine1'] : '',
            'addressLine2': profileDoc.exists ? profileDoc['addressLine2'] : '',
            'profileImageUrl':
                profileDoc.exists ? profileDoc['profileImageUrl'] : '',
          };
          controllers.forEach(
              (key, controller) => controller.text = userData?[key] ?? '');
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching user data: $e");
      setState(() => isLoading = false);
    }
  }

  Widget _buildShimmerBox(
      {double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    if (isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: CircleAvatar(radius: 50, backgroundColor: Colors.grey.shade300),
      );
    }

    String? profileImageUrl = userData?['profileImageUrl'];
    String nameInitial = (userData?['name'] ?? 'G').isNotEmpty
        ? userData!['name'][0].toUpperCase()
        : 'G';

    return GestureDetector(
        onTap: () {
          if (userData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfilePage(userData: userData!),
              ),
            );
          }
        },
        child: ClipOval(
          child: profileImageUrl != null && profileImageUrl.isNotEmpty
              ? Image.network(
                  profileImageUrl,
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) =>
                      loadingProgress == null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 130, // Adjusted size
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                )
              : Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    nameInitial,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
        ));
  }

  Widget _buildProfileField(String label, String key) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      isLoading
          ? _buildShimmerBox(width: 100, height: 16)
          : Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFontFamily.primaryFont)),
      const SizedBox(height: 8),
      isLoading
          ? _buildShimmerBox(height: 50)
          : CustomInputField(
              controller: controllers[key]!,
              prefixIcon: Icon(fieldIcons[key], color: Colors.black),
              enable: false,
              prefixIconDisabledColor: Colors.black,
              borderRadius: 10,
            ),
      const SizedBox(height: 20),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return UserNotLoggedIn();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Profile'),
        body: Column(
          children: [
            const SizedBox(height: 20),
            Stack(clipBehavior: Clip.none, children: [
              _buildProfileImage(),
              Positioned(
                bottom: -18,
                right: 15,
                child: isLoading
                    ? _buildShimmerBox(width: 60, height: 30)
                    : ElevatedButton.icon(
                        onPressed: () {
                          if (userData != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfilePage(userData: userData!),
                              ),
                            );
                          }
                        },
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
            const SizedBox(height: 15),
            isLoading
                ? _buildShimmerBox(width: 150, height: 28)
                : Text(userData?['name'] ?? 'Guest',
                    style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileField('Email', 'email'),
                      _buildProfileField('Mobile', 'mobile'),
                      _buildProfileField('Address Line 1', 'addressLine1'),
                      _buildProfileField('Address Line 2', 'addressLine2'),
                    ]),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: SizedBox(
                width: double.infinity, // Makes the button take full width
                child: ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LogoutDialog();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14), // Better height
                  ),
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Logout",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
