import 'package:flutter/material.dart';
import 'package:webdding/screens/login_screen.dart';
import 'package:webdding/services/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService(); // Khởi tạo AuthService

  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
        title: Text('Đăng ký'),
        actions: [
          IconButton(
            icon: Icon(Icons.login), // Icon cho nút "Đăng ký"
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Số điện thoại'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _fullNameController,
              decoration: InputDecoration(labelText: 'Họ và tên'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Mật khẩu'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child: Text('Đăng ký'),
            ),
            if (_errorText.isNotEmpty)
              SizedBox(
                height: 16.0,
                child: Text(
                  _errorText,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
