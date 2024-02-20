import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:webdding/models/localtion.dart';
import 'package:webdding/models/user.dart';

class WorkSchedule {
  final List<String> locationIds;
  final String id;
  final String photographerId; // ID của người chụp ảnh
  final String makeupArtistId; // ID của người trang điểm
  final String designerId; // ID của người trang điểm
  final String cskhId; // ID của người trang điểm
  final DateTime shootingDate; // Ngày chụp ảnh
  final TimeOfDay shootingTime; // Giờ chụp ảnh
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String notes; // Ghi chú từ khách hàng
  final double packagePrice;
  final double makeupPrice;
  final double designerPrice;
  final double photographerPrice;
  final double cskhPrice;
  final String status; // Trạng thái của lịch làm việc
  final String createdBy; // Người tạo lịch
  final Timestamp createdAt; // Ngày giờ tạo
  final Timestamp updatedAt; // Ngày giờ cập nhật

  final Customer photographer;
  final Customer makeupArtist;
  final Customer designer;
  final Customer cskh;
  List<Location> locations;

  @override
  String toString() {
    // Chuyển đổi TimeOfDay thành chuỗi
    String formattedShootingTime =
        '${shootingTime.hour.toString().padLeft(2, '0')}:${shootingTime.minute.toString().padLeft(2, '0')}';

    return 'WorkSchedule(id: $id, locationIds: $locationIds, photographerId: $photographerId, makeupArtistId: $makeupArtistId, designerId: $designerId,, cskhId: $cskhId shootingDate: $shootingDate, shootingTime: $formattedShootingTime, customerName: $customerName, customerPhone: $customerPhone, customerEmail: $customerEmail, notes: $notes, packagePrice: $packagePrice, makeupPrice: $makeupPrice, designerPrice: $designerPrice, photographerPrice: $photographerPrice,cskhPrice: $cskhPrice, status: $status, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, photographer: ${photographer.toString()}, makeupArtist: ${makeupArtist.toString()}, designer: ${designer.toString()}, cskh: ${cskh.toString()}, locations: ${locations.map((e) => e.toString()).join(', ')})';
  }

  WorkSchedule({
    this.id = '',
    required this.locationIds,
    required this.photographerId,
    required this.makeupArtistId,
    required this.cskhId,
    required this.designerId,
    required this.packagePrice,
    required this.makeupPrice,
    required this.designerPrice,
    required this.photographerPrice,
    required this.cskhPrice,
    required this.shootingDate,
    required this.shootingTime,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    this.notes = '',
    required this.status,
    required this.createdBy,
    required this.photographer,
    required this.makeupArtist,
    required this.designer,
    required this.cskh,
    this.locations = const [],
    Timestamp? createdAt,
    Timestamp? updatedAt,
  })  : createdAt = createdAt ?? Timestamp.now(),
        updatedAt = updatedAt ?? Timestamp.now();

  // Phương thức để chuyển đổi từ JSON (hoặc Map) sang đối tượng WorkSchedule và ngược lại
  // Điều này hữu ích khi lưu trữ và truy xuất dữ liệu từ cơ sở dữ liệu như Firestore
  factory WorkSchedule.fromJson(Map<String, dynamic> json, String id) {
    final List<dynamic> locationData = json['locations'] ?? [];

    // Convert the dynamic list to a list of Location objects
    final List<Location> locations =
        locationData.map((location) => Location.fromJsonV2(location)).toList();
    return WorkSchedule(
      id: id,
      locationIds: json['locationIds'] != null
          ? List<String>.from(json['locationIds'])
          : [],
      photographerId: json['photographerId'] as String? ?? '',
      designerId: json['designerId'] as String? ?? '',
      makeupArtistId: json['makeupArtistId'] as String? ?? '',
      cskhId: json['cskhId'] as String? ?? '',
      shootingDate: json['shootingDate'] != null
          ? (json['shootingDate'] as Timestamp).toDate()
          : DateTime.now(),
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String? ?? '',
      customerEmail: json['customerEmail'] as String? ?? '',
      packagePrice: (json['packagePrice'] as num?)?.toDouble() ?? 0.0,
      makeupPrice: (json['makeupPrice'] as num?)?.toDouble() ?? 0.0,
      designerPrice: (json['designerPrice'] as num?)?.toDouble() ?? 0.0,
      photographerPrice: (json['photographerPrice'] as num?)?.toDouble() ?? 0.0,
      cskhPrice: (json['cskhPrice'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
      updatedAt: json['updatedAt'] ?? Timestamp.now(),
      shootingTime: TimeOfDay(
          hour: json['shootingHour'] ?? 0, minute: json['shootingMinute'] ?? 0),
      photographer: json['photographer'] != null ? Customer.fromJsonV2(json['photographer']) : Customer.empty(),
      makeupArtist: json['makeupArtist'] != null ? Customer.fromJsonV2(json['makeupArtist']) : Customer.empty(),
      designer: json['designer'] != null ? Customer.fromJsonV2(json['designer']) : Customer.empty(),
      cskh: json['cskh'] != null ? Customer.fromJsonV2(json['cskh']) : Customer.empty(),

      locations:
          locations, // Chuyển đổi dữ liệu của nhân viên từ Map thành đối tượng Employee
    );
  }

  Map<String, dynamic> toJson() => {
        'locationIds': locationIds,
        'photographerId': photographerId,
        'makeupArtistId': makeupArtistId,
        'cskhId': cskhId,
        'designerId': designerId,
        'packagePrice': packagePrice,
        'makeupPrice': makeupPrice,
        'designerPrice': designerPrice,
        'photographerPrice': photographerPrice,
        'cskhPrice': cskhPrice,
        'shootingDate': Timestamp.fromDate(shootingDate),
        'shootingHour': shootingTime.hour, // Lưu giờ
        'shootingMinute': shootingTime.minute, // Lưu phút
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerEmail': customerEmail,
        'notes': notes,
        'status': status,
        'createdBy': createdBy,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
        'photographer': photographer.toJson(),
        'makeupArtist': makeupArtist.toJson(),
        'designer': designer.toJson(),
        'cskh': cskh.toJson(),
        'locations': locations.map((location) => location.toJson()).toList(),
      };
}
