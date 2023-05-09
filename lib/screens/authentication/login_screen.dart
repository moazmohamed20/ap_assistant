import 'package:ap_assistant/apis/patients_api.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/screens/authentication/register_screen.dart';
import 'package:ap_assistant/screens/home_screen.dart';
import 'package:ap_assistant/theme.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            Image.asset("assets/images/family.png"),
            const SizedBox(height: 32),
            Form(key: controller.formKey, child: _formFields()),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: controller.login, child: const Text("LOGIN")),
            const SizedBox(height: 16),
            _doNotHaveAccountRow(),
          ],
        ),
      ),
    );
  }

  Widget _formFields() {
    return Column(
      children: [
        TextFormField(
          textInputAction: TextInputAction.next,
          validator: controller.emailValidator,
          keyboardType: TextInputType.emailAddress,
          controller: controller.emailController,
          decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          validator: controller.passwordValidator,
          controller: controller.passwordController,
          decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock)),
        ),
      ],
    );
  }

  Widget _doNotHaveAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an Account? "),
        InkResponse(
          onTap: controller.register,
          child: Text("Register", style: TextStyle(color: appThemeData.primaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class LoginController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.onInit();
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }
    value = value.trim();

    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$").hasMatch(value)) {
      return "Invalid Email";
    }

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }

    if (!RegExp(r"^.{8,}$").hasMatch(value)) {
      return "The Password Must Be 8 Characters At Least";
    }

    return null;
  }

  void register() {
    Get.off(() => const RegisterScreen(), binding: BindingsBuilder.put(() => RegisterController()));
  }

  void login() async {
    Get.focusScope?.unfocus();
    if (!formKey.currentState!.validate()) return;

    Patient patient;
    final request = PatientLoginRequest(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    try {
      patient = await PatientsApi.login(request);
    } catch (e) {
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    GetStorage().write("patient", patient);
    Get.put<Patient>(patient, permanent: true);
    Get.off(() => const HomeScreen(), binding: BindingsBuilder.put(() => HomeController(patient: patient)));
  }
}
