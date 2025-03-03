import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Components/Choice_Chip.dart';
import '../../Controllers/authentication_controller.dart';
import '../../Customs/form_input_field.dart';
import '../../conigs/app_colors.dart';
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
  bool allInclusivePrice = false;
  bool taxExcluded = false;
  bool isLoading = false;
  bool isDeleted = false;
  bool isPurchesed = false;

  Future<void> saveToFirestore() async {
    setState(() {
      isLoading = true; // Show loader
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User is not logged in.')),
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
        // 'contactName': name,
        'isDeleted': isDeleted,
        'propertyType': widget.formData['propertyType'],
        'propertyCategory': widget.formData['propertyCategory'],
        'contactDetails': widget.formData['contactDetails'],
        'locality': controllers.localityController.text,
        'subLocality': controllers.subLocalityController.text,
        'apartment/Society': controllers.apartmentController.text,
        'title': controllers.propertyName.text,
        'plotArea': controllers.plotAreaController.text,
        'totalFloors': controllers.totalFloorsController.text,
        'availabilityStatus': availabilityStatus,
        'ownershipType': ownershipType,
        'expectedPrice': '₹${controllers.expectedPriceController.text}',
        'allInclusivePrice': allInclusivePrice,
        'taxExcluded': taxExcluded,
        'description': controllers.descriptionController.text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      String docId = newPropertyRef.id; // Get the generated document ID

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property saved successfully!')),
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
    print(
        "Arguments received in PropertyForm2: ${widget.formData['lookingTo']}");
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }
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
        // actions: [
        //   // TextButton(
        //   //   onPressed: () {},
        //   //   child: const Text(
        //   //     'Post Via WhatsApp',
        //   //     style: TextStyle(color: Colors.green, fontSize: 14),
        //   //   ),
        //   // ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Property Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 4),
            const Text(
              'STEP 2 OF 3',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                FormTextField(
                  hint: "Property Title",
                  controller: controllers.propertyName,
                  maxLength: 50,
                  inputType: TextInputType.text,
                  maxLines: 2,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 8),
                FormTextField(
                  hint: "Description",
                  controller: controllers.descriptionController,
                  maxLength: 200,
                  inputType: TextInputType.text,
                  maxLines: 5,
                ),
              ],
            ),
            Text('Where is your property located?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('City',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 8),
                  FormTextField(
                    controller: controllers.cityController,
                    hint: 'Enter City Name',
                    borderRadius: 25,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Locality ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 8),
                  FormTextField(
                      controller: controllers.localityController,
                      hint: 'Locality',
                      borderRadius: 25),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sub Locality',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 8),
                  FormTextField(
                      controller: controllers.subLocalityController,
                      hint: 'Sub Locality',
                      borderRadius: 25),
                ],
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Apartment / Society',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 8),
                  FormTextField(
                      controller: controllers.apartmentController,
                      hint: 'Apartment / Society',
                      borderRadius: 25),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Add Area Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8),
                        Text('Plot Area',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(height: 8),
                        FormTextField(
                            controller: controllers.plotAreaController,
                            hint: 'Plot Area',
                            borderRadius: 25),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Floor Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 8),
                  FormTextField(
                      controller: controllers.totalFloorsController,
                      hint: 'Total Floors',
                      borderRadius: 25),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Availability Status',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            Wrap(
              spacing: 10,
              children: ['Ready to move', 'Under construction']
                  .map((option) => ChoiceChipOption(
                        label: option,
                        isSelected: availabilityStatus == option,
                        onSelected: (selected) {
                          setState(() {
                            availabilityStatus =
                                selected ? option : availabilityStatus;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text('Ownership',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
            Wrap(
              spacing: 10,
              children: [
                'Freehold',
                'Leasehold',
                'Co-operative society',
                'Power of Attorney'
              ]
                  .map((option) => ChoiceChipOption(
                        label: option,
                        isSelected: ownershipType == option,
                        onSelected: (selected) {
                          setState(() {
                            ownershipType = selected ? option : ownershipType;
                          });
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  SizedBox(height: 8),
                  FormTextField(
                    controller: controllers.expectedPriceController,
                    hint: 'Expected Price',
                    borderRadius: 25,
                    inputType: TextInputType.phone,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Checkbox(
                  value: allInclusivePrice,
                  onChanged: (value) {
                    setState(() {
                      allInclusivePrice = value!;
                    });
                  },
                ),
                const Text('All inclusive price'),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: taxExcluded,
                  onChanged: (value) {
                    setState(() {
                      taxExcluded = value!;
                    });
                  },
                ),
                const Text('Tax and Govt. charges excluded'),
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
                            fontWeight: FontWeight.bold),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
