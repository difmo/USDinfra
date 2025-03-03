import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/conigs/app_colors.dart';
import '../Controllers/authentication_controller.dart';
import '../Customs/custom_textfield.dart';
import '../routes/app_routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

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

  String? nameError;
  String? emailError;
  String? mobileError;
  String? passwordError;
  String? confirmPasswordError;

  Future<String> generateUserId() async {
    String currentYear = DateTime.now().year.toString().substring(2);
    String userPrefix = "USDINFRA$currentYear";
    String userId = "${userPrefix}00001";

    try {
      var querySnapshot = await _firestore
          .collection('AppUsers')
          .orderBy('userId', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String lastUserId =
        querySnapshot.docs.first['userId'];
        int lastNumber =
        int.parse(lastUserId.substring(7));
        userId =
        "$userPrefix${(lastNumber + 1).toString().padLeft(5, '0')}";
      }
    } catch (e) {
      print("Error generating user ID: $e");
    }

    return userId;
  }

  Future<void> _signup(BuildContext context) async {
    setState(() {
      _isLoading = true;
      nameError = null;
      emailError = null;
      mobileError = null;
      passwordError = null;
      confirmPasswordError = null;
    });

    String name = controllers.nameController.text;
    String email = controllers.emailController.text;
    String mobile = controllers.mobileController.text;
    String password = controllers.passwordController.text;
    String confirmPassword = controllers.confirmpasswordController.text;

    bool isValid = true;

    if (name.isEmpty) {
      setState(() {
        nameError = 'Name cannot be empty';
      });
      isValid = false;
    }

    bool isValidEmail(String email) {
      return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);
    }

    if (email.isEmpty) {
      setState(() {
        emailError = 'Email cannot be empty';
      });
      isValid = false;
    } else if (!isValidEmail(email)) {
      setState(() {
        emailError = 'Invalid email format';
      });
      isValid = false;
    }

    if (mobile.isEmpty || mobile.length != 10) {
      setState(() {
        mobileError = 'Mobile number must be 10 digits';
      });
      isValid = false;
    }

    if (password.isEmpty || password.length < 8) {
      setState(() {
        passwordError = 'Password must be at least 8 characters long';
      });
      isValid = false;
    }

    if (password != confirmPassword) {
      setState(() {
        confirmPasswordError = 'Passwords do not match';
      });
      isValid = false;
    }

    if (!isValid) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      String userId = await generateUserId();

      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore
          .collection('AppUsers')
          .doc(userCredential.user?.uid)
          .set({
        'userId': userId,
        'name': name,
        'email': email,
        'mobile': mobile,
        'passWord': password,
        'role': 'isUser',
        'confirmpassWord': confirmPassword,
        'favoriteProperties': [],
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Signup successful!'),
        backgroundColor: Colors.green,
      ));

      Navigator.pushNamed(context, AppRouts.profilesetup);
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}', Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email);
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
    setState(() {
      _isLoading = false;
    });
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
                  width: 300,
                  fit: BoxFit.contain,
                ),
                Text(
                  'Create a new account',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
                SizedBox(height: 20),
                buildInputField('Name', controllers.nameController,
                    Icons.person_2_outlined, TextInputType.text,
                    errorMessage: nameError),
                buildInputField('Email', controllers.emailController,
                    Icons.email_outlined, TextInputType.emailAddress,
                    errorMessage: emailError),
                buildInputField('Mobile', controllers.mobileController,
                    Icons.local_phone_outlined, TextInputType.phone,
                    errorMessage: mobileError, maxLength: 10),
                buildPasswordTextField(
                    "Password", controllers.passwordController, _isPVisible,
                        () {
                      setState(() {
                        _isPVisible = !_isPVisible;
                      });
                    }, TextInputType.text, errorMessage: passwordError),
                buildPasswordTextField("Confirm Password",
                    controllers.confirmpasswordController, _isCPVisible, () {
                      setState(() {
                        _isCPVisible = !_isCPVisible;
                      });
                    }, TextInputType.text, errorMessage: confirmPasswordError),
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

  Widget buildInputField(String label, TextEditingController controller,
      IconData icon, TextInputType inputType,
      {int? maxLength, String? errorMessage}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          SizedBox(height: 8),
          CustomInputField(
            borderRadius: 25,
            controller: controller,
            prefixIcon: Icon(icon, color: AppColors.primary),
            hintText: "Enter $label",
            inputType: inputType,
            maxLength: maxLength,
          ),
          if (errorMessage != null && errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget buildPasswordTextField(String label, TextEditingController controller,
      bool isVisible, VoidCallback onToggle, TextInputType text,
      {String? errorMessage}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),
          SizedBox(height: 8),
          CustomInputField(
            borderRadius: 25,
            controller: controller,
            prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
            hintText: label,
            obscureText: !isVisible,
            suffixIcon: IconButton(
              icon: Icon(
                  isVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.black),
              onPressed: onToggle,
            ),
          ),
          if (errorMessage != null && errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 12)),
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
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shadowColor: Colors.grey,
            padding: EdgeInsets.symmetric(vertical: 10),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            backgroundColor: AppColors.primary,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: _isLoading
              ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary))
              : Text('Signup', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
