import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFontFamily {
  static String primaryFont = GoogleFonts.plusJakartaSans().fontFamily!;

  static TextStyle primaryTextStyle = GoogleFonts.plusJakartaSans(
      textStyle: const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black,
  ));
}
