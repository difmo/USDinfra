import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFd8232a);
  static const Color secondry = Color(0xffec9322);
  static const Color blackColor = Color.fromARGB(255, 19, 19, 19);
  static const Color whiteColor = Color(0xffec9322);
  static const Color shadow = Color(0xffbf6f6f);
  static const Color white = Color.fromARGB(255, 253, 253, 253);
  static const Color lightGrey = Color.fromARGB(255, 161, 154, 154);
  static LinearGradient gradient = LinearGradient(
    colors: [primary, secondry],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
