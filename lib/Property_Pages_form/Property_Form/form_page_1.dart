import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/utils/constants.dart';
import '../../Controllers/authentication_controller.dart';
import '../../Customs/CustomAppBar.dart';
import '../Property_Form/Form_page_1_components/Contact_Details.dart';
import '../Property_Form/Form_page_1_components/Looking_To_Property.dart';
import '../Property_Form/Form_page_1_components/Property_Category.dart';
import '../Property_Form/Form_page_1_components/Property_Type.dart';
import 'form_page_2.dart';

class PropertyForm1 extends StatefulWidget {
  const PropertyForm1({super.key});

  @override
  State<PropertyForm1> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm1> {
  final User? user = FirebaseAuth.instance.currentUser;
  AppConstants constants = new AppConstants();
  String? lookingTo;
  String? propertyType;
  String? propertyCategory;
  String? contactDetailsError;

  final _formKey = GlobalKey<FormState>();
  String? _lookingToError;
  String? _propertyTypeError;
  String? _propertyCategoryError;
  final controllers = ControllersManager();

  List<String> getPropertyTypes() {
    switch (lookingTo) {
      case 'Sell':
      case 'Rent / Lease':
        return ['Residential', 'Commercial'];
      case 'Paying Guest':
        return ['Residential'];
      default:
        return [];
    }
  }

  List<String> getPropertyCategories() {
    if (lookingTo == 'Sell' && propertyType == 'Commercial') {
      return [
        'Office',
        'Retail',
        'Storage',
        'Plot/Land',
        'Industry',
        'Hospitality',
        'Other'
      ];
    } else if (lookingTo == 'Sell' && propertyType == 'Residential') {
      return [
        'Apartment',
        'Independent House/Villa',
        'Independent/Builder Floor',
        'Plot/Land',
        '1RK/Studio Apartment',
        'Serviced Apartment',
        'Farmhouse',
        'Other'
      ];
    } else if (lookingTo == 'Rent / Lease' && propertyType == 'Residential') {
      return [
        'Apartment',
        'Independent House/Villa',
        'Independent/Builder Floor',
        '1RK/Studio Apartment',
        'Serviced Apartment',
        'Farmhouse',
        'Other'
      ];
    } else if (lookingTo == 'Rent / Lease' && propertyType == 'Commercial') {
      return [
        'Office',
        'Retail',
        'Storage',
        'Plot/Land',
        'Industry',
        'Hospitality',
        'Other'
      ];
    } else if (lookingTo == 'Paying Guest' && propertyType == 'Residential') {
      return [
        'Apartment',
        'Independent House/Villa',
        'Independent/Builder Floor',
        '1RK/Studio Apartment',
        'Serviced Apartment'
      ];
    } else {
      return [];
    }
  }

  String? _validateContactDetails(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your contact details';
    }
    if (RegExp(r'^[0-9]+$').hasMatch(value) && value.length != 10) {
      return 'Phone number must be exactly 10 digits long';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value) && !value.contains('@')) {
      return 'Please enter a valid phone number or email';
    }
    return null;
  }

  void _validateAndSubmit() {
    setState(() {
      _lookingToError =
          lookingTo == null ? 'Please select what you\'re looking to do' : null;
      _propertyTypeError =
          propertyType == null ? 'Please select a property type' : null;
      _propertyCategoryError =
          propertyCategory == null ? 'Please select a property category' : null;
    });

    contactDetailsError =
        _validateContactDetails(controllers.contactController.text);

    if (_formKey.currentState!.validate() &&
        lookingTo != null &&
        propertyType != null &&
        propertyCategory != null &&
        contactDetailsError == null) {
      Map<String, dynamic> formData = {
        'lookingTo': lookingTo,
        'propertyType': propertyType,
        'propertyCategory': propertyCategory,
        'contactDetails': controllers.contactController.text,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyForm2(formData: formData),
        ),
      );
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Property From'),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.grey,
                ),
                const SizedBox(height: 20),
                Text(
                  'You need to login to list your properties.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  child: Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                        onTap: () => constants.launchWhatsApp('+919453412826'),
                        child: Text("Help on Whatsapp")),
                    SizedBox(
                      width: 10,
                    ),
                    SvgPicture.asset(
                      "assets/svg/whatsapp.svg",
                      width: 20,
                    ),
                  ],
                ),
                Text(
                  'Add Basic Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'STEP 1 OF 3',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ),
                const SizedBox(height: 20),
                // Looking to property
                LookingToColumn(
                  lookingTo: lookingTo,
                  onSelectLookingTo: (value) {
                    setState(() {
                      lookingTo = value;
                      propertyType = null;
                      propertyCategory = null;
                    });
                  },
                  lookingToError: _lookingToError,
                ),
                const SizedBox(height: 20),
                // Property Type
                PropertyTypeColumn(
                  propertyType: propertyType,
                  onSelectPropertyType: (value) {
                    setState(() {
                      propertyType = value;
                      propertyCategory = null;
                    });
                  },
                  propertyTypes: getPropertyTypes(),
                  propertyTypeError: _propertyTypeError,
                ),
                const SizedBox(height: 20),
                // Property Category
                PropertyCategoryColumn(
                  propertyCategory: propertyCategory,
                  onSelectPropertyCategory: (value) {
                    setState(() {
                      propertyCategory = value;
                    });
                  },
                  propertyCategories: getPropertyCategories(),
                  propertyCategoryError: _propertyCategoryError,
                ),
                const SizedBox(height: 20),
                ContactDetailsColumn(
                  controller: controllers.contactController,
                  validator: _validateContactDetails,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _validateAndSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.shadow,
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: AppFontFamily.primaryFont,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
