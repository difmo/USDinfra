import 'package:flutter/material.dart';
import 'package:usdinfra/admin/sold_property.dart';
import 'package:usdinfra/Property_Pages_form/purchesedProperties.dart';
import 'package:usdinfra/user_pages/about_us_screen.dart';
import 'package:usdinfra/user_pages/chat_detail_screen.dart';
import 'package:usdinfra/user_pages/chat_screen.dart';
import 'package:usdinfra/user_pages/contact_us_screen%20.dart';
import 'package:usdinfra/user_pages/dash_boardP1.dart';
import 'package:usdinfra/user_pages/privacy_policy_screen.dart';
import 'package:usdinfra/user_pages/termsand_conditions.dart';
import 'package:usdinfra/user_pages/upgrade_service_screen.dart';
import 'package:usdinfra/user_pages/notification_page.dart';
import 'package:usdinfra/user_pages/searchScreen.dart';
// import 'package:usdinfra/authentication/dummy.dart';
import 'package:usdinfra/authentication/welcome_screen.dart';
// import '../Admin/admin_bottom_nav.dart';
import '../admin/admin_dashboard.dart';
import '../admin/approved_property.dart';
import '../admin/enquaries.dart';
// import '../Bottom/bottom_navigation.dart';
// import '../Property_Pages_form/Property_Form/Form_Page_2_Components/sell_residential.dart';
import '../Property_Pages_form/Property_Form/form_page_1.dart';
import '../Property_Pages_form/Property_Form/form_page_2.dart';
import '../Property_Pages_form/favoriteProperties.dart';
import '../splash_screen.dart';
import '../Property_Pages_form/all_properties_list.dart';
import '../user_pages/profile_page.dart';
import '../user_pages/profile_setup.dart';
import '../user_pages/user_property.dart';
import '../authentication/forgotPassword/email_screen.dart';
import '../authentication/forgotPassword/password_screen.dart';
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
  static const PROPERTDETAIL = '/PropertyDetailPage';
  static const propertyform1 = '/PropertyForm1';
  static const propertyform2 = '/PropertyForm2';
  static const profile = '/profilepage';
  static const bottom = '/bottomnav';
  static const adminbottom = '/Adminbottomnav';
  static const purchesedProperties = '/purchesed';

  static const notification = '/NotificationPage';
  static const chat = '/chat';
  static const chatdetails = '/chatdetails';
  static const upgardeservice = '/upgardeservice';
  static const aboutus = '/aboutus';
  static const contactus = '/contactus';
  static const termconsition = '/termconsition';
  static const privacy = '/privacy';
  static const sellresidential = '/sellresidential';
  static const myPropertiesPage = '/MypropertiesPage';
  static const forgetpassemail = '/Forgetpassemail';
  static const forgetpass = '/Forgetpass';
  static const favoritePropertiesPage = '/FavoritePropertiesPage';
  static const adminProperty = '/AdminBottomNavigationBar';
  static const approvedProperty = '/ApprovedPropertiesPage';
  static const enquiriesPage = '/AdminEnquiriesPage';
  static const soldProperty = '/Sold';
  static const Search = '/search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(builder: (_) => HomePage());
      // case bottom:
      //   return MaterialPageRoute(builder: (_) => CustomBottomNavigationBar());
      // case adminbottom:
      //   return MaterialPageRoute(builder: (_) => AdminBottomNavigationBar());
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case purchesedProperties:
        return MaterialPageRoute(builder: (_) => PurchesedPropertiesPage());
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
      case chat:
        return MaterialPageRoute(builder: (_) => ChatScreen());
      case upgardeservice:
        return MaterialPageRoute(builder: (_) => UpgradeServiceScreen());
      case chatdetails:
        return MaterialPageRoute(
            builder: (_) => ChatDetailScreen(
                  name: '',
                  profileUrl: '',
                ));
      case propertyform2:
        Map<String, String?> formData = {};
        return MaterialPageRoute(
            builder: (_) => PropertyForm2(
                  formData: formData,
                ));

      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case notification:
        return MaterialPageRoute(builder: (_) => NotificationScreen());
      case aboutus:
        return MaterialPageRoute(builder: (_) => AboutUsScreen());
      case contactus:
        return MaterialPageRoute(builder: (_) => ContactUsScreen());
      case privacy:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());

      case termconsition:
        return MaterialPageRoute(builder: (_) => TermsAndConditionsScreen());
      // case sellresidential:
      //   return MaterialPageRoute(builder: (_) => PropertyDetailsForm());
      case myPropertiesPage:
        return MaterialPageRoute(builder: (_) => MyPropertiesPage());
      case favoritePropertiesPage:
        return MaterialPageRoute(builder: (_) => FavoritePropertiesPage());
      case forgetpassemail:
        return MaterialPageRoute(builder: (_) => ForgotPasswordEmailScreen());
      case forgetpass:
        return MaterialPageRoute(builder: (_) => ResetPasswordScreen());
      case adminProperty:
        return MaterialPageRoute(builder: (_) => AdminPropertyPage());
      case approvedProperty:
        return MaterialPageRoute(builder: (_) => ApprovedPropertiesPage());
      case soldProperty:
        return MaterialPageRoute(builder: (_) => SoldPropertiesPage());
      case enquiriesPage:
        return MaterialPageRoute(builder: (_) => AdminEnquiriesPage());
      case Search:
        return MaterialPageRoute(builder: (_) => SearchScreen());

      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
