import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/screens/authentication/login_screen.dart';
import 'package:ap_assistant/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vibration/vibration.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TweenAnimationBuilder<double>(
          curve: Curves.bounceOut,
          onEnd: controller.onAnimationEnd,
          duration: const Duration(seconds: 1),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: Hero(tag: 'logo', child: Image.asset("assets/images/logo.png", width: 100, height: 100)),
          ),
        ),
      ),
    );
  }
}

class SplashController extends GetxController {
  late final bool hasLoggedIn;
  late final Patient? patient;

  @override
  void onInit() {
    hasLoggedIn = GetStorage().hasData("patient");

    if (hasLoggedIn) {
      patient = Patient.fromJson(GetStorage().read("patient"));
      Get.put<Patient>(patient!, permanent: true);
    }

    super.onInit();
  }

  @override
  void onReady() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(pattern: [350, 50, 300, 50, 200, 50]);
    }
    super.onReady();
  }

  void onAnimationEnd() {
    if (hasLoggedIn) {
      Get.off(() => const HomeScreen(), binding: BindingsBuilder.put(() => HomeController(patient: patient!)));
    } else {
      Get.off(() => const LoginScreen(), binding: BindingsBuilder.put(() => LoginController()));
    }
  }
}
