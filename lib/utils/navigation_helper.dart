import 'package:flutter/material.dart';
import 'package:webdding/screens/employee/list_screen.dart';
import 'package:webdding/screens/home_screen.dart';
import 'package:webdding/screens/location/list_screen.dart';

class NavigationHelper {
  static void onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustomerItem()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ListLocation()),
        );
        break;
    }
  }
}
