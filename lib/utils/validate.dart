String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Mật khẩu không được để trống';
  }
  if (value.length < 6) {
    return 'Mật khẩu phải có ít nhất 6 ký tự';
  }
  if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
    return 'Mật khẩu phải chứa ít nhất một chữ in hoa';
  }
  if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
    return 'Mật khẩu phải chứa ít nhất một chữ thường';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Số điện thoại không được để trống';
  }
  if (!RegExp(r'(^\d{10}$)').hasMatch(value)) {
    return 'Số điện thoại không hợp lệ';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email không được để trống';
  }
  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
    return 'Địa chỉ email không hợp lệ';
  }
  return null;
}

String? validateNotNull(String? value) {
  if (value == null || value.isEmpty) {
    return 'Vui lòng nhập';
  }
  return null;
}
// Bạn có thể thêm các hàm validate khác ở đây
