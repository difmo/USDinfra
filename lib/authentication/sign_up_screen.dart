import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:usdinfra/conigs/app_colors.dart';
import '../Controllers/authentication_controller.dart';
import '../Customs/custom_textfield.dart';
import '../routes/app_routes.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final controllers = ControllersManager();
  bool _isLoading = false;
  bool _isPVisible = false;
  bool _isCPVisible = false;
  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _signup(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String name = controllers.nameController.text;
    String email = controllers.emailController.text;
    String mobile = controllers.mobileController.text;
    String password = controllers.passwordController.text;
    String confirmPassword = controllers.confirmpasswordController.text;

    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid email format'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _isLoading = false; // Hide progress indicator if validation fails
      });
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Passwords do not match',
          style: TextStyle(color: AppColors.primary),
        ),
      ));
      setState(() {
        _isLoading = false; // Hide progress indicator if password mismatch
      });
      return;
    }

    try {
      // Create a new user with Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After user is created, store additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'email': email,
        'mobile': mobile,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signup successful!'),
        backgroundColor: Colors.green,
      ));
      // Navigate to profile setup page
      Navigator.pushNamed(context, AppRouts.profilesetup);
    } catch (e) {
      // Show error message if signup fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading =
            false; // Hide progress indicator once the process is complete
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/login.json',
                  height: 300,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
                Text(
                  'Create a new account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 20),

                // Name Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name :',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary)),
                      SizedBox(height: 8),
                      CustomInputField(
                          controller: controllers.nameController,
                          prefixIcon: Icon(Icons.person_2_outlined,
                            color: AppColors.primary,),
                          hintText: 'Enter Name'),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email :',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary)),
                      SizedBox(height: 8),
                      CustomInputField(
                          controller: controllers.emailController,
                          prefixIcon: Icon(Icons.email_outlined,
                            color: AppColors.primary,),
                          hintText: 'Enter your Email'),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Mobile Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mobile :',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary)),
                      SizedBox(height: 8),
                      CustomInputField(
                          controller: controllers.mobileController,
                          prefixIcon: Icon(Icons.local_phone_outlined,
                            color: AppColors.primary,),
                          hintText: 'Enter your Mobile Number'),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Password :',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary)),
                      SizedBox(height: 8),
                      CustomInputField(
                        controller: controllers.passwordController,
                        prefixIcon: Icon(Icons.lock,
                          color: AppColors.primary,),
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon:Icon(
                            _isPVisible
                            ?Icons.visibility_off
                                :Icons.visibility,
                            color: AppColors.primary,
                          ),
                        onPressed: (){
                            setState(() {
                              _isPVisible =!_isPVisible;
                            });
                        },
                      ),
                        obscureText: !_isPVisible,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Confirm Password Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Confirm Password :',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary)),
                      SizedBox(height: 8),
                      CustomInputField(
                        controller: controllers.confirmpasswordController,
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.primary,
                        ),
                        hintText: 'Confirm Password',
                        suffixIcon: IconButton(
                          icon: Icon(_isCPVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                          color: AppColors.primary,
                        ),
                        onPressed: (){
                            setState(() {
                              _isCPVisible = !_isCPVisible;
                            });
                        },
                      ),
                        obscureText: !_isCPVisible,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),

                // Signup Button
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : () => _signup(context),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary),
                            )
                          : Text('Signup',
                              style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shadowColor: Colors.grey,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        textStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Navigate to Login Page
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouts.login);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Log in",
                          style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
