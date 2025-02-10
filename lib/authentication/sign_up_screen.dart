import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> generateUserId() async {
    String currentYear = DateTime.now().year.toString().substring(2); // '24'
    String userPrefix = "USDINFRA$currentYear"; // USR24
    String userId = "${userPrefix}00001"; // Default ID if no users exist

    try {
      var querySnapshot = await _firestore
          .collection('AppUsers')
          .orderBy('userId', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String lastUserId = querySnapshot.docs.first['userId']; // Last stored ID
        int lastNumber = int.parse(lastUserId.substring(7)); // Extract numeric part
        userId = "$userPrefix${(lastNumber + 1).toString().padLeft(5, '0')}"; // Increment ID
      }
    } catch (e) {
      print("Error generating user ID: $e");
    }

    return userId;
  }

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
        _isLoading = false;
      });
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Passwords do not match'),
        backgroundColor: Colors.red,
      ));
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Generate unique userId
      String userId = await generateUserId();

      // Create a new user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user details including userId in Firestore
      await _firestore.collection('AppUsers').doc(userCredential.user?.uid).set({
        'userId': userId,
        'name': name,
        'email': email,
        'mobile': mobile,
        'createdAt': FieldValue.serverTimestamp(), // Store signup timestamp
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signup successful!'),
        backgroundColor: Colors.green,
      ));

      // Navigate to profile setup page
      Navigator.pushNamed(context, AppRouts.profilesetup);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$").hasMatch(email);
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
                Image.asset(
                  'assets/animations/logo.png',
                  height: 300,
                  fit: BoxFit.contain,
                ),
                Text(
                  'Create a new account',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                SizedBox(height: 20),

                buildTextField("Name", controllers.nameController, Icons.person_2_outlined),
                buildTextField("Email", controllers.emailController, Icons.email_outlined),
                buildTextField("Mobile", controllers.mobileController, Icons.local_phone_outlined),

                buildPasswordTextField("Password", controllers.passwordController, _isPVisible, () {
                  setState(() {
                    _isPVisible = !_isPVisible;
                  });
                }),

                buildPasswordTextField("Confirm Password", controllers.confirmpasswordController, _isCPVisible, () {
                  setState(() {
                    _isCPVisible = !_isCPVisible;
                  });
                }),

                SizedBox(height: 30),
                buildSignupButton(context),
                SizedBox(height: 20),

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
                          style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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

  Widget buildTextField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary)),
          SizedBox(height: 8),
          CustomInputField(
            controller: controller,
            prefixIcon: Icon(icon, color: AppColors.primary),
            hintText: "Enter $label",
          ),
        ],
      ),
    );
  }

  Widget buildPasswordTextField(String label, TextEditingController controller, bool isVisible, VoidCallback onToggle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.primary)),
          SizedBox(height: 8),
          CustomInputField(
            controller: controller,
            prefixIcon: Icon(Icons.lock, color: AppColors.primary),
            hintText: label,
            obscureText: !isVisible,
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility, color: AppColors.primary),
              onPressed: onToggle,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSignupButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: _isLoading ? null : () => _signup(context),
          child: _isLoading
              ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))
              : Text('Signup', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shadowColor: Colors.grey,
            padding: EdgeInsets.symmetric(vertical: 10),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ),
      ),
    );
  }
}
