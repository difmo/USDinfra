import 'package:flutter/material.dart';

class PropertyDetailsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Property Details'),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Post via WhatsApp', style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Where is your property located?', style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(decoration: InputDecoration(labelText: 'City')),
            TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.location_on, color: Colors.blue),
              label: Text('Detect my location', style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(height: 10),
            _buildSectionTitle('Add Area Details'),
            Row(
              children: [
                Expanded(child: TextField(decoration: InputDecoration(labelText: 'Plot Area'))),
                SizedBox(width: 10),
                Expanded(child: TextField(decoration: InputDecoration(labelText: 'sq.ft.'))),
              ],
            ),
            _buildSectionTitle('Property Dimensions (Optional)'),
            TextField(decoration: InputDecoration(labelText: 'Length of plot (in Ft.)')),
            TextField(decoration: InputDecoration(labelText: 'Breadth of plot (in Ft.)')),
            _buildSectionTitle('Floors Allowed For Construction'),
            TextField(decoration: InputDecoration(labelText: 'No. of floors')),
            _buildSectionTitle('Is there a boundary wall around the property?'),
            _buildRadioOptions(['Yes', 'No']),
            _buildSectionTitle('No. of open sides'),
            _buildNumberOptions([1, 2, 3, '3+']),
            _buildSectionTitle('Any construction done on this property?'),
            _buildRadioOptions(['Yes', 'No']),
            _buildSectionTitle('Possession By'),
            DropdownButtonFormField(
              items: ['Expected By'].map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(),
              onChanged: (value) {},
              decoration: InputDecoration(),
            ),
            _buildSectionTitle('Ownership'),
            _buildChipOptions(['Freehold', 'Leasehold', 'Co-operative society', 'Power of Attorney']),
            _buildSectionTitle('Price Details'),
            TextField(decoration: InputDecoration(labelText: '₹ Expected Price')),
            _buildCheckboxOptions(['All inclusive price', 'Price Negotiable', 'Tax and Govt. charges excluded']),
            _buildSectionTitle('What makes your property unique'),
            TextField(
              maxLength: 500,
              minLines: 3,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Share some details about your property...',
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

  Widget _buildRadioOptions(List<String> options) {
    return Row(
      children: options
          .map((e) => Row(
        children: [
          Radio(value: e, groupValue: null, onChanged: (value) {}),
          Text(e),
        ],
      ))
          .toList(),
    );
  }

  Widget _buildNumberOptions(List<dynamic> options) {
    return Row(
      children: options
          .map((e) => Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ChoiceChip(label: Text(e.toString()), selected: false, onSelected: (val) {}),
      ))
          .toList(),
    );
  }

  Widget _buildChipOptions(List<String> options) {
    return Wrap(
      spacing: 8.0,
      children: options
          .map((e) => ChoiceChip(label: Text(e), selected: false, onSelected: (val) {}))
          .toList(),
    );
  }

  Widget _buildCheckboxOptions(List<String> options) {
    return Column(
      children: options.map((e) => CheckboxListTile(title: Text(e), value: false, onChanged: (val) {})).toList(),
    );
  }
}
