import 'package:flutter/material.dart';
import 'package:webdding/models/user.dart';
import 'package:webdding/services/employee/employee.dart';
import 'package:webdding/utils/helpers.dart';
import 'package:webdding/utils/validate.dart';

class AddEmployee extends StatefulWidget {
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final EmployeeService _employeeService = EmployeeService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  String? _passwordError;
  bool _isPasswordValid = false;
  String? _nameError;
  bool _isNameValid = false;
  String? _emailError;
  bool _isEmailValid = false;
  String? _phoneError;
  bool _isPhoneValid = false;
  // Thêm các trường thông tin khác nếu cần
  // Khai báo biến để theo dõi trạng thái ẩn/hiện mật khẩu
  bool _isPasswordVisible = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _password.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _passwordError = validatePassword(_password.text);
          if (_passwordError == null) {
            _isPasswordValid = true;
            _passwordError = null;
          } else {
            _isPasswordValid = false;
          }
        });
      });
    });

    _name.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _nameError = validateNotNull(_name.text);
          if (_nameError == null) {
            _isNameValid = true;
            _nameError = null;
            print(_nameError);
          } else {
            _isNameValid = false;
          }
        });
      });
    });

    _phoneNumber.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _phoneError = validatePhone(_phoneNumber.text);
          if (_phoneError == null) {
            _isPhoneValid = true;
            _phoneError = null;
          } else {
            _isPhoneValid = false;
          }
        });
      });
    });

    _email.addListener(() {

      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _emailError = validateEmail(_email.text);
          if (_emailError == null) {
            _isEmailValid = true;
          } else {
            _isEmailValid = false;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _password.dispose();
    _phoneNumber.dispose();
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  void _submit() async {
    _isLoading = true;
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Tạo một đối tượng Employee từ dữ liệu nhập
      final newEmployee = Customer(
        name: _name.text,
        email: _email.text,
        phoneNumber: _phoneNumber.text,
      );
      // Thêm nhân viên vào Firestore
      String? result =
          await _employeeService.addEmployee(newEmployee, _password.text);

      print(result);
      bool isRes = false;
      String mess = "Thêm mới nhận viên thành công";
      if (result == null) {
        isRes = true;
      } else {
        if (result.contains(
            "The email address is already in use by another account")) {
          mess = "Email đã được sử dụng";
        } else {
          mess = "Đã có lỗi xảy ra";
        }
        isRes = false;
      }

      // ignore: use_build_context_synchronously
      showFlushbar(context, mess, isRes);
      if (isRes) {
        // Sau khi thêm, bạn có thể quay lại màn hình trước đó hoặc thực hiện hành động khác
        Future.delayed(const Duration(seconds: 5), () {
          Navigator.pop(context);
        });
      }
    } else {
      // _formKey.currentState!.reset(); // Reset form nếu có lỗi
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Đặt GlobalKey cho Scaffold
      appBar: AppBar(
        title: const Text(
          'Thêm Nhân Viên Mới',
          selectionColor: Colors.white,
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: 'Tên nhân viên*',
                  hintText: 'Nhập tên của nhân viên', // Gợi ý nếu input trống
                  prefixIcon: const Icon(Icons.person), // Icon bên trái input
                  errorText: _nameError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isNameValid ? Colors.green : Colors.grey,
                    ),
                  ), // Viền input
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isNameValid ? Colors.green : Colors.blue,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isNameValid
                            ? Colors.green
                            : Colors.red), // Màu viền khi có lỗi
                  ),
                ),
                validator: validateNotNull,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email*',
                  hintText: 'Nhập email', // Gợi ý nếu input trống
                  prefixIcon: const Icon(Icons.email), // Icon bên trái input
                  errorText: _emailError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmailValid ? Colors.green : Colors.grey,
                    ),
                  ), // Viền input
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmailValid ? Colors.green : Colors.blue,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isEmailValid
                            ? Colors.green
                            : Colors.red), // Màu viền khi có lỗi
                  ),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                  labelText: 'Số Điện Thoại*',
                  hintText: 'Nhập số điện thoại', // Gợi ý nếu input trống
                  prefixIcon: const Icon(Icons.phone), // Icon bên trái input
                  errorText: _phoneError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPhoneValid ? Colors.green : Colors.grey,
                    ),
                  ), // Viền input
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPhoneValid ? Colors.green : Colors.blue,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isPhoneValid
                            ? Colors.green
                            : Colors.red), // Màu viền khi có lỗi
                  ),
                ),
                validator: validatePhone,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _password,
                obscureText: _isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Mật khẩu*',
                  hintText: 'Nhập mật khẩu',
                  prefixIcon: const Icon(Icons.password), // Icon bên trái input
                  errorText: _passwordError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPasswordValid ? Colors.green : Colors.grey,
                    ),
                  ), // Viền input
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPasswordValid ? Colors.green : Colors.blue,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isPasswordValid
                            ? Colors.green
                            : Colors.red), // Màu viền khi có lỗi
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
                validator: validatePassword,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    primary: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: _isLoading ? null : _submit,
                  child: const Text(
                    'Thêm mới',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
