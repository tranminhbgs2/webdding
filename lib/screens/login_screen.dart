// lib/screens/login_screen.dart
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:webdding/models/redux/appState.dart';

import 'package:webdding/screens/home_screen.dart';
import 'package:webdding/screens/signup_screen.dart';
import 'package:webdding/services/auth/auth_service.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webdding/models/user.dart';
import 'package:webdding/services/employee/employee.dart'; // Add this line

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

void checkAsset() {
  rootBundle.loadString('assets/images/logo.png').then((String contents) {
  }).catchError((error) {
  });
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final EmployeeService _employeeService = EmployeeService();
  final TextEditingController _emailController =
      TextEditingController(text: "admin@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "123456");
  bool _isLoading = false;
  String _errorText = '';
  // Khai báo biến để theo dõi trạng thái ẩn/hiện mật khẩu
  bool _isPasswordVisible = true;

  void _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
      _errorText = '';
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    final result =
        await _authService.signInWithEmailAndPassword(email, password, context);

    if (result) {
      Customer? customer = await _employeeService.getEmployeeByEmail(email);
      if (customer != null) {
        StoreProvider.of<AppState>(context).dispatch(UpdateCustomerAction(customer));
        // Đăng nhập thành công, điều hướng đến màn hình chính hoặc màn hình khác
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) =>
              const HomeScreen(), // Pass the email here
        ));
      } else {
        // Đăng nhập thất bại, hiển thị thông báo lỗi
        setState(() {
          _errorText = 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin!';
        });
      }
    } else {
      // Đăng nhập thất bại, hiển thị thông báo lỗi
      setState(() {
        _errorText = 'Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Positioned.fill(
          //   child: Image.asset(
          //     'images/bacground.png', // Replace with your background image
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset('assets/images/icons/logo-app.png', height: 120), // Logo
                  const SizedBox(height: 60),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      'Welcome Back,',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  if (_errorText.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.red, // Màu nền của thông báo lỗi
                      child: Text(
                        _errorText,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email Address',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText:
                          _isPasswordVisible, // Ẩn/hiện mật khẩu dựa trên trạng thái
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          // Sử dụng IconButton để thay đổi trạng thái ẩn/hiện mật khẩu
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed:
                          _isLoading ? null : _signInWithEmailAndPassword,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextButton(
                      onPressed: () {
                        // Handle Forgot Password
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
