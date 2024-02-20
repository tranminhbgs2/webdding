// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:webdding/screens/employee/info.dart';
import 'package:webdding/screens/employee/list_screen.dart';
import 'package:webdding/screens/home_screen.dart';
import 'package:webdding/screens/location/list_screen.dart';
import 'package:webdding/services/auth/auth_service.dart';
import 'package:webdding/utils/constant.dart';

class NavigationHelper {
  static Future<List<BottomNavigationBarItem>> buildBottomNavBarItems() async {
    final authService = AuthService();
    String? role = await authService.getUserRoleFromPrefs();
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
    ];

    if (role == ADMIN) {
      items.addAll([
        const BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: 'Nhân viên',
        ),
      ]);
    } else {
      items.addAll([
        const BottomNavigationBarItem(
          icon: Icon(Icons.person_2),
          label: 'Cá nhân',
        )
      ]);
    }

    items.addAll([
      const BottomNavigationBarItem(
        icon: Icon(Icons.location_city),
        label: 'Địa điểm chụp',
      )
    ]);
    return items;
  }

  static Future<void> onItemTapped(BuildContext context, int index) async {
    final authService = AuthService();
    String? role = await authService.getUserRoleFromPrefs();
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        break;
      case 1:
        if (role == ADMIN) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CustomerItem()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmployeeInfo()),
          );
        }
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
