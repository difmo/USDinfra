// import 'package:flutter/material.dart';
// import 'package:usdinfra/configs/font_family.dart';

// class ImageUploadBox extends StatelessWidget {
//   final VoidCallback onTap;

//   const ImageUploadBox({super.key, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         height: 150,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(10),
//           color: Colors.grey.shade100,
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
//             const SizedBox(height: 8),
//             Text(
//               "+ Add at least 5 photos",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontFamily: AppFontFamily.primaryFont,
//               ),
//             ),
//             Text(
//               "Click from camera or browse to upload",
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontFamily: AppFontFamily.primaryFont,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:usdinfra/configs/app_colors.dart';
import 'package:usdinfra/configs/font_family.dart';

class MultiImageUploadBox extends StatefulWidget {
  final Function(List<File>) onImagesSelected;

  const MultiImageUploadBox({super.key, required this.onImagesSelected});

  @override
  State<MultiImageUploadBox> createState() => _MultiImageUploadBoxState();
}

class _MultiImageUploadBoxState extends State<MultiImageUploadBox> {
  final List<File> _photos = [];

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();

    if (source == ImageSource.gallery) {
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        final files = pickedFiles.map((e) => File(e.path)).toList();
        setState(() => _photos.addAll(files));
        widget.onImagesSelected(_photos);
      }
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final file = File(pickedFile.path);
        setState(() => _photos.add(file));
        widget.onImagesSelected(_photos);
      }
    }
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Choose Image Source",
          style: TextStyle(fontFamily: AppFontFamily.primaryFont),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: Text("Camera",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              icon: const Icon(Icons.photo, color: Colors.white),
              label: Text("Gallery",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFontFamily.primaryFont)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceDialog(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: _photos.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text(
                    "+ Add at least 5 photos",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                  Text(
                    "Click from camera or browse to upload",
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: AppFontFamily.primaryFont,
                    ),
                  ),
                ],
              )
            : GridView.builder(
                itemCount: _photos.length + 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  if (index == _photos.length) {
                    return GestureDetector(
                      onTap: () => _showImageSourceDialog(context),
                      child: Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.add_a_photo, color: Colors.white),
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _photos[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _photos.removeAt(index);
                              widget.onImagesSelected(_photos);
                            });
                          },
                          child: const CircleAvatar(
                            backgroundColor: Colors.black54,
                            radius: 12,
                            child: Icon(Icons.close,
                                size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
