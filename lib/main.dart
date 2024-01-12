import 'package:flutter/material.dart';
import 'package:webdding/screens/login_screen.dart'; // Import the firebase_core package
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is initialized
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBvdP5e6OYm9CnzTrQBsUisnrSMz0nc6WA",
      appId: "1:998419502613:android:707442e03b4c8e04f6e01c",
      messagingSenderId: "998419502613",
      projectId: "webdding-b9b1e",
    ),); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(), // Đặt LoginScreen làm màn hình chính
      // Các cấu hình khác của ứng dụng
    );
  }
}