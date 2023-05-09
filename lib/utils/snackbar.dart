import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackType { message, info, success, warning, error }

class Snackbar {
  static void show(String message, {SnackType type = SnackType.message, SnackPosition position = SnackPosition.TOP}) {
    final String title;
    if (type == SnackType.error) {
      title = "Error";
    } else if (type == SnackType.warning) {
      title = "Warning";
    } else if (type == SnackType.success) {
      title = "Success";
    } else if (type == SnackType.info) {
      title = "Info";
    } else {
      title = "Message";
    }

    final Color backgroundColor;
    if (type == SnackType.error) {
      backgroundColor = Colors.red.withOpacity(0.5);
    } else if (type == SnackType.warning) {
      backgroundColor = Colors.orange.withOpacity(0.5);
    } else if (type == SnackType.success) {
      backgroundColor = Colors.green.withOpacity(0.5);
    } else if (type == SnackType.info) {
      backgroundColor = Colors.blue.withOpacity(0.5);
    } else {
      backgroundColor = Colors.black.withOpacity(0.5);
    }

    final Icon? icon;
    if (type == SnackType.error) {
      icon = const Icon(Icons.error, color: Colors.red);
    } else if (type == SnackType.warning) {
      icon = const Icon(Icons.warning, color: Colors.orange);
    } else if (type == SnackType.success) {
      icon = const Icon(Icons.check_circle, color: Colors.green);
    } else if (type == SnackType.info) {
      icon = const Icon(Icons.info, color: Colors.blue);
    } else {
      icon = null;
    }

    Get.snackbar(
      title,
      message,
      icon: icon,
      snackPosition: position,
      backgroundColor: backgroundColor,
      dismissDirection: DismissDirection.horizontal,
    );
  }
}
