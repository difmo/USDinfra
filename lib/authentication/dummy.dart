// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(MaterialApp(
//     home: PropertyDetailsPage(),
//   ));
// }
//
// class PropertyDetailsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Property Details'),
//         actions: [
//           TextButton(
//             onPressed: () {},
//             child: Text('Post Via WhatsApp', style: TextStyle(color: Colors.blue)),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionTitle('Where is your property located?'),
//             TextField(decoration: InputDecoration(labelText: 'City')),
//             TextButton.icon(
//               onPressed: () {},
//               icon: Icon(Icons.location_on, color: Colors.blue),
//               label: Text('Detect my location', style: TextStyle(color: Colors.blue)),
//             ),
//             _buildSectionTitle('Add Room Details'),
//             _buildChipOptions('No. of Bedrooms', ['1', '2', '3', '4', '5+']),
//             _buildChipOptions('No. of Bathrooms', ['1', '2', '3', '4+']),
//             _buildChipOptions('Balconies', ['0', '1', '2', '3', 'More than 3']),
//             _buildSectionTitle('Add Area Details'),
//             Row(
//               children: [
//                 Expanded(child: TextField(decoration: InputDecoration(labelText: 'Carpet Area'))),
//                 SizedBox(width: 10),
//                 Expanded(child: DropdownButtonFormField(items: ['sq.ft.'].map((e) => DropdownMenuItem(child: Text(e), value: e)).toList(), onChanged: (value) {})),
//               ],
//             ),
//             _buildSectionTitle('Floor Details'),
//             TextField(decoration: InputDecoration(labelText: 'Total Floors')),
//             _buildSectionTitle('Availability Status'),
//             _buildChipOptions('', ['Ready to move', 'Under construction']),
//             _buildSectionTitle('Ownership'),
//             _buildChipOptions('', ['Freehold', 'Leasehold', 'Co-operative society', 'Power of Attorney']),
//             _buildSectionTitle('Price Details'),
//             TextField(decoration: InputDecoration(labelText: '₹ Expected Price')),
//             _buildCheckboxOptions(['All inclusive price', 'Price Negotiable', 'Tax and Govt. charges excluded']),
//             _buildSectionTitle('What makes your property unique'),
//             TextField(
//               maxLength: 5000,
//               minLines: 3,
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintText: 'Share some details about your property... ',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
//               child: Text('Post and Continue'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, bottom: 5),
//       child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
//     );
//   }
//
//   Widget _buildChipOptions(String title, List<String> options) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (title.isNotEmpty) _buildSectionTitle(title),
//         Wrap(
//           spacing: 8.0,
//           children: options.map((e) => ChoiceChip(label: Text(e), selected: false, onSelected: (val) {})).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCheckboxOptions(List<String> options) {
//     return Column(
//       children: options.map((e) => CheckboxListTile(title: Text(e), value: false, onChanged: (val) {})).toList(),
//     );
//   }
// }


import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPropertyPage extends StatefulWidget {
  final String docId;

  const EditPropertyPage({Key? key, required this.docId}) : super(key: key);

  @override
  _EditPropertyPageState createState() => _EditPropertyPageState();
}

class _EditPropertyPageState extends State<EditPropertyPage> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = [];
  List<String> _imageUrls = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPropertyData();
  }

  // Fetch property data including image URLs
  Future<void> _fetchPropertyData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('AppProperties')
          .doc(widget.docId)
          .get();

      if (docSnapshot.exists) {
        final propertyData = docSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _imageUrls = List<String>.from(propertyData['imageUrls'] ?? []);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error fetching property data: $e');
    }
  }

  // Select multiple images
  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages = pickedFiles.map((e) => File(e.path)).toList();
      });

      // Upload images
      _uploadImages();
    }
  }

  // Upload images to Firebase Storage
  Future<void> _uploadImages() async {
    List<String> uploadedUrls = [];

    for (var image in _selectedImages) {
      try {
        String fileName = 'property_images/${widget.docId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
        Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        uploadedUrls.add(downloadUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    // Update Firestore with new image URLs
    if (uploadedUrls.isNotEmpty) {
      setState(() {
        _imageUrls.addAll(uploadedUrls);
      });

      await FirebaseFirestore.instance
          .collection('AppProperties')
          .doc(widget.docId)
          .update({'imageUrls': _imageUrls});
    }
  }

  // Delete image from Firebase and Firestore
  Future<void> _deleteImage(String imageUrl) async {
    try {
      // Delete from Firebase Storage
      Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();

      // Update Firestore
      setState(() {
        _imageUrls.remove(imageUrl);
      });

      await FirebaseFirestore.instance
          .collection('AppProperties')
          .doc(widget.docId)
          .update({'imageUrls': _imageUrls});
    } catch (e) {
      print("Error deleting image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Property')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Edit Property')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Property Images',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            // Display selected images in a grid
            _imageUrls.isNotEmpty
                ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _imageUrls.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Display 3 images per row
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.network(_imageUrls[index], fit: BoxFit.cover),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _deleteImage(_imageUrls[index]),
                      ),
                    ),
                  ],
                );
              },
            )
                : Container(
              height: 150,
              color: Colors.grey[300],
              child: const Center(child: Text("No Images Available")),
            ),

            const SizedBox(height: 8),

            // Button to choose images
            ElevatedButton.icon(
              onPressed: _pickImages,
              icon: const Icon(Icons.add_a_photo, color: Colors.white),
              label: const Text("Add Images", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),

            const SizedBox(height: 16),

            // Align Save Button to the Right
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {}, // Add property update logic
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                child: const Text('Save Changes',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
