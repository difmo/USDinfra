
import 'package:flutter/material.dart';

class PropertyDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property Details'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Post Via WhatsApp', style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Where is your property located?'),
            TextField(decoration: InputDecoration(labelText: 'City')),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.location_on, color: Colors.blue),
              label: Text('Detect my location', style: TextStyle(color: Colors.blue)),
            ),
            _buildSectionTitle('Add Room Details'),
            _buildChipOptions('No. of Bedrooms', ['1', '2', '3', '4', '5+']),
            _buildChipOptions('No. of Bathrooms', ['1', '2', '3', '4+']),
            _buildChipOptions('Balconies', ['0', '1', '2', '3', 'More than 3']),
            _buildSectionTitle('Add Area Details'),
            Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Carpet Area'))),
                SizedBox(width: 10),
                Expanded(child: DropdownButtonFormField(items: ['sq.ft.'].map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(), onChanged: (value) {})),
              ],
            ),
            _buildSectionTitle('Floor Details'),
            TextField(decoration: InputDecoration(labelText: 'Total Floors')),
            _buildSectionTitle('Availability Status'),
            _buildChipOptions('', ['Ready to move', 'Under construction']),
            _buildSectionTitle('Ownership'),
            _buildChipOptions('', ['Freehold', 'Leasehold', 'Co-operative society', 'Power of Attorney']),
            _buildSectionTitle('Price Details'),
            TextField(decoration: InputDecoration(labelText: '₹ Expected Price')),
            _buildCheckboxOptions(['All inclusive price', 'Price Negotiable', 'Tax and Govt. charges excluded']),
            _buildSectionTitle('What makes your property unique'),
            TextField(
              maxLength: 5000,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share some details about your property... ',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
              child: Text('Post and Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 5),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildChipOptions(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) _buildSectionTitle(title),
        Wrap(
          spacing: 8.0,
          children: options.map((e) => ChoiceChip(label: Text(e), selected: false, onSelected: (val) {})).toList(),
        ),
      ],
    );
  }

  Widget _buildCheckboxOptions(List<String> options) {
    return Column(
      children: options.map((e) => CheckboxListTile(title: Text(e), value: false, onChanged: (val) {})).toList(),
    );
  }
}