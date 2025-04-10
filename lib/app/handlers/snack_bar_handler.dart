import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class SnackBarHandler {
  static void snackBarError(String message) {
    Get.snackbar(
      'Error',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
      borderRadius: 12,
      duration: Duration(seconds: 2),
    );
  }

  static void snackBarSuccess(String message) {
    Get.snackbar(
      'Success',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
      borderRadius: 12,
      duration: Duration(seconds: 2),
    );
  }
}
