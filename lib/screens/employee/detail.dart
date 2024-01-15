import 'package:flutter/material.dart';
import 'package:webdding/models/user.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final Customer customer;

  const EmployeeDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chi tiết nhân viên',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 35, 76, 191),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context); // Quay lại màn hình trước đó
            },
          ),
        ],
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
    );
  }
}
