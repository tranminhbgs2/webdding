// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:webdding/models/localtion.dart';
import 'package:webdding/models/redux/appState.dart';
import 'package:webdding/models/user.dart';
import 'package:webdding/models/work_schedule.dart';
import 'package:webdding/screens/home_screen.dart';
import 'package:webdding/services/employee/employee.dart';
import 'package:webdding/services/work/work.dart';
import 'package:webdding/utils/constant.dart';
import 'package:webdding/utils/helpers.dart';
import 'package:webdding/utils/validate.dart';
import 'package:webdding/widgets/location_selector.dart';
// Thêm các import cần thiết khác tại đây

class AddWorkScheduleScreen extends StatefulWidget {
  const AddWorkScheduleScreen({super.key});

  @override
  _AddWorkScheduleScreenState createState() => _AddWorkScheduleScreenState();
}

class _AddWorkScheduleScreenState extends State<AddWorkScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final EmployeeService _employeeService = EmployeeService();
  final WorkScheduleService __workScheduleService = WorkScheduleService();

  Future<List<Location>> locations = Future.value([]);
  Future<List<Customer>> employeePhoto = Future.value([]);
  Future<List<Customer>> employeeMakeup = Future.value([]);
  Future<List<Customer>> employeeDesigner = Future.value([]);
  Future<List<Customer>> employeeCskh = Future.value([]);

  // Controllers cho các trường nhập liệu
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController =
      TextEditingController();
  final TextEditingController _customerEmailController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _packagePriceController = TextEditingController();
  final TextEditingController _makeupPriceController = TextEditingController();
  final TextEditingController _photographyPriceController =
      TextEditingController();
  final TextEditingController _designerPriceController =
      TextEditingController();
  final TextEditingController _cskhPriceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  // ID cho địa điểm, nhân viên chụp ảnh và trang điểm
  List<String> _selectedLocations = [];
  String? _selectedPhotographerId;
  String? _selectedMakeupArtistId;
  String? _selectedDesignerId;
  String? _selectedCskhId;

  String? _designerPriceError;
  bool _isdesignerPriceValid = false;
  String? _packagePriceError;
  bool _ispackagePriceValid = false;
  String? _makeupPriceError;
  bool _ismakeupPriceValid = false;
  String? _photographyPriceError;
  bool _isphotographyPriceValid = false;
  String? _cskhPriceError;
  bool _iscskhPriceValid = false;
  // Thêm các trường thông tin khác nếu cần
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllLocaltion();
    });

    _designerPriceController.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _designerPriceError = validateNotNull(_designerPriceController.text);
          if (_designerPriceError == null) {
            _isdesignerPriceValid = true;
            _designerPriceError = null;
          } else {
            _isdesignerPriceValid = false;
          }
        });
      });
    });
    _packagePriceController.addListener(() {
      setState(() {
        _packagePriceError = validateNotNull(_packagePriceController.text);
        if (_packagePriceError == null) {
          _ispackagePriceValid = true;
        } else {
          _ispackagePriceValid = false;
        }
      });
    });
    _photographyPriceController.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _photographyPriceError =
              validateNotNull(_photographyPriceController.text);
          if (_photographyPriceError == null) {
            _isphotographyPriceValid = true;
            _photographyPriceError = null;
          } else {
            _isphotographyPriceValid = false;
          }
        });
      });
    });
    _makeupPriceController.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _makeupPriceError = validateNotNull(_makeupPriceController.text);
          if (_makeupPriceError == null) {
            _ismakeupPriceValid = true;
            _makeupPriceError = null;
          } else {
            _ismakeupPriceValid = false;
          }
        });
      });
    });
    _cskhPriceController.addListener(() {
      Future.delayed(const Duration(milliseconds: 50), () {
        setState(() {
          _cskhPriceError = validateNotNull(_cskhPriceController.text);
          if (_cskhPriceError == null) {
            _iscskhPriceValid = true;
            _cskhPriceError = null;
          } else {
            _iscskhPriceValid = false;
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _notesController.dispose();
    _packagePriceController.dispose();
    _designerPriceController.dispose();
    _photographyPriceController.dispose();
    _makeupPriceController.dispose();
    _cskhPriceController.dispose();
    super.dispose();
  }

  Future<void> _getAllLocaltion() async {
    final store = StoreProvider.of<AppState>(context);
    final String userCode = store.state.customer?.code ?? '';
    try {
      final List<Customer> fetchedemployeDesigner =
          await _employeeService.getByType(userCode, 'DESIGNER', ACTIVATED);
      final List<Customer> fetchedemployeeMakeup =
          await _employeeService.getByType(userCode, 'MAKEUP', ACTIVATED);
      final List<Customer> fetchedemployeePhoto =
          await _employeeService.getByType(userCode, 'PHOTO', ACTIVATED);

      final List<Customer> fetchedemployeeCskh =
          await _employeeService.getByType(userCode, 'CSKH', ACTIVATED);

      setState(() {
        employeePhoto = Future.value(fetchedemployeePhoto);
        employeeMakeup = Future.value(fetchedemployeeMakeup);
        employeeDesigner = Future.value(fetchedemployeDesigner);
        employeeCskh = Future.value(fetchedemployeeCskh);
      });
    } catch (e) {
      setState(() {
        employeeMakeup = Future.value([]);
        employeePhoto = Future.value([]);
        employeeDesigner = Future.value([]);
        employeeCskh = Future.value([]);
      });
    }
  }

  void _submit() async {
    _isLoading = true;
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Tạo một đối tượng Location từ dữ liệu nhập
      // Lấy Redux store từ context
      final store = StoreProvider.of<AppState>(context);
      final String userCode = store.state.customer?.code ?? '';
// Lấy thông tin đối tượng nhân viên từ DropdownButtonFormField
      final Customer? photographer =
          await _employeeService.getEmployeeById(_selectedPhotographerId);
      final Customer? makeupArtist =
          await _employeeService.getEmployeeById(_selectedMakeupArtistId);
      final Customer? designer =
          await _employeeService.getEmployeeById(_selectedDesignerId);
      final List<Location> location =
          await __workScheduleService.getLocationsByIds(_selectedLocations);
      final Customer? cskh =
          await _employeeService.getEmployeeById(_selectedCskhId);

      final newWork = WorkSchedule(
        locationIds: _selectedLocations,
        photographerId: _selectedPhotographerId ?? '',
        makeupArtistId: _selectedMakeupArtistId ?? '',
        designerId: _selectedDesignerId ?? '',
        cskhId: _selectedCskhId ?? '',
        packagePrice: double.tryParse(_packagePriceController.text) ?? 0.0,
        makeupPrice: double.tryParse(_makeupPriceController.text) ?? 0.0,
        designerPrice: double.tryParse(_designerPriceController.text) ?? 0.0,
        photographerPrice: double.tryParse(_packagePriceController.text) ?? 0.0,
        cskhPrice: double.tryParse(_cskhPriceController.text) ?? 0.0,
        shootingDate: _selectedDate,
        shootingTime: _selectedTime,
        customerName: _customerNameController.text,
        customerPhone: _customerPhoneController.text,
        customerEmail: _customerEmailController.text,
        notes: _notesController.text,
        status: ACTIVATED, // Hoặc trạng thái mặc định khác
        createdBy: userCode,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        locations: location,
        photographer: photographer ?? Customer(),
        makeupArtist: makeupArtist ?? Customer(),
        designer: designer ?? Customer(),
        cskh: cskh ?? Customer(),
      );
      // Thêm nhân viên vào Firestore
      String? result = await __workScheduleService.addWorkSchedule(newWork);

      bool isRes = false;
      String mess = "Thêm mới lịch làm việc thành công";
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
          MaterialPageRoute(builder: (context) => const HomeScreen()),
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

  void _handleSelectedLocationsChange(List<String> selectedLocations) {
    setState(() {
      _selectedLocations = selectedLocations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Thêm mới lịch làm việc',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 35, 76, 191),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_outlined,
                color: Colors.white),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context); // Quay lại màn hình trước đó
            },
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Các trường nhập liệu tại đây
                // Ví dụ: TextFormField cho customerName, customerPhone, v.v.
                // Thêm DropdownButtonFormField cho việc chọn địa điểm, nhân viên chụp ảnh và trang điểm
                // Thêm DatePicker và TimePicker cho việc chọn ngày và giờ
                // ... các trường nhập liệu khác ...
                LocationSelector(
                  onSelectedLocationsChanged: _handleSelectedLocationsChange,
                  selectedLocationIds: const [''],
                ),
                // ... các trường nhập liệu và nút lưu khác ...
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder<List<Customer>>(
                        future: employeeMakeup,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          var empMakeup = snapshot.data!;
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Makeup*",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              validator: validateNotNull,
                              value: _selectedMakeupArtistId,
                              items: empMakeup.map((Customer employee) {
                                return DropdownMenuItem<String>(
                                  value: employee.id,
                                  child: Text(
                                      "${employee.name} (${employee.code})"),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMakeupArtistId = newValue;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: _makeupPriceController,
                        keyboardType: TextInputType.number,
                        validator: validateNotNull,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly, // Chỉ cho phép nhập số
                        ],
                        decoration: InputDecoration(
                          labelText: 'Giá Makeup*',
                          hintText: 'Nhập giá tiền', // Gợi ý nếu input trống

                          prefixIcon: const Icon(Icons
                              .price_change_outlined), // Icon bên trái input
                          errorText: _makeupPriceError,
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
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder<List<Customer>>(
                        future: employeePhoto,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          var empMakeup = snapshot.data!;
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Thợ chụp ảnh*",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              validator: validateNotNull,
                              value: _selectedPhotographerId,
                              items: empMakeup.map((Customer employee) {
                                return DropdownMenuItem<String>(
                                  value: employee.id,
                                  child: Text(
                                      "${employee.name} (${employee.code})"),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPhotographerId = newValue;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextFormField(
                        controller: _photographyPriceController,
                        keyboardType: TextInputType.number,
                        validator: validateNotNull,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly, // Chỉ cho phép nhập số
                        ],
                        decoration: InputDecoration(
                          labelText: 'Giá chụp ảnh*',
                          hintText: 'Nhập giá', // Gợi ý nếu input trống
                          prefixIcon: const Icon(Icons
                              .price_change_outlined), // Icon bên trái input
                          errorText: _photographyPriceError,
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
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder<List<Customer>>(
                        future: employeeDesigner,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          var empMakeup = snapshot.data!;
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelText: "Thợ chỉnh sửa ảnh*",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              validator: validateNotNull,
                              value: _selectedDesignerId,
                              items: empMakeup.map((Customer employee) {
                                return DropdownMenuItem<String>(
                                  value: employee.id,
                                  child: Text(
                                      "${employee.name} (${employee.code})"),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDesignerId = newValue;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextFormField(
                        controller: _designerPriceController,
                        keyboardType: TextInputType.number,
                        validator: validateNotNull,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly, // Chỉ cho phép nhập số
                        ],
                        decoration: InputDecoration(
                          labelText: 'Giá chỉnh sửa ảnh*',
                          hintText: 'Nhập giá', // Gợi ý nếu input trống
                          prefixIcon: const Icon(Icons.price_change_outlined),
                          errorText: _designerPriceError,
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
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: FutureBuilder<List<Customer>>(
                        future: employeeCskh,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const CircularProgressIndicator();
                          }
                          var empMakeup = snapshot.data!;
                          return InputDecorator(
                            decoration: InputDecoration(
                              labelText: "CSKH*",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 5.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              validator: validateNotNull,
                              value: _selectedCskhId,
                              items: empMakeup.map((Customer employee) {
                                return DropdownMenuItem<String>(
                                  value: employee.id,
                                  child: Text(
                                      "${employee.name} (${employee.code})"),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCskhId = newValue;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: TextFormField(
                        controller: _cskhPriceController,
                        keyboardType: TextInputType.number,
                        validator: validateNotNull,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly, // Chỉ cho phép nhập số
                        ],
                        decoration: InputDecoration(
                          labelText: 'Hoa hồng*',
                          hintText: 'Nhập hoa hồng', // Gợi ý nếu input trống
                          prefixIcon: const Icon(Icons.price_change_outlined),
                          errorText: _cskhPriceError,
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
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _packagePriceController,
                  keyboardType: TextInputType.number,
                  validator: validateNotNull,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Chỉ cho phép nhập số
                  ],
                  decoration: InputDecoration(
                    labelText: 'Giá gói chụp*',
                    hintText: 'Nhập giá', // Gợi ý nếu input trống
                    prefixIcon:
                        const Icon(Icons.email_outlined), // Icon bên trái input
                    errorText: _packagePriceError,
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

                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text(
                            "Ngày chụp: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null &&
                              pickedDate != _selectedDate) {
                            setState(() {
                              _selectedDate = pickedDate;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: ListTile(
                        title:
                            Text("Giờ chụp: ${_selectedTime.format(context)}"),
                        trailing: const Icon(Icons.access_time),
                        onTap: () async {
                          final TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                            builder: (BuildContext context, Widget? child) {
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(alwaysUse24HourFormat: true),
                                child: child!,
                              );
                            },
                          );
                          if (pickedTime != null &&
                              pickedTime != _selectedTime) {
                            setState(() {
                              _selectedTime = pickedTime;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _customerNameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên khách hàng',
                    hintText: 'Nhập tên', // Gợi ý nếu input trống
                    prefixIcon:
                        Icon(Icons.email_outlined), // Icon bên trái input
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
                  controller: _customerEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email khách hàng',
                    hintText: 'Nhập email', // Gợi ý nếu input trống
                    prefixIcon:
                        Icon(Icons.email_outlined), // Icon bên trái input
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
                  controller: _customerPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại khách hàng',
                    hintText: 'Nhập số điện thoại', // Gợi ý nếu input trống
                    prefixIcon:
                        Icon(Icons.phone_outlined), // Icon bên trái input
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
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú',
                    hintText: 'Nhập ghi chú', // Gợi ý nếu input trống
                    prefixIcon:
                        Icon(Icons.note_outlined), // Icon bên trái input
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
                      backgroundColor: Colors.blueAccent,
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
      ),
    );
  }
}
