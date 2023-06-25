import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModalBottomSheet {
  static Future<R?> show<R, C>({required Widget sheet, required C controller, bool isScrollControlled = true}) {
    Get.lazyPut(() => controller);
    return Get.bottomSheet<R>(
      sheet,
      backgroundColor: Colors.white,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    );
  }
}
