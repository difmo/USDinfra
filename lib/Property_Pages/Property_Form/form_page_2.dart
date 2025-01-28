import 'package:flutter/material.dart';

class PropertyForm2 extends StatefulWidget {
  @override
  _AddPropertyDetailsState createState() => _AddPropertyDetailsState();
}

class _AddPropertyDetailsState extends State<PropertyForm2> {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController subLocalityController = TextEditingController();
  final TextEditingController apartmentController = TextEditingController();
  final TextEditingController plotAreaController = TextEditingController();
  final TextEditingController totalFloorsController = TextEditingController();
  final TextEditingController expectedPriceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String areaUnit = 'cents';
  String? availabilityStatus;
  String? ownershipType;
  bool allInclusivePrice = false;
  bool taxExcluded = true;

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
            buildSectionTitle('Where is your property located?'),
            buildTextField('City', cityController),
            buildTextField('Locality', localityController),
            buildTextField('Sub Locality (Optional)', subLocalityController),
            buildTextField('Apartment / Society (Optional)', apartmentController),
            const SizedBox(height: 20),
            buildSectionTitle('Add Area Details'),
            Row(
              children: [
                Expanded(
                  child: buildTextField('Plot Area', plotAreaController),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: areaUnit,
                  onChanged: (value) {
                    setState(() {
                      areaUnit = value!;
                    });
                  },
                  items: ['cents', 'sq.ft', 'acres']
                      .map((unit) => DropdownMenuItem(
                    value: unit,
                    child: Text(unit),
                  ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            buildSectionTitle('Floor Details'),
            buildTextField('Total Floors', totalFloorsController),
            const SizedBox(height: 20),
            buildSectionTitle('Availability Status'),
            Wrap(
              spacing: 10,
              children: ['Ready to move', 'Under construction']
                  .map((status) => ChoiceChip(
                label: Text(status),
                selected: availabilityStatus == status,
                onSelected: (selected) {
                  setState(() {
                    availabilityStatus =
                    selected ? status : availabilityStatus;
                  });
                },
                backgroundColor: Colors.white,
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            buildSectionTitle('Ownership'),
            Wrap(
              spacing: 10,
              children: [
                'Freehold',
                'Leasehold',
                'Co-operative society',
                'Power of Attorney'
              ]
                  .map((type) => ChoiceChip(
                label: Text(type),
                selected: ownershipType == type,
                onSelected: (selected) {
                  setState(() {
                    ownershipType = selected ? type : ownershipType;
                  });
                },
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            buildSectionTitle('Price Details'),
            buildTextField('Expected Price', expectedPriceController),
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
            buildSectionTitle('What makes your property unique'),
            buildTextField(
              'Share some details about your property...',
              descriptionController,
              maxLines: 3,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Post and Continue',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget buildTextField(String hintText, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    );
  }
}
