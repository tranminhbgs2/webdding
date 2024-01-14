import 'dart:math';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showFlushbar(BuildContext context, String message, bool isRes) {
  // ignore: avoid_single_cascade_in_expression_statements
  Flushbar(
    message: message,
    duration: const Duration(seconds: 3),
    backgroundColor: isRes ? Colors.green : Colors.red,
    flushbarPosition: FlushbarPosition.TOP, // Đặt vị trí ở trên cùng
  )..show(context);
}

// Random chuỗi số và chữ in hoa
String getRandomString(int length) {
  const String letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const String numbers = '0123456789';
  const String chars = letters + numbers;

  Random rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
}

// hiển thị ngày giờ từ Firebase Firestore dưới dạng "13/01/2024 00:00:00"
String formatDateTime(DateTime dateTime) {
  final day = dateTime.day.toString().padLeft(2, '0');
  final month = dateTime.month.toString().padLeft(2, '0');
  final year = dateTime.year.toString();
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');
  final second = dateTime.second.toString().padLeft(2, '0');
  return '$day/$month/$year $hour:$minute:$second';
}

//chuyển đổi chuỗi ngày giờ từ Firestore thành đối tượng DateTime 
DateTime parseDateTime(String formattedDateTime) {
  final parts = formattedDateTime.split(' ');
  final dateParts = parts[0].split('/');
  final timeParts = parts[1].split(':');
  final day = int.parse(dateParts[0]);
  final month = int.parse(dateParts[1]);
  final year = int.parse(dateParts[2]);
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);
  final second = int.parse(timeParts[2]);
  return DateTime(year, month, day, hour, minute, second);
}

String formatPrice(double price) {
  final format = NumberFormat.simpleCurrency(locale: 'vi_VN'); // Sử dụng định dạng tiền tệ Việt Nam
  return format.format(price);
}