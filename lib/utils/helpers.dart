import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushbar(BuildContext context, String message, bool isRes) {
    // ignore: avoid_single_cascade_in_expression_statements
    Flushbar(
      message: message,
      duration: Duration(seconds: 3),
      backgroundColor: isRes ? Colors.green : Colors.red,
      flushbarPosition: FlushbarPosition.TOP, // Đặt vị trí ở trên cùng
    )..show(context);
  }