import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usdinfra/model/user_modal.dart';

class UserController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Fetch current logged-in user's data
  Future<UserModel?> fetchCurrentUserData() async {
    print('fetchCurrentUserData called');
    try {
      final currentUser = _auth.currentUser;
      print('Current user: $currentUser');
      if (currentUser == null) {
        print('No user is logged in');
        return null;
      }

      print('Fetching document for user: ${currentUser.uid}');
      final doc =
          await _firestore.collection('AppUsers').doc(currentUser.uid).get();

      print('Document fetched: exists=${doc.exists}');
      if (doc.exists) {
        print('User document data: ${doc.data()}');
        final userModel = UserModel.fromDocument(doc.id, doc.data()!);
        print('UserModel created: $userModel');
        print(userModel.dealerType);
        return userModel;
      } else {
        print('User document not found');
        return null;
      }
    } catch (e) {
      print('Error fetching current user data: $e');
      return null;
    }
  }
}
