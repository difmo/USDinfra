import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usdinfra/conigs/app_colors.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../authentication/login_screen.dart'; // Import Login Page

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<DocumentSnapshot?>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildDefaultHeader(true);
              }
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  !snapshot.data!.exists) {
                return _buildDefaultHeader(false);
              }
              var userData =
                  snapshot.data!.data() as Map<String, dynamic>? ?? {};
              return _buildUserHeader(userData);
            },
          ),

          // Drawer Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10),
              children: [
                _buildDrawerItem(
                    Icons.dashboard, 'Dashboard', AppRouts.dashBoard, context),
                _buildDrawerItem(
                    Icons.person_outline, 'Profile', AppRouts.profile, context),
                _buildDrawerItem(Icons.apartment, 'Published Properties',
                    AppRouts.properties, context),
                _buildDrawerItem(Icons.shopping_bag, 'Purchased Properties',
                    AppRouts.properties, context),
                _buildDrawerItem(
                    Icons.info_outline, 'About Us', AppRouts.aboutus, context),
                _buildDrawerItem(Icons.contact_mail_outlined, 'Contact Us',
                    AppRouts.contactus, context),
                _buildDrawerItem(Icons.lock_outline, 'Privacy Policy',
                    AppRouts.privacy, context),
                _buildDrawerItem(Icons.rule, 'Terms & Conditions',
                    AppRouts.termconsition, context),
                Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                    indent: 20,
                    endIndent: 20),
                _buildLogoutItem(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fetch user data from Firestore
  Future<DocumentSnapshot?> _fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('AppUsers').doc(uid).get();
  }

  // Default Header (if no user data is found)
  Widget _buildDefaultHeader(bool isLoading) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(color: AppColors.primary),
      child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Guest User',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const Text('guest@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
    );
  }

  // User Header with Firestore Data
  Widget _buildUserHeader(Map<String, dynamic>? userData) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(color: AppColors.primary),
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userData?['profileImage'] ??
                  'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/man-person-icon.png'
              ),
              backgroundColor: Colors.white,
            ),
            const SizedBox(height: 10),
            Text(
              userData?['name'] ?? 'Unknown User',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              userData?['email'] ?? 'No Email',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer Menu Item
  Widget _buildDrawerItem(
      IconData icon, String title, String? route, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 26),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      onTap: () {
        Navigator.pop(context);
        if (route != null && route.isNotEmpty) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  // Logout Menu Item
  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red, size: 26),
      title: const Text(
        "Logout",
        style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
      ),
      onTap: () => _logout(context),
    );
  }

  // Logout Confirmation Dialog
 void _logout(BuildContext context) {
  showDialog(
    // backgroundColor: colors.white,
    context: context,
    barrierDismissible: false, // Prevent accidental dismissal
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.logout, color: Colors.redAccent),
          SizedBox(width: 8),
          Text("Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: Text(
        "Are you sure you want to log out?",
        style: TextStyle(fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
ElevatedButton(
  style:ElevatedButton.styleFrom(
    backgroundColor: AppColors.secondry,
                foregroundColor: Colors.white,
shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
  ),
         onPressed: () => Navigator.of(ctx).pop(),
          child: Text("Cancel", style: TextStyle(color: Colors.black87)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Text("Log Out"),
        ),
      ],
    ),
  );
}
}
