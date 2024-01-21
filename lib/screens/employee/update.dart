// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/models/user.dart';
import 'package:webdding/screens/employee/list_screen.dart';
import 'package:webdding/services/employee/employee.dart';
import 'package:webdding/utils/helpers.dart';
import 'package:webdding/utils/validate.dart';

class EditEmployee extends StatefulWidget {
  final Customer employee;

  const EditEmployee({super.key, required this.employee});

  @override
  _EditEmployeeState createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  final EmployeeService _employeeService = EmployeeService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _salary = TextEditingController(text: '0');
  final TextEditingController _bonus = TextEditingController(text: '0');
  String? _selectedValue;
  String? _nameError;
  final bool _isNameValid = true;
  String? _emailError;
  final bool _isEmailValid = true;
  String? _phoneError;
  final bool _isPhoneValid = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name.text = widget.employee.name;
    _email.text = widget.employee.email;
    _phoneNumber.text = widget.employee.phoneNumber;
    _selectedValue = widget.employee.type;
    _salary.text = widget.employee.salary.toString();
    _bonus.text = widget.employee.bonus.toString();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phoneNumber.dispose();
    super.dispose();
  }

  void _submit() async {
    _isLoading = true;
    // ignore: duplicate_ignore
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Tạo một đối tượng Employee từ dữ liệu nhập
      
      final store = StoreProvider.of<AppState>(context);
      // Lấy userCode từ store
      final String userCode;
      if (store.state.customer != null) {
        userCode = store.state.customer!.code;
      } else {
        // Xử lý trường hợp customer là null
        // Ví dụ: Đặt userCode là một giá trị mặc định hoặc xử lý lỗi
        userCode = '';
      }
      final updatedEmployee = Customer(
        id: widget.employee.id,
        name: _name.text,
        email: _email.text,
        phoneNumber: _phoneNumber.text,
        code: widget.employee.code,
        type: _selectedValue ?? '',
        createBy: userCode,
        salary: double.tryParse(_salary.text) ?? 0.0,
        bonus: double.tryParse(_bonus.text) ?? 0.0,
        createdAt: widget.employee.createdAt,
        updatedAt: Timestamp.now(), // Cập nhật thời gian
      );

      // Cập nhật thông tin nhân viên vào Firestore
      String? result = await _employeeService.updateEmployee(updatedEmployee);
      bool isRes = false;
      String mess = "Cập nhật thông tin nhân viên thành công";
      if (result == null) {
        isRes = true;
      } else {
        mess = "Đã có lỗi xảy ra";
        isRes = false;
      }

      // ignore: use_build_context_synchronously
      setState(() {
        _isLoading = false;
      });
      if (isRes) {
        // Sau khi thêm, bạn có thể quay lại màn hình trước đó hoặc thực hiện hành động khác
        // Future.delayed(const Duration(seconds: 2), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CustomerItem()),
        );
        // });
      }
      showFlushbar(context, mess, isRes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Chỉnh Sửa Nhân Viên',
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              InputDecorator(
                decoration: InputDecoration(
                  labelText: "Vai trò*",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    validator: validateNotNull,
                    value: _selectedValue,
                    isExpanded: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                    items: dropdownItems.map((DropdownItem item) {
                      return DropdownMenuItem<String>(
                        value: item.value,
                        child: Text(item.display),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: 'Tên nhân viên*',
                  hintText: 'Nhập tên của nhân viên',
                  prefixIcon: const Icon(Icons.person),
                  errorText: _nameError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isNameValid ? Colors.green : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isNameValid ? Colors.green : Colors.blue,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isNameValid ? Colors.green : Colors.red),
                  ),
                ),
                validator: validateNotNull,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email*',
                  hintText: 'Nhập email',
                  prefixIcon: const Icon(Icons.email),
                  errorText: _emailError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmailValid ? Colors.green : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isEmailValid ? Colors.green : Colors.blue,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isEmailValid ? Colors.green : Colors.red),
                  ),
                ),
                validator: validateEmail,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneNumber,
                decoration: InputDecoration(
                  labelText: 'Số Điện Thoại*',
                  hintText: 'Nhập số điện thoại',
                  prefixIcon: const Icon(Icons.phone),
                  errorText: _phoneError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPhoneValid ? Colors.green : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isPhoneValid ? Colors.green : Colors.blue,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isPhoneValid ? Colors.green : Colors.red),
                  ),
                ),
                validator: validatePhone,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _salary,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Lương cơ bản',
                  hintText: 'Nhập lương cơ bản', // Gợi ý nếu input trống
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ), // Viền input
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                validator: (value) {
                  double? intValue = double.tryParse(value!);
                  if (intValue == null || intValue < 0) {
                    return 'Giá trị không hợp lệ. Vui lòng nhập số.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _bonus,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                maxLength: 3,
                decoration: InputDecoration(
                  labelText: 'Hoa hồng (%)',
                  hintText: 'Nhập % hoa hồng', // Gợi ý nếu input trống
                  prefixIcon: const Icon(Icons.money), // Icon bên trái input
                  errorText: _phoneError,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ), // Viền input
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blue,
                    ),
                  ),
                ),
                validator: (value) {
                  double? intValue = double.tryParse(value!);
                  if (intValue == null || intValue < 0 || intValue > 100) {
                    return 'Giá trị không hợp lệ. Vui lòng nhập số từ 0 đến 100.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: _isLoading ? null : _submit,
                  child: const Text(
                    'Cập Nhật',
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
