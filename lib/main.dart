import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/models/user.dart';
import 'package:webdding/reducers/app_reducer.dart';
import 'package:webdding/screens/login_screen.dart'; // Import the firebase_core package
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDeaZ9PWjxNJypt1YW2L2tiQnGj9Abor2U",
      appId: "1:485677018041:android:8bdcca1ec191c0c582a468",
      messagingSenderId: "485677018041",
      projectId: "app-webding",
    ),
  ); // Initialize Firebase

  final store = Store<AppState>(
    appReducer,
    initialState: AppState(
        customer:
            Customer(createdAt: Timestamp.now(), updatedAt: Timestamp.now())),
  );
  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});
  // const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: const MaterialApp(
        home: LoginScreen(),
      ),
    );
  }
}
