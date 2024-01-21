import 'package:cloud_firestore/cloud_firestore.dart';

class Location {
  final String id;
  final String name;
  final String description;
  final String address;
  final String phone;
  final String status;
  final String userCode;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  
  Location({
    this.id = '',
    this.name = '',
    this.description = '',
    this.address = '',
    this.phone = '',
    this.status = '',
    this.userCode = '',
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) : createdAt = createdAt ?? Timestamp.now(),
       updatedAt = updatedAt ?? Timestamp.now();
  
  factory Location.fromJson(Map<String, dynamic> json, String? id) {
    return Location(
      id: id ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      userCode: json['userCode'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      updatedAt: json['updatedAt'] ?? Timestamp.now(),
    );
  }

  factory Location.fromJsonV2(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      userCode: json['userCode'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? Timestamp.now(),
      updatedAt: json['updated_at'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userCode': userCode,
      'description': description,
      'address': address,
      'phone': phone,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
