import 'package:flutter/material.dart';
import 'package:webdding/screens/employee/add_employee.dart';
import 'package:webdding/screens/home_screen.dart';
import 'package:webdding/screens/login_screen.dart';

class NavigationHelper {
  static void onItemTapped(BuildContext context, int index, String email) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userEmail: email)),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEmployee()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
        break;
    }
  }
}
