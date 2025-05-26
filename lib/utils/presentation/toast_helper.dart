import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void showSuccessToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  static showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      timeInSecForIosWeb: 1,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}