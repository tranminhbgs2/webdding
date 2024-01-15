// user.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webdding/utils/constant.dart';

class Customer {
  String id;
  String code;
  String name;
  String email;
  String phoneNumber;
  String fullName;
  String rule;
  String type;
  String status;
  String createBy;
  Timestamp createdAt;
  Timestamp updatedAt;

  // Customer({this.id = '', this.code = '', required this.name, required this.email, this.phoneNumber = '', this.fullName = '', this.rule = '', this.type = ''});

  Customer({
    this.id = "",
    this.code = '',
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.fullName = '',
    this.rule = '',
    this.type = '',
    this.createBy = '',
    this.status = ACTIVATED,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  factory Customer.fromJson(Map<String, dynamic> json, String? id) {
    return Customer(
      id: id ?? '',
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullName: json['fullName'] ?? '',
      rule: json['rule'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createBy: json['createBy'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  factory Customer.fromJsonV2(Map<String, dynamic> json) {
    return Customer(
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      fullName: json['fullName'] ?? '',
      rule: json['rule'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createBy: json['createBy'] ?? '',
      createdAt: json['created_at'] ?? Timestamp.now(),
      updatedAt: json['updated_at'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'rule': rule,
      'type': type,
      'status': status,
      'createBy': createBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class DropdownItem {
  String value;
  String display;

  DropdownItem({required this.value, required this.display});
}

List<DropdownItem> dropdownItems = [
  DropdownItem(value: 'MAKEUP', display: 'Makeup'),
  DropdownItem(value: 'PHOTO', display: 'Thợ ảnh'),
  DropdownItem(value: 'DESIGNER', display: 'Thợ chỉnh sửa ảnh'),
  DropdownItem(value: 'LETAN', display: 'Lễ tân'),
  // DropdownItem(value: 'option3', display: 'Tùy Chọn 3'),
];
