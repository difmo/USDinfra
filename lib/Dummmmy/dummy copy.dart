// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: NotificationScreen(),
//     );
//   }
// }

// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         title: const Text(
//           "Your Notifications",
//           style: TextStyle(color: Colors.black, fontSize: 18),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//               // Handle settings action
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20.0),
//               child: Image.asset(
//                 'assets/icons/notification_bell.png',
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "You do not have any notification yet",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.black,
//                fontWeight: FontWeight.bold
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.grey[200],
//     );
//   }
// }
