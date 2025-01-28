import 'package:flutter/material.dart';
import 'package:usdinfra/Userpages/dash_board.dart';
import 'package:usdinfra/authentication/welcome_screen.dart';
import '../Bottom/bottom_navigation.dart';
import '../Property_Pages/Property_Form/form_page_1.dart';
import '../Property_Pages/Property_Form/form_page_2.dart';
import '../Splash_screen.dart';
import '../Property_Pages/All_properties_list.dart';
import '../Userpages/profile_page.dart';
import '../Userpages/profile_setup.dart';
import '../authentication/login_screen.dart';
import '../authentication/sign_up_screen.dart';

class AppRouts {
  static const String splash = '/splash';
  static const homePage = '/homepage';
  static const login = '/login';
  static const signup = '/signup';
  static const profilesetup = '/profilesetup';
  static const dashBoard = '/dashboard';
  static const properties = '/AllProperties';
  static const propertyform1 = '/PropertyForm1';
  static const propertyform2 = '/PropertyForm2';
  static const profile = '/profilepage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => SignupPage());
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case profilesetup:
        return MaterialPageRoute(builder: (_) => ProfilesetupPage());
      case dashBoard:
        return MaterialPageRoute(builder: (_) => HomeDashBoard());
      case properties:
        return MaterialPageRoute(builder: (_) => AllProperties());
      case propertyform1:
        return MaterialPageRoute(builder: (_) => PropertyForm1());
      case propertyform2:
        return MaterialPageRoute(builder: (_) => PropertyForm2());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
