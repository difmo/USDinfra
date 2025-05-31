import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usdinfra/authentication/otp_screen.dart';
import 'package:usdinfra/user_pages/dash_boardP1.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final mobileController = TextEditingController();
  final otpController = TextEditingController();

  var isLoading = false.obs;
  var mobileNumber = ''.obs;
  var isMobileValid = false.obs;

  String? _verificationId;

  @override
  void onInit() {
    super.onInit();
    print('onInit: Mobile prefilled with ${mobileController.text}');
  }

  void validateMobile(String value) {
    mobileNumber.value = value;
    isMobileValid.value =
        value.length == 10 && RegExp(r'^[0-9]+$').hasMatch(value);
    print('validateMobile: $value -> isValid: ${isMobileValid.value}');
  }

  Future<void> sendOtp() async {
    if (!isMobileValid.value) {
      print('sendOtp: Invalid mobile number entered');
      Get.snackbar('Error', 'Please enter a valid 10-digit mobile number',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    print('sendOtp: Sending OTP to +91${mobileController.text}');

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${mobileController.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('verificationCompleted: Auto-verifying...');
          isLoading.value = false;
          await _auth.signInWithCredential(credential);
          Get.back();
          Get.snackbar('Success', 'Login successful!',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        },
        verificationFailed: (FirebaseAuthException e) {
          isLoading.value = false;
          print('verificationFailed: ${e.code} - ${e.message}');

          String errorMessage = switch (e.code) {
            'invalid-phone-number' =>
              'Invalid phone number format. Please check again.',
            'too-many-requests' => 'Too many requests. Please try again later.',
            _ => 'Failed to send OTP. ${e.message ?? ''}',
          };

          Get.snackbar('Error', errorMessage,
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        },
        codeSent: (String verificationId, int? resendToken) {
          print('codeSent: OTP sent. Verification ID: $verificationId');
          isLoading.value = false;
          _verificationId = verificationId;

          Future.microtask(() => Get.to(() => OtpScreen()));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(
              'codeAutoRetrievalTimeout: Timeout for verification ID: $verificationId');
          _verificationId = verificationId;
          isLoading.value = false;
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      isLoading.value = false;
      print('sendOtp: Exception caught - $e');
      Get.snackbar('Error', 'An unexpected error occurred: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> verifyOtp(String otp) async {
    print('verifyOtp: Entered OTP is $otp');
    if (otp.length != 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if (_verificationId == null) {
      Get.snackbar('Error', 'OTP session expired. Please request a new OTP.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      print('verifyOtp: _verificationId is null');
      return;
    }

    isLoading.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      print('verifyOtp: Verifying with verificationId $_verificationId');
      await _auth.signInWithCredential(credential);
      isLoading.value = false;
      saveUserToFirestore(
        mobile: mobileController.text,
      );
      Future.microtask(() => Get.to(() => HomeDashBoard()));
      Get.snackbar('Success', 'Login successful!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      isLoading.value = false;
      print('verifyOtp: Exception - $e');
      String errorMessage = 'Invalid OTP';
      if (e is FirebaseAuthException) {
        errorMessage = switch (e.code) {
          'invalid-verification-code' =>
            'Incorrect OTP entered. Please try again.',
          'session-expired' => 'OTP session expired. Please request a new OTP.',
          _ => 'Failed to verify OTP. ${e.message ?? ''}',
        };
      }

      Get.snackbar('Error', errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> saveUserToFirestore({
    required String mobile,
  }) async {
    await firestore
        .collection('AppUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'name': "Guest",
      'email': "",
      'mobile': mobile,
      'role': 'isUser',
      'dealerType': "owner",
      'favoriteProperties': [],
      'purchesedProperties': [],
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  void onClose() {
    print('onClose: Disposing controllers');
    mobileController.dispose();
    otpController.dispose();
    super.onClose();
  }
}
