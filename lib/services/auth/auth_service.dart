// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this line

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore.instance.collection('tests').add({
        'name': 'value1',
        'status': 'value2',
        // thêm các trường khác theo nhu cầu
      }).then((docRef) {
        // print('Document Added with ID: ${docRef.id}');
      return true; // Đăng nhập thành công
      }).catchError((error) {
        print('Error adding document: $error');
      return false; // Đăng nhập thành công
      });
      return true; // Đăng nhập thành công
    } catch (e) {
      print(e.toString());
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
