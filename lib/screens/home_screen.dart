import 'package:ap_assistant/components/image_card.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/screens/authentication/login_screen.dart';
import 'package:ap_assistant/screens/family_screen.dart';
import 'package:ap_assistant/screens/medicines_screen.dart';
import 'package:ap_assistant/screens/track_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(controller.patient.name),
            Text(controller.patient.email, style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.normal)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: controller.logout, tooltip: "Logout", splashRadius: 24),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: ImageCard(assetPath: "assets/images/family.png", onTap: controller.openFamilyScreen),
            ),
            SizedBox(
              height: 200,
              child: ImageCard(assetPath: "assets/images/medicine.png", onTap: controller.openMedicinesScreen),
            ),
            SizedBox(
              height: 200,
              child: ImageCard(assetPath: "assets/images/location.png", onTap: controller.openTrackScreen),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeController extends GetxController {
  final Patient patient;
  HomeController({required this.patient});

  void openFamilyScreen() {
    Get.to(() => FamilyScreen());
  }

  void openMedicinesScreen() {
    Get.to(() => const MedicinesScreen(), binding: BindingsBuilder.put(() => MedicineController(patient: patient)));
  }

  void openTrackScreen() {
    Get.to(() => const TrackScreen(), binding: BindingsBuilder.put(() => TrackController(patient: patient)));
  }

  void logout() {
    GetStorage().remove("patient");
    Get.delete<Patient>();
    Get.off(() => const LoginScreen(), binding: BindingsBuilder.put(() => LoginController()));
  }
}
