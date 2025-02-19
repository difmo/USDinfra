import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usdinfra/Components/Choice_Chip.dart';
import 'package:usdinfra/routes/app_routes.dart';
import '../../Controllers/authentication_controller.dart';
import '../../Customs/custom_textfield.dart';
import '../../conigs/app_colors.dart';

class PropertyForm2 extends StatefulWidget {
  Map<String, String?>?  formData;
   PropertyForm2({super.key, required this.formData});

  @override
  State<PropertyForm2> createState() => _PropertyForm2State();
}

class _PropertyForm2State extends State<PropertyForm2> {
  Map<String, String?>? get formData => widget.formData;
  final controllers = ControllersManager();
  String? availabilityStatus;
  String? ownershipType;
  bool allInclusivePrice = false;
  bool taxExcluded = false;
  bool isLoading = false;
  bool isDeleted = false;
  Future<void> saveToFirestore() async {
    setState(() {
      isLoading = true; // Show loader
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null){
        print("User not logged in .");
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
      String userId = userDoc['userId'];

      await FirebaseFirestore.instance.collection('AppProperties').add({
        'city': controllers.cityController.text,
        'lookingTo':formData?['lookingTo'],
        'createdBy': userId,
        'uid':user.uid,
        'isDeleted' : isDeleted,
        'propertyType':formData?['propertyType'],
        'propertyCategory':formData?[' propertyCategory'],
        'contactDetails': formData?['contactDetails'],
        'locality': controllers.localityController.text,
        'subLocality': controllers.subLocalityController.text,
        'apartment': controllers.apartmentController.text,
        'plotArea': controllers.plotAreaController.text,
        'totalFloors': controllers.totalFloorsController.text,
        'availabilityStatus': availabilityStatus,
        'ownershipType': ownershipType,
        'expectedPrice': '₹${controllers.expectedPriceController.text}',
        'allInclusivePrice': allInclusivePrice,
        'taxExcluded': taxExcluded,
        'description': controllers.descriptionController.text,
        'createdAt': FieldValue.serverTimestamp(),
        'imageUrl': 'https://media.istockphoto.com/id/1323734125/photo/worker-in-the-construction-site-making-building.jpg?s=612x612&w=0&k=20&c=b_F4vFJetRJu2Dk19ZfVh-nfdMfTpyfm7sln-kpauok=',

      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Property saved successfully!')),
      );

      Navigator.pushNamed(context ,AppRouts.dashBoard);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    print("Arguments received in PropertyForm2: ${formData?['lookingTo']}");
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
        actions: [
          // TextButton(
          //   onPressed: () {},
          //   child: const Text(
          //     'Post Via WhatsApp',
          //     style: TextStyle(color: Colors.green, fontSize: 14),
          //   ),
          // ),
        ],
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
            const SizedBox(height: 20),
            Text('Where is your property located?',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary)),
            SizedBox(height: 8),
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
                  CustomInputField(
                      controller: controllers.cityController,
                      hintText: 'Enter City Name'),
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
                  CustomInputField(
                      controller: controllers.localityController,
                      hintText: 'Locality'),
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
                  CustomInputField(
                      controller: controllers.subLocalityController,
                      hintText: 'Sub Locality'),
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
                  CustomInputField(
                      controller: controllers.apartmentController,
                      hintText: 'Apartment / Society'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Add Area Details',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary)),
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
                        CustomInputField(
                            controller: controllers.plotAreaController,
                            hintText: 'Plot Area'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                  CustomInputField(
                      controller: controllers.totalFloorsController,
                      hintText: 'Total Floors'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Availability Status',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary)),
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
                    color: AppColors.primary)),
            Wrap(
              spacing: 10,
              children: [
                'Freehold',
                'Leasehold',
                'Co-operative society',
                'Power of Attorney'
              ].map((option) => ChoiceChipOption(
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
                          color: AppColors.primary)),
                  SizedBox(height: 8),
                  CustomInputField(
                      controller: controllers.expectedPriceController,
                      hintText: 'Expected Price'),
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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What makes your property unique',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary)),
                  SizedBox(height: 8),
                  CustomInputField(
                    controller: controllers.descriptionController,
                    hintText: 'Share some details about your property...',
                    // maxlines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : () => saveToFirestore(),  // Make sure to call the saveToFirestore function
                child: isLoading
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                )
                    : Text(
                  'Post and Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shadowColor: Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
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
