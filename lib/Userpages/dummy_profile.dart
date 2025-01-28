// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import '../Controllers/authentication_controller.dart';
// import '../Customs/custom_textfield.dart';
// import '../authentication/login_screen.dart';
// import '../conigs/app_colors.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: 'Roboto',
//       ),
//       home: ProfilePage(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   File? _selectedImage;
//   final controllers = ControllersManager();
//
//   // Function to handle logout
//   void _logout(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) =>
//           AlertDialog(
//             title: Text(
//                 "Log Out", style: TextStyle(fontWeight: FontWeight.bold)),
//             content: Text("Are you sure you want to log out?"),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop(); // Close the dialog
//                 },
//                 child: Text("Cancel", style: TextStyle(color: Colors.grey)),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop(); // Close the dialog
//                   Navigator.of(context).pushReplacement(
//                     MaterialPageRoute(builder: (context) => LoginPage()),
//                   );
//                 },
//                 child: Text("Log Out", style: TextStyle(color: Colors.blue)),
//               ),
//             ],
//           ),
//     );
//   }
//
//   // Function to show image selection dialog
//   void _showImageSourceDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           backgroundColor: Colors.white,
//           title: Text("Choose Image Source"),
//           content: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.camera);
//                 },
//                 icon: Icon(Icons.camera_alt, color: Colors.white),
//                 label: Text("Camera", style: TextStyle(color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                 ),
//               ),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _pickImage(ImageSource.gallery);
//                 },
//                 icon: Icon(Icons.photo, color: Colors.white),
//                 label: Text("Gallery", style: TextStyle(color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // Function to pick image from camera or gallery
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: source); // Updated method
//
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile Page'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.exit_to_app),
//             onPressed: () => _logout(context),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Profile Header Section
//             Container(
//               width: double.infinity,
//               padding: EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.blueAccent,
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(30),
//                   bottomRight: Radius.circular(30),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // Using Stack to overlap the Edit button on top of the profile image
//                   Center(
//                     child: Stack(
//                       clipBehavior: Clip.none, // Allowing the button to overlap
//                       children: [
//                         GestureDetector(
//                           onTap: () => _showImageSourceDialog(context),
//                           child: ClipOval(
//                             child: _selectedImage != null
//                                 ? Image.file(
//                               _selectedImage!,
//                               width: 150,
//                               height: 150,
//                               fit: BoxFit.cover,
//                             )
//                                 : Image.network(
//                               'https://holmesbuilders.com/wp-content/uploads/2016/12/male-profile-image-placeholder.png',
//                               width: 150,
//                               height: 150,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                         // "Edit Image" Button positioned on top of the profile image
//                         Positioned(
//                           bottom: -10,
//                           left: 10,
//                           right: 10,
//                           child: ElevatedButton(
//                             onPressed: () => _showImageSourceDialog(context),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               elevation: 2,
//                               shadowColor: AppColors.shadow,
//                             ),
//                             child: Text(
//                               "Edit Image",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColors.primary,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'John Doe',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Text(
//                     'Creative Designer | Tech Enthusiast',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.white70,
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                 ],
//               ),
//             ),
//             // Name Field
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Name :',
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.primary)),
//                   SizedBox(height: 8),
//                   CustomInputField(
//                       controller: controllers.nameController,
//                       prefixIcon: Icon(Icons.person_2_outlined),
//                       hintText: 'Enter Name'),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Email Field
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Email :',
//                       style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                           color: AppColors.primary)),
//                   SizedBox(height: 8),
//                   CustomInputField(
//                       controller: controllers.emailController,
//                       prefixIcon: Icon(Icons.email_outlined),
//                       hintText: 'Enter your Email',
//                     suffixIcon: Icon(Icons.edit_outlined),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//
//             // Mobile Field
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                   Text('Mobile :',
//                   style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.primary)),
//               SizedBox(height: 8),
//               CustomInputField(
//                   controller: controllers.mobileController,
//                   prefixIcon: Icon(Icons.local_phone_outlined),
//                   hintText: 'Enter your Mobile Number',
//                   suffixIcon: Icon(Icons.edit_outlined),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 20),
//
//       // Password Field
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Addres Line 1 :',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.primary)),
//             SizedBox(height: 8),
//             CustomInputField(
//               controller: controllers.addressLine1Controller,
//               prefixIcon: Icon(Icons.lock),
//               hintText: 'Password',
//               suffixIcon: Icon(Icons.edit_outlined),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 20),
//
//       // Confirm Password Field
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Addres Line 2 :',
//                 style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.primary)),
//             SizedBox(height: 8),
//             CustomInputField(
//               controller: controllers.addressLine2Controller,
//               prefixIcon: Icon(Icons.lock),
//               hintText: 'Confirm Password',
//               suffixIcon: Icon(Icons.edit_outlined),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 30),
//
//                 ElevatedButton(
//                   onPressed: () => _logout(context),
//                   style: ElevatedButton.styleFrom(
//                     primary: Colors.white, // Set button background color
//                     onPrimary: AppColors.primary, // Set text/icon color
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30), // Optional rounded corners
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.exit_to_app, color: AppColors.primary),
//                       SizedBox(width: 8), // Space between icon and text
//                       Text(
//                         "Log Out",
//                         style: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//       ],
//     ),)
//     ,
//     );
//   }
// }
