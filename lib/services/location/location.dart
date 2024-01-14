import 'package:webdding/models/localtion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:webdding/utils/constant.dart';

class LocationService {
  final CollectionReference locationsCollection =
      FirebaseFirestore.instance.collection('locations');
  Future<String?> addLocation(Location localtion) async {
    try {
      if (await isNameUnique(localtion.name)) {
        // Email là duy nhất, tiếp tục thêm mới nhân viên
        // Thực hiện thêm mới dữ liệu vào Firestore ở đây
        // Ví dụ sử dụng Firebase Firestor
        Timestamp createdAt = Timestamp.now();
        // Customer(name: name, email: email)
        locationsCollection.add({
          // Fix this line
          'description': localtion.description,
          'address': localtion.address,
          'userCode': localtion.userCode,
          'name': localtion.name,
          'status': ACTIVATED,
          'created_at': createdAt,
          'updated_at': createdAt,
        }).then((docRef) {
          // print('Document Added with ID: ${docRef.id}');

          return null; // Đăng nhập thành công
        }).catchError((error) {
          // print('Error adding document: $error');
          throw "Thất bại"; // Đăng nhập thành công
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
  Future<List<Location>> listLocation(String userCode, String status) async {
    try {
      Query query = locationsCollection.where('userCode', isEqualTo: userCode);

      // Remove the unnecessary condition
      if (status.isNotEmpty) {
        // Kiểm tra và thêm điều kiện truy vấn theo trường "status" khi nó được truyền vào và khác rỗng
        query = query.where('status', isEqualTo: status);
      }
      final QuerySnapshot querySnapshot = await query.get();
      final List<Location> locations = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final id = doc.id; // Lấy trường id của tài liệu
        return Location.fromJson(data, id);
      }).toList();

      return locations;
    } catch (e) {
      // print('Error fetching locations: $e');
      return [];
    }
  }

  Future<String?> updateLocation(Location location) async {
    try {
      if (await isNameUniqueById(location.name, location.id)) {
        await locationsCollection.doc(location.id).update({
          'name': location.name,
          'description': location.description,
          'address': location.address,
          'status': location.status,
          'userCode': location.userCode,
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

  Future<bool> isNameUnique(String name) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection(
              'location') // Thay 'employees' bằng tên collection của bạn
          .where('name', isEqualTo: name)
          .get();

      return result
          .docs.isEmpty; // Nếu không có tài liệu nào khớp, email là duy nhất.
    } catch (e) {
      // print('Lỗi khi kiểm tra email duy nhất: $e');
      return false; // Xảy ra lỗi, trả về false.
    }
  }

  Future<bool> isNameUniqueById(String name, String id) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
          .instance
          .collection(
              'locations') // Thay 'employees' bằng tên collection của bạn
          .where('name', isEqualTo: name)
          .where(FieldPath.documentId, isNotEqualTo: id)
          .get();

      return result
          .docs.isEmpty; // Nếu không có tài liệu nào khớp, email là duy nhất.
    } catch (e) {
      // print('Lỗi khi kiểm tra email duy nhất: $e');
      return false; // Xảy ra lỗi, trả về false.
    }
  }
}
