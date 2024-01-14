// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:webdding/screens/login_screen.dart';
import 'package:webdding/services/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService(); // Khởi tạo AuthService

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorText = '';
  bool _isLoading = false;

  // Hàm xử lý logic đăng ký
  void _signUp() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailController.text;
    String phoneNumber = _phoneNumberController.text;
    String fullName = _fullNameController.text;
    String password = _passwordController.text;

    String? result = await _authService.signUpWithEmailAndPassword(email, phoneNumber, fullName, password);

    if (result == null) {
      // Đăng ký thành công, điều hướng tới trang chính hoặc màn hình đăng nhập
    } else {
      setState(() {
        _errorText = result;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký'),
        actions: [
          IconButton(
            icon: const Icon(Icons.login), // Icon cho nút "Đăng ký"
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Họ và tên'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mật khẩu'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: const Text('Đăng ký'),
            ),
            if (_errorText.isNotEmpty)
              SizedBox(
                height: 16.0,
                child: Text(
                  _errorText,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
