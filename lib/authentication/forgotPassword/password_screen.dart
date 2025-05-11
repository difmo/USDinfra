// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../../Controllers/authentication_controller.dart';
// import '../../Customs/custom_textfield.dart';
// import '../../conigs/app_colors.dart';
//
// class ResetPasswordScreen extends StatefulWidget {
//   final String? email; // Assuming the email is passed when navigating to the ResetPasswordScreen
//
//   ResetPasswordScreen({this.email});
//
//   @override
//   _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
// }
//
// class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
//   final controllers = ControllersManager();
//   bool _isPVisible = false;
//   bool _isCPVisible = false;
//   String _errorMessage = '';
//
//   // Function to handle password reset
//   Future<void> _resetPassword() async {
//     String password = controllers.passwordController.text.trim();
//     String confirmPassword = controllers.confirmpasswordController.text.trim();
//
//     // Validate passwords
//     if (password.isEmpty || confirmPassword.isEmpty) {
//       setState(() {
//         _errorMessage = 'Both fields are required.';
//       });
//       return;
//     }
//
//     if (password != confirmPassword) {
//       setState(() {
//         _errorMessage = 'Passwords do not match.';
//       });
//       return;
//     }
//
//     // Perform the password reset (Firebase Auth logic)
//     try {
//       // Get the current user
//       User? user = FirebaseAuth.instance.currentUser;
//
//       if (user != null) {
//         // Update password in Firebase Authentication
//         await user.updatePassword(password);
//         await user.reload(); // Reload user data to reflect the changes
//
//         // Also update the password change time in Firestore (optional)
//         await FirebaseFirestore.instance.collection('AppUsers').doc(user.uid).update({
//           'lastPasswordChange': FieldValue.serverTimestamp(),
//         });
//
//         setState(() {
//           _errorMessage = ''; // Clear any previous error message
//         });
//
//         // Show success message
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text('Password successfully reset!'),
//           backgroundColor: Colors.green,
//         ));
//
//         // Go back to the login screen
//         Navigator.pop(context);
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to reset password. Please try again later.';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Image.asset(
//               'assets/animations/logo.png',
//               height: 100,
//             ),
//             SizedBox(height: 20),
//             Text(
//               'Enter a new password below to change your password and access your account.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16, color: Colors.black54),
//             ),
//             SizedBox(height: 20),
//             buildPasswordTextField("Password", controllers.passwordController, _isPVisible, () {
//               setState(() {
//                 _isPVisible = !_isPVisible;
//               });
//             }),
//             SizedBox(height: 5),
//             buildPasswordTextField("Confirm Password", controllers.confirmpasswordController, _isCPVisible, () {
//               setState(() {
//                 _isCPVisible = !_isCPVisible;
//               });
//             }),
//             SizedBox(height: 20),
//             // Error message display
//             if (_errorMessage.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Text(
//                   _errorMessage,
//                   style: TextStyle(color: Colors.red, fontSize: 14),
//                 ),
//               ),
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton(
//                 onPressed: _resetPassword,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.primary,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   elevation: 5,
//                 ),
//                 child: Text(
//                   'Reset Password',
//                   style: TextStyle(fontSize: 18, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildPasswordTextField(String label, TextEditingController controller, bool isVisible, VoidCallback onToggle) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(label,
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary)),
//           SizedBox(height: 8),
//           CustomInputField(
//             controller: controller,
//             prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
//             hintText: label,
//             obscureText: !isVisible,
//             suffixIcon: IconButton(
//               icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, color: AppColors.primary),
//               onPressed: onToggle,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Controllers/authentication_controller.dart';
import '../../Customs/custom_textfield.dart';
import '../../configs/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String?
      email; // Assuming the email is passed when navigating to the ResetPasswordScreen

  const ResetPasswordScreen({super.key, this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final controllers = ControllersManager();
  bool _isPVisible = false;
  bool _isCPVisible = false;
  String _errorMessage = '';

  // Function to handle password reset
  Future<void> _resetPassword() async {
    String password = controllers.passwordController.text.trim();
    String confirmPassword = controllers.confirmpasswordController.text.trim();

    // Validate passwords
    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _errorMessage = 'Both fields are required.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(password);
        await user.reload();
        await FirebaseFirestore.instance
            .collection('AppUsers')
            .doc(user.uid)
            .update({
          'lastPasswordChange': FieldValue.serverTimestamp(),
          'passWord': password,
          'confirmpassWord': confirmPassword,
        });

        setState(() {
          _errorMessage = ''; // Clear any previous error message
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password successfully reset!'),
          backgroundColor: Colors.green,
        ));

        // Go back to the login screen
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to reset password. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/animations/logo.png',
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Enter a new password below to change your password and access your account.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            SizedBox(height: 20),
            buildPasswordTextField(
                "Password", controllers.passwordController, _isPVisible, () {
              setState(() {
                _isPVisible = !_isPVisible;
              });
            }),
            SizedBox(height: 5),
            buildPasswordTextField("Confirm Password",
                controllers.confirmpasswordController, _isCPVisible, () {
              setState(() {
                _isCPVisible = !_isCPVisible;
              });
            }),
            SizedBox(height: 20),
            // Error message display
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPasswordTextField(String label, TextEditingController controller,
      bool isVisible, VoidCallback onToggle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary)),
          SizedBox(height: 8),
          CustomInputField(
            controller: controller,
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
            hintText: label,
            obscureText: !isVisible,
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary),
              onPressed: onToggle,
            ),
          ),
        ],
      ),
    );
  }
}
