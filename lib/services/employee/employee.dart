import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:webdding/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeService {
  List<User> _employees = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference employeesCollection =
      FirebaseFirestore.instance.collection('employees');
  final databaseReference = FirebaseDatabase.instance;
  Future<String?> addEmployee(Customer employee, String password) async {
    try {
      // if (await isEmailUnique(employee.email)) {
      // Email là duy nhất, tiếp tục thêm mới nhân viên
      // Thực hiện thêm mới dữ liệu vào Firestore ở đây
      // Ví dụ sử dụng Firebase Firestor
      Timestamp createdAt = Timestamp.now();

      DocumentReference documentReference = employeesCollection.doc();
      // Customer(name: name, email: email)
      // DocumentReference documentReference = await employeesCollection.add({
      //   // Fix this line
      //   'email': employee.email,
      //   'phoneNumber': employee.phoneNumber,
      //   'fullName': employee.fullName,
      //   'name': employee.name,
      //   'rule': "STAFF",
      //   'status': "ACTIVATED",
      //   'created_at': createdAt,
      //   'updated_at': createdAt,
      // });
      // Remove the unnecessary condition
      if (documentReference.id != '') {
        print(
            'Thêm nhân viên thành công, ID của tài liệu: ${documentReference.id}');
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: employee.email,
          password: password,
        );
      } else {
        return "Tạo thất bại";
      }
      // print('Thêm nhân viên thành công');
      return null;
      // } else {
      //   return "Email đã tồn tại";
      // }
    } catch (error) {
      return 'Đã xảy ra lỗi: $error'; // Trả về thông báo lỗi nếu có lỗi
    }
  }

  // Phương thức để lấy danh sách tất cả nhân viên
  List<User> getAllEmployees() {
    return List.from(_employees);
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
      print('Lỗi khi kiểm tra email duy nhất: $e');
      return false; // Xảy ra lỗi, trả về false.
    }
  }
}
