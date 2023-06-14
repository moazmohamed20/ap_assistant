import 'package:ap_assistant/apis/patients_api.dart';
import 'package:ap_assistant/dialogs/loading_dialog.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/screens/authentication/login_screen.dart';
import 'package:ap_assistant/screens/home_screen.dart';
import 'package:ap_assistant/theme.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:ap_assistant/utils/validators.dart';
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
            Hero(tag: 'logo', child: Image.asset("assets/images/logo.png", height: 200)),
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
          validator: Validators.fullNameValidator,
          controller: controller.fullNameController,
          decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          validator: Validators.emailValidator,
          textInputAction: TextInputAction.next,
          controller: controller.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: true,
          textInputAction: TextInputAction.next,
          validator: Validators.passwordValidator,
          controller: controller.passwordController,
          keyboardType: TextInputType.visiblePassword,
          decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          controller: controller.confirmPasswordController,
          decoration: const InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.lock)),
          validator: (value) => Validators.confirmPasswordValidator(value, controller.passwordController.text),
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

  void login() {
    Get.off(() => const LoginScreen(), binding: BindingsBuilder.put(() => LoginController()));
  }

  void register() async {
    Get.focusScope?.unfocus();
    if (!formKey.currentState!.validate()) return;

    Patient patient;
    final request = PatientRegisterRequest(
      name: fullNameController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text,
    );
    try {
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      patient = await PatientsApi.register(request);
      Get.back();
    } catch (e) {
      Get.back();
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    Snackbar.show("Registration Completed Successfully", type: SnackType.success);

    GetStorage().write("patient", patient);
    Get.put<Patient>(patient, permanent: true);
    Get.off(() => const HomeScreen(), binding: BindingsBuilder.put(() => HomeController(patient: patient)));
  }
}
