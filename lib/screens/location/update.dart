// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:webdding/models/localtion.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/screens/location/list_screen.dart';
import 'package:webdding/services/location/location.dart';
import 'package:webdding/utils/helpers.dart';
import 'package:webdding/utils/validate.dart';

class EditLocation extends StatefulWidget {
  final Location location;

  const EditLocation({super.key, required this.location});

  @override
  // ignore: library_private_types_in_public_api
  _EditLocationState createState() => _EditLocationState();
}

class _EditLocationState extends State<EditLocation> {
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
    _name.text = widget.location.name;
    _address.text = widget.location.address;
    _phone.text = widget.location.phone;
    _description.text = widget.location.description;

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
          _addressError = validatePhone(_address.text);
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
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() async {
    _isLoading = true;
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Tạo một đối tượng Location từ dữ liệu nhập
      final store = StoreProvider.of<AppState>(context);
      final String userCode = store.state.customer?.code ?? '';
      final updatedLocation = Location(
        id: widget.location.id,
        name: _name.text,
        address: _address.text,
        phone: _phone.text,
        description: _description.text,
        userCode: userCode,
        createdAt: widget.location.createdAt,
        updatedAt: Timestamp.now(), // Cập nhật thời gian
      );

      // Cập nhật thông tin nhân viên vào Firestore
      String? result = await _locationService.updateLocation(updatedLocation);
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
          MaterialPageRoute(builder: (context) => const ListLocation()),
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
          'Chỉnh Sửa địa điểm',
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
                  hintText: 'Nhập tên địa điểm',
                  prefixIcon: const Icon(Icons.location_city_outlined),
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
                controller: _address,
                decoration: InputDecoration(
                  labelText: 'Vị trí*',
                  hintText: 'Nhập vị trí',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  errorText: _addressError,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isAddressValid ? Colors.green : Colors.grey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _isAddressValid ? Colors.green : Colors.blue,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: _isAddressValid ? Colors.green : Colors.red),
                  ),
                ),
                validator: validateNotNull,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(
                  labelText: 'Số Điện Thoại',
                  hintText: 'Nhập số điện thoại',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
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
                  hintText: 'Nhập mô tả',
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
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
