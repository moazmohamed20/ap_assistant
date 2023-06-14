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
            ImageCard(
              height: 200,
              elevation: 4,
              title: "Family",
              onTap: controller.openFamilyScreen,
              background: "assets/images/family.png",
              margin: const EdgeInsets.symmetric(vertical: 8),
              titleBackgroundColor: Colors.orange.withOpacity(0.75),
            ),
            ImageCard(
              height: 200,
              elevation: 4,
              title: "Medicines",
              onTap: controller.openMedicinesScreen,
              background: "assets/images/medicine.png",
              margin: const EdgeInsets.symmetric(vertical: 8),
              titleBackgroundColor: Colors.blue.withOpacity(0.75),
            ),
            ImageCard(
              height: 200,
              elevation: 4,
              title: "Tracking",
              onTap: controller.openTrackScreen,
              background: "assets/images/location.png",
              margin: const EdgeInsets.symmetric(vertical: 8),
              titleBackgroundColor: Colors.brown.withOpacity(0.75),
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
    Get.to(() => const FamilyScreen(), binding: BindingsBuilder.put(() => FamilyController(patient: patient)));
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
