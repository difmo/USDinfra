import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

import '../Controllers/authentication_controller.dart';
import '../Customs/CustomAppBar.dart';
import '../Customs/custom_textfield.dart';
import 'Property_Form/form_page_1_components/Contact_Details.dart';
import 'Property_Form/form_page_1_components/Looking_To_Property.dart';
import 'Property_Form/form_page_1_components/Property_Category.dart';
import 'Property_Form/form_page_1_components/Property_Type.dart';

class EditPropertyPage extends StatefulWidget {
  final String docId; // Pass docId to the constructor

  const EditPropertyPage({Key? key, required this.docId}) : super(key: key);

  @override
  State<EditPropertyPage> createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  String? imageUrl;
  String? lookingTo;
  String? propertyType;
  String? propertyCategory;
  final controllers = ControllersManager();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPropertyData();
  }

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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Choose Image Source",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
                icon: Icon(Icons.camera_alt, color: Colors.white),
                label: Text("Camera",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
                icon: Icon(Icons.photo, color: Colors.white),
                label: Text("Gallery",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _fetchPropertyData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('AppProperties')
          .doc(widget.docId)
          .get();
      if (docSnapshot.exists) {
        final propertyData = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          lookingTo = propertyData['lookingTo'];
          propertyType = propertyData['propertyType'];
          propertyCategory = propertyData['propertyCategory'];
          controllers.contactController.text =
              propertyData['contactDetails'] ?? '';
          controllers.expectedPriceController.text =
              propertyData['expectedPrice'] ?? '';
          controllers.descriptionController.text =
              propertyData['description'] ?? '';
          imageUrl = propertyData['imageUrl']; // Fetch image URL

          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Document not found');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching property data: $e');
    }
  }

  void _saveProperty() async {
    if (_formKey.currentState!.validate()) {
      final updatedData = {
        'lookingTo': lookingTo,
        'propertyType': propertyType,
        'propertyCategory': propertyCategory,
        'imageUrl': imageUrl, // Save the image URL
        'contactDetails': controllers.contactController.text,
        'expectedPrice': controllers.expectedPriceController.text,
        'description': controllers.descriptionController.text,
      };

      try {
        await FirebaseFirestore.instance
            .collection('AppProperties')
            .doc(widget.docId)
            .update(updatedData);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            "Property updated successfully!",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          )),
        );
        Navigator.pop(context, updatedData);
      } catch (e) {
        print('Error updating property data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            "Error updating property",
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Edit Property'),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Edit Property'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Property Image',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFontFamily.primaryFont,
                  )),
              const SizedBox(height: 8),
              Stack(
                children: [
                  if (_selectedImage != null)
                    Image.file(
                      _selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    )
                  else if (imageUrl != null)
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: ElevatedButton.icon(
                      onPressed: () => _showImageSourceDialog(context),
                      icon: const Icon(Icons.add_a_photo, color: Colors.white),
                      label: Text("Change Image",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: AppFontFamily.primaryFont,
                          )),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LookingToColumn(
                lookingTo: lookingTo,
                onSelectLookingTo: (value) {
                  setState(() {
                    lookingTo = value;
                    propertyType = null;
                    propertyCategory = null;
                  });
                },
                // lookingToError: _lookingToError,
              ),
              const SizedBox(height: 16),
              PropertyTypeColumn(
                propertyType: propertyType,
                onSelectPropertyType: (value) {
                  setState(() {
                    propertyType = value;
                    propertyCategory = null;
                  });
                },
                propertyTypes: getPropertyTypes(),
                // propertyTypeError: _propertyTypeError,
              ),
              const SizedBox(height: 16),
              PropertyCategoryColumn(
                propertyCategory: propertyCategory,
                onSelectPropertyCategory: (value) {
                  setState(() {
                    propertyCategory = value;
                  });
                },
                propertyCategories: getPropertyCategories(),
                // propertyCategoryError: _propertyCategoryError,
              ),
              const SizedBox(height: 16),
              ContactDetailsColumn(
                controller: controllers.contactController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact details';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value) &&
                      !value.contains('@')) {
                    return 'Please enter a valid phone number or email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('Expected Price',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: AppFontFamily.primaryFont,
                  )),
              SizedBox(height: 8),
              CustomInputField(
                  controller: controllers.expectedPriceController,
                  hintText: 'Expected Price'),
              const SizedBox(height: 16),
              Text('Property Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.primaryFont,
                  )),
              SizedBox(height: 8),
              CustomInputField(
                controller: controllers.descriptionController,
                hintText: 'Share some details about your property...',
                // maxlines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProperty,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: AppFontFamily.primaryFont,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
