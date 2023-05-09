import 'package:ap_assistant/apis/patients_api.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/screens/authentication/login_screen.dart';
import 'package:ap_assistant/screens/home_screen.dart';
import 'package:ap_assistant/theme.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

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
            ElevatedButton(onPressed: controller.register, child: const Text("REGISTER")),
            const SizedBox(height: 16),
            _alreadyHaveAccountRow(),
          ],
        ),
      ),
    );
  }

  Widget _formFields() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: controller.fullNameValidator,
          controller: controller.fullNameController,
          decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: controller.emailValidator,
          textInputAction: TextInputAction.next,
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: true,
          textInputAction: TextInputAction.next,
          validator: controller.passwordValidator,
          controller: controller.passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          validator: controller.confirmPasswordValidator,
          controller: controller.confirmPasswordController,
          decoration: const InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.lock)),
        ),
      ],
    );
  }

  Widget _alreadyHaveAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already have an Account? "),
        InkResponse(
          onTap: controller.login,
          child: Text("Login", style: TextStyle(color: appThemeData.primaryColor, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class RegisterController extends GetxController {
  late final GlobalKey<FormState> formKey;
  late final TextEditingController emailController;
  late final TextEditingController fullNameController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  @override
  void onInit() {
    formKey = GlobalKey<FormState>();
    emailController = TextEditingController();
    fullNameController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.onInit();
  }

  String? fullNameValidator(String? value) {
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

  String? confirmPasswordValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This Field Is Required";
    }

    if (confirmPasswordController.text != passwordController.text) {
      return "The Passwords Don't Match";
    }

    return null;
  }

  void login() {
    Get.off(() => const LoginScreen(), binding: BindingsBuilder.put(() => LoginController()));
  }

  void register() async {
    Get.focusScope?.unfocus();
    if (!formKey.currentState!.validate()) return;

    final request = PatientRegisterRequest(
      name: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    Patient patient;
    try {
      patient = await PatientsApi.register(request);
    } catch (e) {
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    Snackbar.show("Registration Completed Successfully", type: SnackType.success);

    GetStorage().write("patient", patient);
    Get.put<Patient>(patient, permanent: true);
    Get.off(() => const HomeScreen(), binding: BindingsBuilder.put(() => HomeController(patient: patient)));
  }
}
