import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Property_Pages_form/Property_Form/form_page_3_components/option_chip.dart';
import 'package:usdinfra/components/bottom_sheets.dart';
import 'package:usdinfra/components/flor_form_field.dart';
import 'package:usdinfra/components/increment_decrement.dart';
import 'package:usdinfra/configs/font_family.dart';
import 'package:usdinfra/property_pages_form/property_form/form_page_2_components/custom_selector.dart';
import 'package:usdinfra/utils/constants.dart';
import '../../Controllers/authentication_controller.dart';
import '../../Customs/form_input_field.dart';
import '../../configs/app_colors.dart';
import 'form_page_2_components/adress_compo.dart';
import 'form_page_2_components/loan_and_approve.dart';
import 'form_page_2_components/plot_area.dart';
import 'form_page_2_components/price_detail_compo.dart';
import 'form_page_3.dart';

class PropertyForm2 extends StatefulWidget {
  final Map<String, dynamic> formData;

  PropertyForm2({super.key, required this.formData});

  @override
  State<PropertyForm2> createState() => _PropertyForm2State();
}

class _PropertyForm2State extends State<PropertyForm2> {
  final controllers = ControllersManager();
  String? availabilityStatus;
  String? ownershipType;
  String? selectedFloor;
  String? propertyAge; // New field
  String? facingDirection; // New field
  String? furnishingStatus; // New field
  String? floorPlan;
  bool isLoading = false;
  String _selectedUnit = 'SQFT';
  final List<String> _units = ['SQFT', 'SQYD', 'SQMD'];
  final GlobalKey<LoanAndApprovalSectionState> loanSectionKey =
      GlobalKey<LoanAndApprovalSectionState>();
  List<String> selectedOtherRooms = [];

  @override
  void initState() {
    super.initState();
    // Initialize fields from formData
    availabilityStatus = widget.formData['availabilityStatus'];
    ownershipType = widget.formData['ownershipType'];
    selectedFloor = widget.formData['propertyOnFloor'];
    propertyAge = widget.formData['propertyAge'];
    facingDirection = widget.formData['facingDirection'];
    furnishingStatus = widget.formData['furnishingStatus'];
    _selectedUnit = widget.formData['unit'] ?? 'SQFT';
    controllers.propertyName.text = widget.formData['title'] ?? '';
    controllers.cityController.text = widget.formData['city'] ?? '';
    controllers.localityController.text = widget.formData['locality'] ?? '';
    controllers.plotAreaController.text = widget.formData['plotArea'] ?? '';
    controllers.expectedPriceController.text = widget.formData['expectedPrice']
            ?.replaceAll('₹ ', '')
            .replaceAll('/SQFT', '') ??
        '';
    controllers.totalexpectedPriceController.text =
        widget.formData['totalPrice'] ?? '';
    controllers.descriptionController.text =
        widget.formData['description'] ?? '';
    controllers.lengthController.text = widget.formData['length'] ?? '';
    controllers.widthAreaController.text = widget.formData['breadth'] ?? '';
    controllers.noOfOpenSidesController.text =
        widget.formData['noOfOpenSides'] ?? '';
    controllers.reraNumberController.text = widget.formData['reraNumber'] ?? '';

    controllers.plotAreaController.addListener(updateTotalPrice);
    controllers.expectedPriceController.addListener(updateTotalPrice);
  }

  String? validateForm() {
    if (controllers.propertyName.text.trim().isEmpty) {
      return 'Property Builder Name is required';
    }
    if (controllers.cityController.text.trim().isEmpty) {
      return 'City is required';
    }
    if (controllers.localityController.text.trim().isEmpty) {
      return 'Location is required';
    }
    if (controllers.plotAreaController.text.trim().isEmpty) {
      return 'Plot Area is required';
    }
    if (ownershipType == null || ownershipType!.isEmpty) {
      return 'Ownership Type is required';
    }
    if (availabilityStatus == null || availabilityStatus!.isEmpty) {
      return 'Availability Status is required';
    }
    if (controllers.expectedPriceController.text.trim().isEmpty) {
      return 'Expected Price is required';
    }
    if (controllers.totalexpectedPriceController.text.trim().isEmpty) {
      return 'Total Price is required';
    }
    if (controllers.descriptionController.text.trim().isEmpty) {
      return 'Description is required';
    }
    // if (widget.formData["propertyCategory"] != "Plot/Land" &&
    //     (furnishingStatus == null || furnishingStatus!.isEmpty)) {
    //   return 'Furnishing Status is required';
    // }
    // if (widget.formData["propertyCategory"] == "Plot/Land" &&
    //     (facingDirection == null || facingDirection!.isEmpty)) {
    //   return 'Facing Direction is required';
    // }
    return null;
  }

