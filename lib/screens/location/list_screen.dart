// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webdding/models/localtion.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/screens/location/add.dart';
import 'package:webdding/services/location/location.dart';
import 'package:webdding/utils/constant.dart';
import 'package:webdding/utils/navigation_helper.dart';
import 'package:webdding/widgets/location_item.dart';

class ListLocation extends StatefulWidget {
  const ListLocation({super.key});
  @override
  _ListLocationState createState() => _ListLocationState();
}

class _ListLocationState extends State<ListLocation> {
  final LocationService __locationService = LocationService();
  Future<List<Location>> locations = Future.value([]);
  List<BottomNavigationBarItem> _navBarItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAll();
    });
    _loadNavBarItems();
  }

  Future<void> _getAll() async {
    final store = StoreProvider.of<AppState>(context);
    final String userCode = store.state.customer?.code ?? '';

    try {
      final List<Location> fetchedLocations =
          await __locationService.listLocation(userCode, ACTIVATED);
      setState(() {
        locations = Future.value(fetchedLocations);
      });
    } catch (e) {
      setState(() {
        locations = Future.value([]);
      });
    }
  }

  int _selectedIndex = 2;

  Future<void> _loadNavBarItems() async {
    var items = await NavigationHelper.buildBottomNavBarItems();
    if(items.length > 0) {
      _selectedIndex = items.length - 1;
    }
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
            'Danh Sách địa điểm chụp',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 35, 76, 191),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white),
              color: Colors.white,
              onPressed: () {
                // Xử lý khi người dùng nhấn nút "Add Employee" ở đây
                // Ví dụ: Mở màn hình thêm nhân viên
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddLocation(),
                  ),
                );
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Location>>(
          future: locations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Đã xảy ra lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có địa điểm.'));
            } else {
              final List<Location> locations = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  return LocationItem(location: locations[index]);
                },
              );
            }
          },
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
        ));
  }
}
