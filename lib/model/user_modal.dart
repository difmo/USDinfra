// user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // Firestore document ID
  final String userId;
  final String name;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  final String role;
  final String dealerType;
  final DateTime createdAt;
  final List<dynamic> favoriteProperties;
  final List<dynamic> purchesedProperties;

  UserModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.password,
    required this.confirmPassword,
    required this.role,
    required this.dealerType,
    required this.createdAt,
    required this.favoriteProperties,
    required this.purchesedProperties,
  });

  factory UserModel.fromDocument(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      userId: data['userId'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
      password: data['passWord'] ?? '',
      confirmPassword: data['confirmpassWord'] ?? '',
      role: data['role'] ?? '',
      dealerType: data['dealerType'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      favoriteProperties: data['favoriteProperties'] ?? [],
      purchesedProperties: data['purchesedProperties'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'mobile': mobile,
      'passWord': password,
      'confirmpassWord': confirmPassword,
      'role': role,
      'dealerType': dealerType,
      'createdAt': createdAt,
      'favoriteProperties': favoriteProperties,
      'purchesedProperties': purchesedProperties,
    };
  }
}
