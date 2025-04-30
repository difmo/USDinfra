import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/configs/font_family.dart';
import '../../Controllers/authentication_controller.dart';
import '../../Customs/form_input_field.dart';
import '../../configs/app_colors.dart';
import 'Form_Page_2_Components/Owenership_compo.dart';
import 'Form_Page_2_Components/adress_compo.dart';
import 'Form_Page_2_Components/loan_and_approve.dart';
import 'Form_Page_2_Components/plot_area.dart';
import 'Form_Page_2_Components/price_detail_compo.dart';
import 'form_page_3.dart';
// import 'form_page_3.dart';

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
  bool allInclusivePrice = false;
  bool taxExcluded = false;
  bool isLoading = false;
  bool isDeleted = false;
  bool isPurchesed = false;
  String _selectedUnit = 'SQFT';
  final List<String> _units = ['SQFT', 'SQYD', 'SQMD'];
  final GlobalKey<LoanAndApprovalSectionState> loanSectionKey =
      GlobalKey<LoanAndApprovalSectionState>();

  Future<void> saveToFirestore() async {
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
      isLoading = true; // Show loader
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'User is not logged in.',
            style: TextStyle(
              fontFamily: AppFontFamily.primaryFont,
            ),
          )),
        );
        return;
      }
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('AppUsers')
          .doc(user.uid)
          .get();
      if (!userDoc.exists) {
        print("User document not found in AppUsers collection.");
        return;
      }
      if (userDoc['name'] is! String) {
        print("Error: 'name' field is not a String.");
        return;
      }

      String name = userDoc['name'];
      print("User Name: $name");

      DocumentReference newPropertyRef =
          await FirebaseFirestore.instance.collection('AppProperties').add({
        'city': controllers.cityController.text,
        'lookingTo': widget.formData['lookingTo'],
        'uid': user.uid,
        'isPurchesed': isPurchesed,
        'contactName': name,
        'isDeleted': isDeleted,
        'unit': _selectedUnit,
        'propertyType': widget.formData['propertyType'],
        'propertyCategory': widget.formData['propertyCategory'],
        'contactDetails': '+91${widget.formData['contactDetails']}',
        'locality': controllers.localityController.text,
        // 'subLocality': controllers.subLocalityController.text,
        // 'apartment/Society': controllers.apartmentController.text,
        'title': controllers.propertyName.text,
        'plotArea': controllers.plotAreaController.text,
        // 'totalFloors': controllers.totalFloorsController.text,
        'availabilityStatus': availabilityStatus,
        'ownershipType': ownershipType,
        'totalPrice': controllers.totalexpectedPriceController.text,
        'expectedPrice': '₹ ${controllers.expectedPriceController.text}/SQFT',
        // 'allInclusivePrice': allInclusivePrice,
        // 'taxExcluded': taxExcluded,
        'loanAvailable': loanAvailable,
        'propertyApproved': propertyApproved,
        'reraApproved': reraApproved,
        'reraNumber': reraNumber,
        'description': controllers.descriptionController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      String docId = newPropertyRef.id;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Property saved successfully!',
          style: TextStyle(
            fontFamily: AppFontFamily.primaryFont,
          ),
        )),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPhotosDetailsPage(docId: docId),
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

  @override
  void initState() {
    super.initState();
    controllers.plotAreaController.addListener(updateTotalPrice);
    controllers.expectedPriceController.addListener(updateTotalPrice);

    print(
        "Arguments received in PropertyForm2: ${widget.formData['lookingTo']}");
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
                  'Property Builder  Name',
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
                    hint: "Property Builder  Name",
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
            Row(
              children: [
                Expanded(
                  child: PlotAreaInputField(
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
            const SizedBox(height: 20),
            OwnershipSelector(
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
            OwnershipSelector(
              title: 'Availability Status',
              options: ['Ready to move', 'Under construction' , 'Immediately'],
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
                Text('Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.primaryFont,
                    )),
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
                ), // Make sure to call the saveToFirestore function
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
            )
          ],
        ),
      ),
    );
  }
}