  Future<void> saveToFirestore() async {
    final validationError = validateForm();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            validationError,
            style: TextStyle(fontFamily: AppFontFamily.primaryFont),
          ),
        ),
      );
      return;
    }

    final loanAvailable = loanSectionKey.currentState?.loanAvailable;
    final propertyApproved =
        loanSectionKey.currentState?.propertyApprovedStatus;
    final reraApproved = loanSectionKey.currentState?.reraApprovedStatus;
    final reraNumber = loanSectionKey.currentState?.reraNumber;
    if (propertyApproved == 'Yes' &&
        reraApproved == 'Yes' &&
        (reraNumber == null || reraNumber.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter RERA number')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User is not logged in.',
              style: TextStyle(fontFamily: AppFontFamily.primaryFont),
            ),
          ),
        );
        return;
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.uid)
          .get();
      if (!userDoc.exists || userDoc['name'] is! String) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'User data not found.',
              style: TextStyle(fontFamily: AppFontFamily.primaryFont),
            ),
          ),
        );
        return;
      }

      String name = userDoc['name'];
      DocumentReference newPropertyRef =
          await FirebaseFirestore.instance.collection('AppProperties').add({
        'city': controllers.cityController.text,
        'lookingTo': widget.formData['lookingTo'],
        'uid': user.uid,
        'isPurchesed': false,
        'contactName': name,
        'isDeleted': false,
        'unit': _selectedUnit,
        'propertyType': widget.formData['propertyType'],
        'propertyCategory': widget.formData['propertyCategory'],
        'contactDetails': '+91${widget.formData['contactDetails']}',
        'bedrooms': widget.formData['bedrooms'],
        'bathrooms': widget.formData['bathrooms'],
        'balconies': widget.formData['balconies'],
        'otherRooms': widget.formData['otherRooms'],
        'openparking': widget.formData['openparking'],
        'coveredparking': widget.formData['coveredparking'],
        'locality': controllers.localityController.text,
        'title': controllers.propertyName.text,
        'plotArea': controllers.plotAreaController.text,
        'availabilityStatus': availabilityStatus,
        'ownershipType': ownershipType,
        'floorPlan': floorPlan,
        'totalPrice': controllers.totalexpectedPriceController.text,
        'expectedPrice': '₹ ${controllers.expectedPriceController.text}/SQFT',
        'loanAvailable': loanAvailable,
        'propertyApproved': propertyApproved,
        'reraApproved': reraApproved,
        'reraNumber': reraNumber,
        'description': controllers.descriptionController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'length': controllers.lengthController.text,
        'breadth': controllers.widthAreaController.text,
        'noOfOpenSides': controllers.noOfOpenSidesController.text,
        'propertyOnFloor': selectedFloor,
        'propertyAge': propertyAge,
        'facingDirection': facingDirection,
        'furnishingStatus': furnishingStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Property saved successfully!',
            style: TextStyle(fontFamily: AppFontFamily.primaryFont),
          ),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPhotosDetailsPage(docId: newPropertyRef.id),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void updateTotalPrice() {
    final plotAreaText = controllers.plotAreaController.text;
    final expectedPriceText = controllers.expectedPriceController.text;
    double? plotArea = double.tryParse(plotAreaText);
    double? pricePerUnit = double.tryParse(expectedPriceText);
    if (plotArea != null && pricePerUnit != null) {
      final total = plotArea * pricePerUnit;
      controllers.totalexpectedPriceController.text = total.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    controllers.plotAreaController.removeListener(updateTotalPrice);
    controllers.expectedPriceController.removeListener(updateTotalPrice);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Property Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'STEP 2 OF 3',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Property Builder Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FormTextField(
                    hint: "Property Builder Name",
                    controller: controllers.propertyName,
                    maxLength: 50,
                    inputType: TextInputType.text,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                LabeledFormField(
                  label: 'City',
                  hint: 'Enter City Name',
                  controller: controllers.cityController,
                ),
                const SizedBox(height: 8),
                LabeledFormField(
                  label: 'Location',
                  hint: 'Location',
                  controller: controllers.localityController,
                ),
              ],
            ),
            SizedBox(height: 8),
            if (widget.formData["propertyCategory"] != "Plot/Land") ...[
              CustomSelector(
                title: 'Select Your Floor Plan (optional)',
                options: AppConstants.floorPlanOptions,
                selectedOption: floorPlan,
                onOptionSelected: (value) {
                  setState(() {
                    floorPlan = value;
                  });
                },
              ),
              SizedBox(height: 18),
              Text(
                "Add Room Details",
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
              CustomSelector(
                title: 'No. of Bedrooms',
                options: AppConstants.bedroomOptions,
                selectedOption: widget.formData['bedrooms'],
                onOptionSelected: (value) {
                  setState(() {
                    widget.formData['bedrooms'] = value;
                  });
                },
              ),
              SizedBox(height: 12),
              CustomSelector(
                title: 'No. of Bathrooms',
                options: AppConstants.bathroomOptions,
                selectedOption: widget.formData['bathrooms'],
                onOptionSelected: (value) {
                  setState(() {
                    widget.formData['bathrooms'] = value;
                  });
                },
              ),
              SizedBox(height: 12),
              CustomSelector(
                title: 'Balconies',
                options: AppConstants.balconyOptions,
                selectedOption: widget.formData['balconies'],
                onOptionSelected: (value) {
                  setState(() {
                    widget.formData['balconies'] = value;
                  });
                },
              ),
              SizedBox(height: 12),
              CustomSelector(
                title: 'Property Age',
                options: AppConstants.propertyAgeOptions,
                selectedOption: propertyAge,
                onOptionSelected: (value) {
                  setState(() {
                    propertyAge = value;
                  });
                },
              ),
              SizedBox(height: 12),
            ],
            Row(
              children: [
                Expanded(
                  child: PlotAreaInputField(
                    formdata: widget.formData,
                    controller: controllers.plotAreaController,
                    selectedUnit: _selectedUnit,
                    units: _units,
                    onUnitChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedUnit = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            if (widget.formData["propertyCategory"] != "Plot/Land") ...[
              Column(
                children: [
                  ChoiceSelectorWidget(
                    title: 'Other Rooms (optional)',
                    options: AppConstants.otherRoomOptions,
                    selectedOptions: selectedOtherRooms,
                    onSelectionChanged: (furnishing) {
                      setState(() {
                        final updatedList = List<String>.from(furnishing);

                        if (updatedList.contains('Other')) {
                          updatedList
                            ..clear()
                            ..add('Other');
                        } else {
                          updatedList.remove('Other');
                        }

                        selectedOtherRooms = updatedList;
                        widget.formData['otherRooms'] = selectedOtherRooms;
                      });
                    },
                    isMultiSelect: true,
                  ),
                  // CustomSelector(
                  // title: 'Other Rooms (optional)',
                  //   options: AppConstants.otherRoomOptions,
                  //   selectedOption: widget.formData['otherRooms'],
                  //   onOptionSelected: (value) {
                  //     setState(() {
                  //       widget.formData['otherRooms'] = value;
                  //     });
                  //   },
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Reserved Parking (optional)",
                        style: TextStyle(fontSize: 21),
                      ),
                    ],
                  ),
                  IncrementDecrement(
                    lable: "Covered Parking",
                    onChanged: (value) {
                      setState(() {
                        widget.formData['coveredparking'] = value.toString();
                      });
                    },
                  ),
                  IncrementDecrement(
                    lable: "Open Parking",
                    onChanged: (value) {
                      setState(() {
                        widget.formData['openparking'] = value.toString();
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Floor Details",
                        style: TextStyle(fontSize: 21),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Total Nubmer of and floor details.",
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  FloorFormField(
                    label: "Total Floor",
                    initialFloor: selectedFloor,
                    onFloorSelected: (floor) {
                      setState(() {
                        selectedFloor = floor;
                        widget.formData['totolfloor'] =
                            floor; // Update formData
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FloorFormField(
                    label: "Property On Floor",
                    initialFloor: selectedFloor,
                    onFloorSelected: (floor) {
                      setState(() {
                        selectedFloor = floor;
                        widget.formData['propertyOnFloor'] =
                            floor; // Update formData
                      });
                    },
                  ),
                ],
              ),
            ],
            if (widget.formData["propertyCategory"] == "Plot/Land") ...[
              Column(
                children: [
                  LabeledFormField(
                    label: 'Length',
                    hint: 'Enter Length',
                    controller: controllers.lengthController,
                  ),
                  const SizedBox(height: 8),
                  LabeledFormField(
                    label: 'Breadth',
                    hint: 'Enter Breadth',
                    controller: controllers.widthAreaController,
                  ),
                  const SizedBox(height: 8),
                  LabeledFormField(
                    label: 'No. of Open Sides',
                    hint: 'Enter no. of open sides',
                    controller: controllers.noOfOpenSidesController,
                  ),
                  // CustomSelector(
                  //   title: 'Facing Direction',
                  //   options: AppConstants.facingDirectionOptions,
                  //   selectedOption: facingDirection,
                  //   onOptionSelected: (value) {
                  //     setState(() {
                  //       facingDirection = value;
                  //     });
                  //   },
                  // ),
                ],
              ),
            ],
            const SizedBox(height: 20),
            CustomSelector(
              title: 'Ownership',
              options: [
                'Freehold',
                'Leasehold',
                'Co-operative society',
                'Power of Attorney'
              ],
              selectedOption: ownershipType,
              onOptionSelected: (value) {
                setState(() {
                  ownershipType = value;
                });
              },
            ),
            const SizedBox(height: 20),
            CustomSelector(
              title: 'Availability Status',
              options: widget.formData["propertyCategory"] == "Plot/Land"
                  ? ['Ready to move', 'Under construction', 'Immediately']
                  : ['Ready to move', 'Under construction'],
              selectedOption: availabilityStatus ?? '',
              onOptionSelected: (value) {
                setState(() {
                  availabilityStatus = value;
                });
              },
            ),
            const SizedBox(height: 20),
            PriceDetailsSection(
              pricePerSqftController: controllers.expectedPriceController,
              totalPriceController: controllers.totalexpectedPriceController,
            ),
            SizedBox(height: 20),
            LoanAndApprovalSection(
              key: loanSectionKey,
              reraNumberController: controllers.reraNumberController,
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppFontFamily.primaryFont,
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FormTextField(
                    hint: "Description",
                    controller: controllers.descriptionController,
                    minLength: 5,
                    maxLength: 200,
                    inputType: TextInputType.text,
                    maxLines: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => saveToFirestore(),
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shadowColor: Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  textStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: isLoading
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(AppColors.primary),
                      )
                    : Text(
                        'Post and Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFontFamily.primaryFont,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloorPicker extends StatefulWidget {
  final int? initialFloor;
  final Function(int) onFloorSelected;

  const _FloorPicker({this.initialFloor, required this.onFloorSelected});

  @override
  _FloorPickerState createState() => _FloorPickerState();
}

class _FloorPickerState extends State<_FloorPicker> {
  late int _selectedFloor;

  @override
  void initState() {
    super.initState();
    _selectedFloor = widget.initialFloor ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select Floor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: AppFontFamily.primaryFont,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  if (_selectedFloor > 1) {
                    setState(() {
                      _selectedFloor--;
                    });
                  }
                },
              ),
              Text(
                '$_selectedFloor',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _selectedFloor++;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              widget.onFloorSelected(_selectedFloor);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              'Confirm',
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppFontFamily.primaryFont,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
