import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:webdding/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webdding/utils/constant.dart';

class EmployeeService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employees');
  Future<String?> addEmployee(Customer employee, String password) async {
    try {
      if (await isEmailUnique(employee.email)) {
        // Email là duy nhất, tiếp tục thêm mới nhân viên
        // Thực hiện thêm mới dữ liệu vào Firestore ở đây
        // Ví dụ sử dụng Firebase Firestor
        Timestamp createdAt = Timestamp.now();
        // Customer(name: name, email: email)
        employeesCollection.add({
          // Fix this line
          'email': employee.email,
          'code': employee.code,
          'phoneNumber': employee.phoneNumber,
          'fullName': employee.fullName,
          'name': employee.name,
          "type": employee.type,
          'rule': "STAFF",
          'status': ACTIVATED,
          'createBy': employee.createBy,
          'created_at': createdAt,
          'updated_at': createdAt,
        }).then((docRef) {
          if (kDebugMode) {
            print('Document Added with ID: ${docRef.id}');
          }

          _auth.createUserWithEmailAndPassword(
            email: employee.email,
            password: password,
          );
          return null; // Đăng nhập thành công
        }).catchError((error) {
          if (kDebugMode) {
            print('Error adding document: $error');
          }
          throw "Thất bại"; // tạo thất bại
        });
      } else {
        return "Email đã tồn tại";
      }
    } catch (error) {
      return 'Đã xảy ra lỗi: $error'; // Trả về thông báo lỗi nếu có lỗi
    }
    return null;
  }

  // Phương thức để lấy danh sách tất cả nhân viên
  Future<List<Customer>> getEmployees(String createBy) async {
    try {
      final QuerySnapshot querySnapshot = await employeesCollection
          .where('createBy', isEqualTo: createBy)
          .get();

      final List<Customer> employees = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final id = doc.id; // Lấy trường id của tài liệu
        return Customer.fromJson(data, id);
      }).toList();

      return employees;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching employees: $e');
      }
      return [];
    }
  }

  Future<String?> updateEmployee(Customer employee) async {
    try {
      if (await isEmailUniqueById(employee.email, employee.id)) {
        await employeesCollection.doc(employee.id).update({
          'name': employee.name,
          'email': employee.email,
          'phoneNumber': employee.phoneNumber,
          'type': employee.type,
          'createBy': employee.createBy,
          'updated_at': Timestamp.now(),
        });
      } else {
        return "Email đã tồn tại";
      }
      return null; // Cập nhật thành công
    } catch (error) {
      return 'Đã xảy ra lỗi: $error'; // Trả về thông báo lỗi nếu có lỗi
    }
  }

  Future<bool> isEmailUnique(String email) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection(
              'employees') // Thay 'employees' bằng tên collection của bạn
          .where('email', isEqualTo: email)
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

  Future<bool> isEmailUniqueById(String email, String id) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection(
              'employees') // Thay 'employees' bằng tên collection của bạn
          .where('email', isEqualTo: email)
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

  Future<Customer?> getEmployeeByEmail(String email) async {
    try {

      // Use a query to filter documents by email
      QuerySnapshot querySnapshot = await employeesCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final data = documentSnapshot.data() as Map<String, dynamic>;
        return Customer.fromJson(data, documentSnapshot.id);
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
  

  Future<Customer?> getEmployeeById(String? id) async {
    try {

      // Use a query to filter documents by email
      QuerySnapshot querySnapshot = await employeesCollection
          .where(FieldPath.documentId, isEqualTo: id)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs[0];
        final data = documentSnapshot.data() as Map<String, dynamic>;
        return Customer.fromJson(data, documentSnapshot.id);
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

  // Phương thức để lấy danh sách tất cả nhân viên
  Future<List<Customer>> getByType(
      String createBy, String type, String status) async {
    try {
      Query query = employeesCollection.where('createBy', isEqualTo: createBy);

      // Remove the unnecessary condition
      if (type.isNotEmpty) {
        // Kiểm tra và thêm điều kiện truy vấn theo trường "status" khi nó được truyền vào và khác rỗng
        query = query.where('type', isEqualTo: type);
      }
      // Remove the unnecessary condition
      if (status.isNotEmpty) {
        // Kiểm tra và thêm điều kiện truy vấn theo trường "status" khi nó được truyền vào và khác rỗng
        query = query.where('status', isEqualTo: status);
      }
      final QuerySnapshot querySnapshot = await query.get();
      final List<Customer> employees = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final id = doc.id; // Lấy trường id của tài liệu
        return Customer.fromJson(data, id);
      }).toList();

      return employees;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching employees: $e');
      }
      return [];
    }
  }
}
