// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webdding/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<Customer?> customers;

  Future<bool> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Đăng nhập thành công, bạn có thể truy cập thông tin người dùng từ userCredential.user

      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false; // Đăng nhập thất bại
    }
  }

  Future<String?> signUpWithEmailAndPassword(String email, String phoneNumber,
      String fullName, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Thêm thông tin người dùng vào Firebase Firestore hoặc Realtime Database
      // Ví dụ sử dụng Firebase Firestore:
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        // Fix this line
        'email': email,
        'phoneNumber': phoneNumber,
        'fullName': fullName,
      });

      return null; // Trả về null nếu đăng ký thành công
    } catch (error) {
      return 'Đã xảy ra lỗi: $error'; // Trả về thông báo lỗi nếu có lỗi
    }
  }
}
