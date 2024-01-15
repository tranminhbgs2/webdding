// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/models/user.dart';
import 'package:webdding/screens/employee/add_employee.dart';
import 'package:webdding/services/employee/employee.dart';
import 'package:webdding/utils/navigation_helper.dart';
import 'package:webdding/widgets/employee_item.dart';

class CustomerItem extends StatefulWidget {
  const CustomerItem({super.key});
  @override
  _CustomerItemState createState() => _CustomerItemState();
}

class _CustomerItemState extends State<CustomerItem> {
  final EmployeeService _employeeService = EmployeeService();
  Future<List<Customer>> customers= Future.value([]);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAll();
    });
  }


  Future<void> _getAll() async {
    final store = StoreProvider.of<AppState>(context);
    final String userCode = store.state.customer?.code ?? '';

    try {
      final List<Customer> fetchedLocations =
          await _employeeService.getEmployees(userCode);
      setState(() {
        customers = Future.value(fetchedLocations);
      });
    } catch (e) {
      setState(() {
        customers = Future.value([]);
      });
    }
  }

  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Danh Sách Nhân Viên',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 35, 76, 191),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                // Xử lý khi người dùng nhấn nút "Add Employee" ở đây
                // Ví dụ: Mở màn hình thêm nhân viên
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddEmployee(),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Customer>>(
          future: customers,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có khách hàng.'));
            } else {
              final List<Customer> customers = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: customers.length,
                itemBuilder: (context, index) {
                  return EmployeeItem(employee: customers[index]);
                },
              );
            }
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Nhân viên',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_city),
              label: 'Địa điểm chụp',
            ),
          ],
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
        ));
  }
}
