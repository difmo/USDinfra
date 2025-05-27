import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../authentication/login_screen.dart'; // Import Login Page

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData(); // Fetch user data once
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
        ),
      ),
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: _userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerHeader();
              }
              if (!snapshot.hasData || snapshot.data == null) {
                return _buildDefaultHeader(false);
              }
              return _buildUserHeader(snapshot.data!);
            },
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: _userDataFuture,
              builder: (context, snapshot) {
                String role = (snapshot.hasData && snapshot.data != null)
                    ? snapshot.data!['role'] ?? "user"
                    : "user";
                return _buildDrawerList(context, role: role);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<Map<String, dynamic>?> _fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    try {
      // Fetch user data from both collections concurrently
      List<DocumentSnapshot> results = await Future.wait([
        FirebaseFirestore.instance.collection('AppUsers').doc(uid).get(),
        FirebaseFirestore.instance.collection('AppProfileSetup').doc(uid).get(),
      ]);

      // Extract data
      Map<String, dynamic> userData =
          (results[0].data() as Map<String, dynamic>?) ?? {};
      Map<String, dynamic> profileData =
          (results[1].data() as Map<String, dynamic>?) ?? {};

      // Merge data (profileData takes priority)
      return {
        ...userData,
        ...profileData,
      };
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Widget _buildDrawerList(BuildContext context, {required String role}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        children: [
          _buildDrawerItem(
              Icons.dashboard, 'Dashboard', AppRouts.dashBoard, context),
          _buildDrawerItem(
              Icons.person_outline, 'Profile', AppRouts.profile, context),
          _buildDrawerItem(Icons.apartment, 'Published Property',
              AppRouts.myPropertiesPage, context),
          _buildDrawerItem(Icons.favorite_border_outlined,
              'Favorite Properties', AppRouts.favoritePropertiesPage, context),
          _buildDrawerItem(Icons.shopping_bag, 'Purchased Properties',
              AppRouts.purchesedProperties, context),
          _buildDrawerItem(
              Icons.info_outline, 'About Us', AppRouts.aboutus, context),
          _buildDrawerItem(Icons.contact_mail_outlined, 'Contact Us',
              AppRouts.contactus, context),
          _buildDrawerItem(
              Icons.lock_outline, 'Privacy Policy', AppRouts.privacy, context),
          _buildDrawerItem(Icons.rule, 'Terms & Conditions',
              AppRouts.termconsition, context),
          if (role == "isAdmin")
            _buildDrawerItem(Icons.admin_panel_settings_outlined, 'Admin',
                AppRouts.adminProperty, context),
          Divider(
              color: Colors.grey[300], thickness: 1, indent: 20, endIndent: 20),
          _buildLogoutItem(context),
        ],
      ),
    );
  }

  Widget _buildUserHeader(Map<String, dynamic>? userData) {
    String name = userData?['name'] ?? 'Guest User';
    String email = userData?['email'] ?? 'guest@example.com';
    String? profileImageUrl = userData?['profileImageUrl'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage:
                  profileImageUrl != null && profileImageUrl.isNotEmpty
                      ? NetworkImage(profileImageUrl)
                      : null,
              child: profileImageUrl == null || profileImageUrl.isEmpty
                  ? Text(
                      name[0].toUpperCase(), // Show first letter in uppercase
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: AppFontFamily.primaryFont,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
            Text(
              email,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultHeader(bool buildShimmerLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: buildShimmerLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                const SizedBox(height: 10),
                Text(
                  'Guest User',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ),
                Text('guest@example.com',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontFamily: AppFontFamily.primaryFont,
                    )),
              ],
            ),
    );
  }

  // Shimmer effect for the header section while loading
  Widget _buildShimmerHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(color: Colors.grey[100]),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 120,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 5),
            Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red, size: 26),
      title: Text("Logout",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.red,
            fontFamily: AppFontFamily.primaryFont,
          )),
      onTap: () => _logout(context),
    );
  }

  Widget _buildDrawerItem(
      IconData icon, String title, String? route, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Adjust padding as required
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          if (route != null && route.isNotEmpty) {
            Navigator.pushNamed(context, route);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0, vertical: 1), // Custom padding
          child: Row(
            children: [
              Icon(icon, color: Colors.grey[400], size: 26), // Icon on the left
              const SizedBox(width: 20), // Spacing between icon and title
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontFamily: AppFontFamily.primaryFont,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.redAccent),
            SizedBox(width: 8),
            Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text("Are you sure you want to log out?",
            style: TextStyle(fontSize: 16)),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondry,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel", style: TextStyle(color: Colors.black87)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
