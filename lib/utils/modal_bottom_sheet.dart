import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModalBottomSheet {
  static Future<T?> show<T>({required Widget sheet, GetxController? controller, bool isScrollControlled = true}) {
    if (controller != null) Get.lazyPut(() => controller);
    return Get.bottomSheet<T>(
      sheet,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    );
  }
}
