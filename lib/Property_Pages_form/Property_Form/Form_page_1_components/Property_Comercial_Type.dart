// import 'package:flutter/material.dart';
// import '../../../Components/Choice_Chip.dart';
// import '../../../Components/Error_message.dart';
//
// class PropertyComercialTypeColumn extends StatelessWidget {
//   final String? propertyCategory;
//   final ValueChanged<String?> onSelectPropertyCategory;
//   final List<String> propertyCategories;
//   final String? propertyCategoryError;
//   final String labelText;  // Add a new parameter for dynamic text
//
//   const PropertyComercialTypeColumn({
//     Key? key,
//     required this.propertyCategory,
//     required this.onSelectPropertyCategory,
//     required this.propertyCategories,
//     this.propertyCategoryError,
//     required this.labelText, // Required parameter for dynamic text
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           labelText,  // Use the dynamic text here
//           style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: propertyCategories
//               .map((option) => ChoiceChipOption(
//             label: option,
//             isSelected: propertyCategory == option,
//             onSelected: (selected) {
//               onSelectPropertyCategory(selected ? option : null);
//             },
//           ))
//               .toList(),
//         ),
//         ErrorMessage(errorText: propertyCategoryError),
//       ],
//     );
//   }
// }
