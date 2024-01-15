// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webdding/models/localtion.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/screens/location/list_screen.dart';
import 'package:webdding/services/location/location.dart';
import 'package:webdding/utils/helpers.dart';
import 'package:webdding/utils/validate.dart';

class AddLocation extends StatefulWidget {
  const AddLocation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  final LocationService _locationService = LocationService();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  String? _nameError;
  bool _isNameValid = false;
  String? _addressError;
  bool _isAddressValid = false;
  // Thêm các trường thông tin khác nếu cần
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _name.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _nameError = validateNotNull(_name.text);
          if (_nameError == null) {
            _isNameValid = true;
            _nameError = null;
          } else {
            _isNameValid = false;
          }
        });
      });
    });

    _address.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _addressError = validateNotNull(_address.text);
          if (_addressError == null) {
            _isAddressValid = true;
            _addressError = null;
          } else {
            _isAddressValid = false;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _address.dispose();
    _description.dispose();
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _submit() async {
    _isLoading = true;
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Tạo một đối tượng Location từ dữ liệu nhập
      // Lấy Redux store từ context
      final store = StoreProvider.of<AppState>(context);
      final String userCode = store.state.customer?.code ?? '';
      final newLocation = Location(
        name: _name.text,
        description: _description.text,
        address: _address.text,
        phone: _phone.text,
        userCode: userCode,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
      );
      // Thêm nhân viên vào Firestore
      String? result = await _locationService.addLocation(newLocation);

      bool isRes = false;
      String mess = "Thêm mới địa điểm thành công";
      if (result == null) {
        isRes = true;
      } else {
        if (kDebugMode) {
          print(result);
        }
        mess = "Đã có lỗi xảy ra";
        isRes = false;
      }

      setState(() {
        _isLoading = false;
      });
      if (isRes) {
        // Sau khi thêm, bạn có thể quay lại màn hình trước đó hoặc thực hiện hành động khác
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ListLocation()),
        );
      }
      showFlushbar(context, mess, isRes);
    } else {
      setState(() {
        _isLoading = false;
      });
      // _formKey.currentState!.reset(); // Reset form nếu có lỗi
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Đặt GlobalKey cho Scaffold
      appBar: AppBar(
        title: const Text(
          'Thêm địa điểm Mới',
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
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                  labelText: 'Tên địa điểm*',
                  hintText: 'Nhập tên địa điểm', // Gợi ý nếu input trống
                  prefixIcon: const Icon(
                      Icons.location_city_outlined), // Icon bên trái input
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
                controller: _address,
                decoration: InputDecoration(
                  labelText: 'Vị trí*',
                  hintText: 'Nhập vị trí', // Gợi ý nếu input trống
                  prefixIcon: const Icon(
                      Icons.location_on_outlined), // Icon bên trái input
                  errorText: _addressError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isAddressValid ? Colors.green : Colors.grey,
                    ),
                  ), // Viền input
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isAddressValid ? Colors.green : Colors.blue,
                    ),
                  ),

                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isAddressValid
                            ? Colors.green
                            : Colors.red), // Màu viền khi có lỗi
                  ),
                ),
                validator: validateNotNull,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                maxLines: null,
                controller: _phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  hintText: 'Nhập số điện thoại', // Gợi ý nếu input trống
                  prefixIcon: Icon(Icons.phone), // Icon bên trái input
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
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                minLines: 3,
                maxLines: null,
                controller: _description,
                decoration: const InputDecoration(
                  labelText: 'Mô tả',
                  hintText: 'Nhập mô tả', // Gợi ý nếu input trống
                  prefixIcon:
                      Icon(Icons.description_outlined), // Icon bên trái input
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
