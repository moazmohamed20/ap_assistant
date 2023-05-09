import 'package:flutter/material.dart';

final appThemeData = ThemeData(
  primarySwatch: Colors.brown,
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12.5))),
      maximumSize: const Size(double.infinity, 50),
      minimumSize: const Size(double.infinity, 50),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    contentPadding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5), borderSide: const BorderSide(color: Colors.black12)),
  ),
);
