import 'package:ap_assistant/screens/splash_screen.dart';
import 'package:ap_assistant/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Future<void> initServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
}

void main() async {
  await initServices();
  runApp(const APAssistantApp());
}

class APAssistantApp extends StatelessWidget {
  const APAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: appThemeData,
      title: "AP Assistant",
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      initialBinding: BindingsBuilder.put(() => SplashController()),
    );
  }
}
