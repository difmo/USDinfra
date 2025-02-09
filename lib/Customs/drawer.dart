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
          // Fetch and Display User Info
          FutureBuilder<DocumentSnapshot?>(
            future: _fetchUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildDefaultHeader(snapshot.connectionState == ConnectionState.waiting);
              }
              if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
                return _buildDefaultHeader(snapshot.connectionState == ConnectionState.waiting);
              }

              var userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
              return _buildUserHeader(userData);
            },
          ),

          // Drawer Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 10),
              children: [
                _buildDrawerItem(Icons.home, 'Home', AppRouts.dashBoard, context),
                _buildDrawerItem(Icons.person, 'Profile', AppRouts.profile, context),
                _buildDrawerItem(Icons.publish, 'Published Properties', AppRouts.properties, context),
                _buildDrawerItem(Icons.shopping_cart, 'Purchased Properties', AppRouts.properties, context),
                _buildDrawerItem(Icons.account_box_outlined, 'About Us', AppRouts.properties, context),
                _buildDrawerItem(Icons.contacts, 'Contact Us', AppRouts.properties, context),
                _buildDrawerItem(Icons.security, 'Privecy Policy', AppRouts.properties, context),
                _buildDrawerItem(Icons.policy, 'Term & Condition', AppRouts.properties, context),
                Divider(thickness: 1, indent: 20, endIndent: 20, color: Colors.grey[300]), // Divider for separation
                _buildLogoutItem(context), // Logout Item with Dialog

              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Fetch user data from Firestore (Nullable)
  Future<DocumentSnapshot?> _fetchUserData() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    return FirebaseFirestore.instance.collection('AppUsers').doc(uid).get();
  }

  // 🔹 Default Drawer Header (Loading State)
  // Widget _buildLoadingHeader() {
  //   return Container(
  //     width: double.infinity,
  //     padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
  //     decoration: BoxDecoration(
  //       color: AppColors.primary,
  //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
  //     ),
  //     child: Center(child: CircularProgressIndicator(color: Colors.white)),
  //   );
  // }

  // 🔹 Default Drawer Header (If No Data Found)
  Widget _buildDefaultHeader(bool isLoading) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: isLoading?CircularProgressIndicator():Column(
        children: [
          CircleAvatar(radius: 40, backgroundImage: AssetImage('assets/profile.jpg')),
          SizedBox(height: 10),
          Text('Guest User', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Text('guest@example.com', style: TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  // 🔹 Build User Header with Firestore Data (Nullable)
  Widget _buildUserHeader(Map<String, dynamic>? userData) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(userData?['profileImage'] ?? 'https://cce.guru/wp-content/uploads/2022/12/Hydrangeas.jpg'),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              userData?['name'] ?? 'Unknown User',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              userData?['email'] ?? 'No Email',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Custom Drawer Item Widget with Nullable Routes
  Widget _buildDrawerItem(IconData icon, String title, String? route, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 26),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (route != null && route.isNotEmpty) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  // 🔹 Logout Item (Opens Confirmation Dialog)
  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout, color: Colors.red, size: 26),
      title: Text(
        "Logout",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.red),
      ),
      onTap: () => _logout(context), // Show logout dialog
    );
  }

  // 🔹 Logout Confirmation Dialog
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
                MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to Login Page
              );
            },
            child: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
