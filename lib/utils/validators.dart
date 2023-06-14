import 'package:get/get.dart';

class Validators {
  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }
    value = value.trim();

    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$").hasMatch(value)) {
      return "Invalid Email";
    }

    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }

    if (!RegExp(r"^.{8,}$").hasMatch(value)) {
      return "The Password Must Be 8 Characters At Least";
    }

    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }

    if (value != password) {
      return "The Passwords Don't Match";
    }

    return null;
  }

  static String? fullNameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }
    value = value.trim();

    final enteredFullName = value.replaceAll(RegExp(r"\s+"), ' ').trim().split(' ');

    if (enteredFullName.length < 2) {
      return "Full Name Must Be 2 Names At Least";
    } else if (enteredFullName.firstWhereOrNull((name) => name.length < 2) != null) {
      return "Each Name Must Be 2 Characters At Least";
    }

    return null;
  }

  static String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }
    return null;
  }
}
