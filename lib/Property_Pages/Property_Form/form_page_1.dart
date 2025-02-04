import 'package:flutter/material.dart';
import 'package:usdinfra/Property_Pages/Property_Form/form_page_2.dart';
import 'package:usdinfra/conigs/app_colors.dart';
import '../../Controllers/authentication_controller.dart';
import '../../routes/app_routes.dart';
import 'Form_page_1_components/Contact_Details.dart';
import 'Form_page_1_components/Looking_To_Property.dart';
import 'Form_page_1_components/Property_Category.dart';
import 'Form_page_1_components/Property_Comercial_Type.dart';
import 'Form_page_1_components/Property_Type.dart';
import 'package:usdinfra/Utils/validators.dart';

class PropertyForm1 extends StatefulWidget {
  const PropertyForm1({super.key});

  @override
  State<PropertyForm1> createState() => _PropertyFormState();
}

class _PropertyFormState extends State<PropertyForm1> {
  String? lookingTo;
  String? propertyType;
  String? propertyCategory;
  // String? _contactDetailsError;

  final _formKey = GlobalKey<FormState>();
  String? _lookingToError;
  String? _propertyTypeError;
  String? _propertyCategoryError;
  final controllers = ControllersManager();

  List<String> getPropertyTypes() {
    if (lookingTo == 'Sell') {
      return ['Residential', 'Commercial'];
    } else if (lookingTo == 'Rent / Lease') {
      return ['Residential', 'Commercial'];
    } else if (lookingTo == 'Paying Guest') {
      return ['Residential'];
    } else {
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

  void _validateAndSubmit() {
    setState(() {
      _lookingToError =
          lookingTo == null ? 'Please select what you\'re looking to do' : null;
      _propertyTypeError =
          propertyType == null ? 'Please select a property type' : null;
      _propertyCategoryError =
          propertyCategory == null ? 'Please select a property category' : null;
    });
    String? contactDetailsError = controllers.contactController.text.isEmpty
        ? 'Please enter your contact details'
        : null;


    String? Function(String?)? contactValidator;
    if (contactDetailsError == null) {
      if (controllers.contactController.text.contains('@')) {
        // Email validation
        contactValidator = Validators.validateEmail;
      } else {
        // Mobile number validation
        contactValidator = Validators.validateMobileNumber;
      }
    }

    if (_formKey.currentState!.validate() &&
        lookingTo != null &&
        propertyType != null &&
        propertyCategory != null) {

      final formData = {
        'lookingTo': lookingTo,
        'propertyType': propertyType,
        'propertyCategory': propertyCategory,
        'contactDetails': controllers.contactController.text,
      };

      print("Navigating to PropertyForm2 with data: $formData"); // Debugging

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PropertyForm2(formData: formData), // Passing the data to the next screen
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Post Via WhatsApp',
              style: TextStyle(color: Colors.green, fontSize: 14),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Basic Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                const SizedBox(height: 4),
                const Text(
                  'STEP 1 OF 3',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
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
                  contactDetailsValidator: Validators.validateMobileNumber,
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
                        shadowColor: AppColors.shadow),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
