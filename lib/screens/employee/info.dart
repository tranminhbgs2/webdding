import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/models/user.dart';
import 'package:webdding/utils/navigation_helper.dart';

class EmployeeInfo extends StatefulWidget {
  const EmployeeInfo({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _EmployeeInfoState createState() => _EmployeeInfoState();
}

class _EmployeeInfoState extends State<EmployeeInfo> {
  final customer = Customer();
  List<BottomNavigationBarItem> _navBarItems = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchWorkSchedulesFromFirestore();
    });
    _loadNavBarItems();
  }

  void _fetchWorkSchedulesFromFirestore() async {
    try {
      final store = StoreProvider.of<AppState>(context);
      setState(() {
        customer.fullName = store.state.customer?.fullName ?? '';
        customer.name = store.state.customer?.name ?? '';
        customer.email = store.state.customer?.email ?? '';
        customer.phoneNumber = store.state.customer?.phoneNumber ?? '';
        customer.rule = store.state.customer?.rule ?? '';
        customer.type = store.state.customer?.type ?? '';
      });
    } catch (e) {
      // print('Error fetching work schedules: $e');
    }
  }
  int _selectedIndex = 1;

  Future<void> _loadNavBarItems() async {
    var items = await NavigationHelper.buildBottomNavBarItems();
    setState(() {
      _navBarItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Chi tiết nhân viên',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 35, 76, 191),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên: ${customer.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Email: ${customer.email}'),
            const SizedBox(height: 8),
            Text('Số điện thoại: ${customer.phoneNumber}'),
            const SizedBox(height: 8),
            Text('Họ và tên đầy đủ: ${customer.fullName}'),
            const SizedBox(height: 8),
            Text('Vai trò: ${customer.rule}'),
            const SizedBox(height: 8),
            Text('Chức vụ: ${customer.type}'),
            const SizedBox(height: 8),
            // Thêm các trường thông tin khác nếu cần
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: _navBarItems,
          currentIndex: _selectedIndex, // Biến theo dõi mục hiện tại được chọn
          selectedItemColor: Colors.amber[800], // Màu sắc cho mục được chọn
          unselectedItemColor:
              Colors.grey, // Màu sắc cho các mục chưa được chọn
          onTap: (index) {
            if (_selectedIndex != index) {
              setState(() {
                _selectedIndex = index;
              });
              NavigationHelper.onItemTapped(context, index);
            }
          }, // Hàm xử lý sự kiện khi chạm vào một mục
          backgroundColor: Colors.white, // Màu nền của BottomNavigationBar
          type: BottomNavigationBarType.fixed, // Kiểu của BottomNavigationBar
          showUnselectedLabels:
              true, // Hiển thị nhãn của các mục không được chọn
        )
    );
  }
}
