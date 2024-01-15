import 'package:flutter/material.dart';
import 'package:webdding/models/localtion.dart';

class LocationDetailScreen extends StatelessWidget {
  final Location location;

  const LocationDetailScreen({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết địa điểm',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 35, 76, 191),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context); // Quay lại màn hình trước đó
          },
        )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tên địa điểm: ${location.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Vị trí: ${location.address}'),
            const SizedBox(height: 8),
            Text('Số điện thoại: ${location.phone}'),
            const SizedBox(height: 8),
            Text('Mô tả: ${location.description}'),
            const SizedBox(height: 8),
            // Thêm các trường thông tin khác nếu cần
          ],
        ),
      ),
    );
  }
}
