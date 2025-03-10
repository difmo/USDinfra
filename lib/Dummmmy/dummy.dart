// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: Text("Phone Dialer Test")),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               String phoneNumber = "+919876543210"; // Ensure it's a valid number
//               final Uri phoneUri = Uri.parse("tel:$phoneNumber"); // ✅ Correct format

//               if (await canLaunchUrl(phoneUri)) { // ✅ Fixed here
//                 await launchUrl(phoneUri, mode: LaunchMode.externalApplication);
//               } else {
//                 print("Cannot launch phone dialer");
//               }
//             },
//             child: Text("Call Now"),
//           ),
//         ),
//       ),
//     );
//   }
// }
