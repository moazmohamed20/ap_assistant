import 'package:ap_assistant/apis/patients_api.dart';
import 'package:ap_assistant/dialogs/loading_dialog.dart';
import 'package:ap_assistant/models/patient.dart';
import 'package:ap_assistant/screens/authentication/register_screen.dart';
import 'package:ap_assistant/screens/home_screen.dart';
import 'package:ap_assistant/theme.dart';
import 'package:ap_assistant/utils/snackbar.dart';
import 'package:ap_assistant/utils/validators.dart';
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
            Hero(tag: 'logo', child: Image.asset("assets/images/logo.png", height: 200)),
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
          validator: Validators.emailValidator,
          keyboardType: TextInputType.emailAddress,
          controller: controller.emailController,
          decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
        ),
        const SizedBox(height: 8),
        TextFormField(
          obscureText: true,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.visiblePassword,
          validator: Validators.passwordValidator,
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
      Get.dialog(const LoadingDialog(), barrierDismissible: false);
      patient = await PatientsApi.login(request);
      Get.back();
    } catch (e) {
      Get.back();
      Snackbar.show(e.toString(), type: SnackType.error);
      return;
    }

    Snackbar.show("Logged In Successfully", type: SnackType.success);

    GetStorage().write("patient", patient);
    Get.put<Patient>(patient, permanent: true);
    Get.off(() => const HomeScreen(), binding: BindingsBuilder.put(() => HomeController(patient: patient)));
  }
}
