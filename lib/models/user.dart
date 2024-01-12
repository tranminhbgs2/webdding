// user.dart
class Customer {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String fullName;
  final String rule;

  Customer({this.id = '', required this.name, required this.email, this.phoneNumber = '', this.fullName = '', this.rule = ''});

  // Thêm các phương thức từ JSON về model và ngược lại, nếu cần
}
