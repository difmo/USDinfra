import 'package:flutter/material.dart';

class ControllersManager {
// Signup Page Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  final TextEditingController contactController = TextEditingController();

//////////////////// Contact Us Controllers//////////////////////////
  final TextEditingController messageController = TextEditingController();

// Profile page controller

  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();

/////////// Form page 2 controllers//////////////////////////////////

  final TextEditingController cityController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController subLocalityController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController plotAreaController = TextEditingController();
  final TextEditingController totalFloorsController = TextEditingController();
  final TextEditingController expectedPriceController = TextEditingController();
  final TextEditingController reraNumberController = TextEditingController();
  final TextEditingController totalexpectedPriceController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController propertyName = TextEditingController();
}
