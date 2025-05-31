import 'package:flutter/material.dart';

class PropertyGallery extends StatefulWidget {
  final List<dynamic> imageUrls;

  const PropertyGallery({Key? key, required this.imageUrls}) : super(key: key);

  @override
  _PropertyGalleryState createState() => _PropertyGalleryState();
}

class _PropertyGalleryState extends State<PropertyGallery> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Property View",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    FullGalleryPage(imageUrls: widget.imageUrls),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: widget.imageUrls.take(4).map((url) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    url,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class FullGalleryPage extends StatelessWidget {
  final List<dynamic> imageUrls;

  const FullGalleryPage({Key? key, required this.imageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Gallery'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: imageUrls.map((url) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
