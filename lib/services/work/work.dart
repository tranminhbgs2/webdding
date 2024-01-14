import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:webdding/models/localtion.dart';
import 'package:webdding/models/work_schedule.dart'; // Đảm bảo đường dẫn đến model WorkSchedule đúng

class WorkScheduleService {
  final CollectionReference workCollection =
      FirebaseFirestore.instance.collection('works');
  final CollectionReference locationCollection =
      FirebaseFirestore.instance.collection('locations');

  Future<String?> addWorkSchedule(WorkSchedule workSchedule) async {
    try {
      // Tạo một document mới trong collection 'workSchedules'
      await workCollection.add(workSchedule.toJson());
      return null;
    } catch (e) {
      // Xử lý lỗi
      if (kDebugMode) {
        print('Error adding work schedule: $e');
      }
      return e.toString();
    }
  }

  // Phương thức để lấy danh sách lịch làm việc
  // Future<List<WorkSchedule>> getListWork(String createBy) async {
  //   try {
  //     final QuerySnapshot querySnapshot = await workCollection.get();
  //     if (querySnapshot.docs.isEmpty) {
  //       // Nếu không có tài liệu nào, trả về danh sách rỗng
  //       return [];
  //     }
  //     final List<WorkSchedule> employees = querySnapshot.docs.map((doc) {
  //       final data = doc.data() as Map<String, dynamic>;
  //       final id = doc.id; // Lấy trường id của tài liệu
  //       return WorkSchedule.fromJson(data, id);
  //     }).toList();

  //     return employees;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print('Error fetching employees: $e');
  //     }
  //     return [];
  //   }
  // }
  Future<List<WorkSchedule>> getListWork(String createBy) async {
    try {
      final QuerySnapshot querySnapshot =
          await workCollection.where('createdBy', isEqualTo: createBy).get();
      if (querySnapshot.docs.isEmpty) {
        // Nếu không có tài liệu nào, trả về danh sách rỗng
        return [];
      }

      final List<WorkSchedule> workSchedules = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final id = doc.id; // Retrieve the document ID
        return WorkSchedule.fromJson(data, id);
      }).toList();

      return workSchedules;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching workSchedules: $e');
      }
      return [];
    }
  }

  Future<String?> updateWork(WorkSchedule work) async {
    try {
      if (await isWorkUniqueById(work.createdBy, work.id)) {
        await workCollection.doc(work.id).update({
          'customerEmail': work.customerEmail,
          'customerName': work.customerName,
          'customerPhone': work.customerPhone,
          'locationIds': work.locationIds,
          'makeupArtistId': work.makeupArtistId,
          'photographerId': work.photographerId,
          'shootingDate': work.shootingDate,
          'shootingTime': work.shootingTime,
          'status': work.status,
          'createBy': work.createdBy,
          'updated_at': Timestamp.now(),
        });
      } else {
        return "Không thấy thông tin";
      }
      return null; // Cập nhật thành công
    } catch (error) {
      return 'Đã xảy ra lỗi: $error'; // Trả về thông báo lỗi nếu có lỗi
    }
  }

  Future<bool> isWorkUniqueById(String createBy, String id) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection('works') // Thay 'employees' bằng tên collection của bạn
          .where('createBy', isEqualTo: createBy)
          .where(FieldPath.documentId, isNotEqualTo: id)
          .get();

      return result
          .docs.isEmpty; // Nếu không có tài liệu nào khớp, email là duy nhất.
    } catch (e) {
      if (kDebugMode) {
        print('Lỗi khi kiểm tra email duy nhất: $e');
      }
      return false; // Xảy ra lỗi, trả về false.
    }
  }

  Future<WorkSchedule?> isWorkById(String email, String id) async {
    try {
      // Use a query to filter documents by email
      QuerySnapshot querySnapshot =
          await workCollection.where('email', isEqualTo: email).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final data = documentSnapshot.data() as Map<String, dynamic>;
        return WorkSchedule.fromJson(data, documentSnapshot.id);
      } else {
        // If no matching document is found, return null
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting employee by email: $e');
      }
      return null;
    }
  }

  Future<List<Location>> getLocationsByIds(List<String> locationIds) async {
    final List<Location> locations = [];

    // Lặp qua các IDs của nhân viên và truy vấn thông tin của họ
    for (final locationId in locationIds) {
      try {
        final DocumentSnapshot locationSnapshot =
            await locationCollection.doc(locationId).get();
        if (locationSnapshot.exists) {
          final Map<String, dynamic> employeeData =
              locationSnapshot.data() as Map<String, dynamic>;

          final Location employee = Location.fromJsonV2(employeeData);
          locations.add(employee);
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error fetching employee with ID $locationId: $e');
        }
      }
    }

    return locations;
  }
}
