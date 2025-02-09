import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:usdinfra/conigs/app_colors.dart';
import 'package:usdinfra/routes/app_routes.dart';

import '../Controllers/authentication_controller.dart';
import '../Customs/custom_textfield.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllers = ControllersManager();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _ispasswordVisible = false;

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email);
  }

  Future<void> _login(BuildContext context) async {

    String email = controllers.emailController.text.trim();
    String password = controllers.passwordController.text;

    if (email.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('please fill in all fields'),
        backgroundColor: AppColors.primary,
      ));
      return;
    } else if (email.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter your email address'),
        backgroundColor: AppColors.primary,
      ));
      return;
    }else if(!isValidEmail(email)) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter a valid email address'),
        backgroundColor: AppColors.primary,
      ));
      return;
    }
    else if (password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter your password'),
      ));
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        var userDoc = await FirebaseFirestore.instance
            .collection('AppUsers')
            .doc(userCredential.user!.uid)
            .get();
        if (userDoc.exists) {
          Navigator.pushNamed(context, AppRouts.dashBoard);
        } else {
          Navigator.pushNamed(context, AppRouts.signup);
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please register'),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Lottie.asset(
                    'assets/animations/login.json',
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  'Log In Now',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Please login to continue using our app',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email Address:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      CustomInputField(
                        hintText: 'Email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppColors.primary,
                        ),
                        controller: controllers.emailController,
                        // validator: (value){
                        //   if (value == null || value.isEmpty){
                        //     return 'Please enter your email address';
                        //   }
                        //   return null; // No error
                        // },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Password TextField
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 8),
                      CustomInputField(
                        hintText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: AppColors.primary,
                        ),
                        controller: controllers.passwordController,
                        suffixIcon:
                            IconButton(
                              icon: Icon(
                                _ispasswordVisible
                                ?Icons.visibility_off
                                    :Icons.visibility,
                                    color: AppColors.primary,
                              ),
                              onPressed: (){
                                setState(() {
                                  _ispasswordVisible = !_ispasswordVisible;
                                });
                              },
                            ),
                        obscureText: !_ispasswordVisible,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _login(context),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.primary),
                          )
                        : Text(
                            'Log In',
                            style: TextStyle(color: Colors.white),
                          ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 3,
                      shadowColor: AppColors.shadow,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Footer with Sign Up
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouts.signup);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
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
