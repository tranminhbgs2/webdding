// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webdding/models/localtion.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/services/location/location.dart';
import 'package:webdding/utils/constant.dart';
import 'package:webdding/utils/validate.dart';

class LocationSelector extends StatefulWidget {
  final Function(List<String>) onSelectedLocationsChanged;

  const LocationSelector({Key? key, required this.onSelectedLocationsChanged})
      : super(key: key);

  @override
  _LocationSelectorState createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final List<String> _selectedLocationIds = [''];
  final LocationService __locationService = LocationService();
  Future<List<Location>> _getAllLocaltion() async {
    // Add a return statement at the end of the method
    final store = StoreProvider.of<AppState>(context);
    final String userCode = store.state.customer?.code ?? '';

    try {
      final List<Location> fetchedLocations =
          await __locationService.listLocation(userCode, ACTIVATED);
      return fetchedLocations;
    } catch (e) {
      return Future.value([]);
    }
    // return [];
  }

  // ... Phương thức _buildLocationSelector và _fetchLocations giữ nguyên ...
  Widget _buildLocationSelector(int index) {
    // Phần code của FutureBuilder để tạo DropdownButtonFormField cho mỗi địa điểm
    return FutureBuilder<List<Location>>(
      future: _getAllLocaltion(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();
        var locations = snapshot.data!;
        // Thêm một mục trống hoặc mục mặc định
        // if (_selectedLocationIds[index].isEmpty && locations.isNotEmpty) {
        //   _selectedLocationIds[index] = locations.first.id;
        // }
        return Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0), // Khoảng cách giữa các hàng
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Chọn địa điểm*",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        value: _selectedLocationIds[index].isEmpty
                            ? null
                            : _selectedLocationIds[index],
                            validator: validateNotNull,
                        items: locations.map((Location location) {
                          return DropdownMenuItem<String>(
                            value: location.id,
                            child: Text(location.name),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLocationIds[index] = newValue ?? '';
                            widget.onSelectedLocationsChanged(_selectedLocationIds);
                          });
                        },
                      ),
                    ),
                  )),
            ),
            if (index >
                0) // Nút xóa chỉ hiển thị khi không phải là mục đầu tiên
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  setState(() {
                    _selectedLocationIds.removeAt(index);
                  });
                },
              ),
            const SizedBox(height: 16.0),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16.0),
        for (int i = 0; i < _selectedLocationIds.length; i++)
          Column(
            children: [
              _buildLocationSelector(i),
            ],
          ),
        const SizedBox(height: 16.0),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(
                right: 32.0), // Áp dụng padding chỉ bên phải
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent, // Màu nền nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Bo tròn góc nút
                ),
                padding: const EdgeInsets.all(16), // Padding trong nút
              ),
              onPressed: () {
                setState(() {
                  _selectedLocationIds.add(''); // Thêm một lựa chọn mới
                });
                widget.onSelectedLocationsChanged(_selectedLocationIds);
              },
              child: const Text(
                'Thêm địa điểm', // Text hiển thị trên nút
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, // Màu chữ
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
