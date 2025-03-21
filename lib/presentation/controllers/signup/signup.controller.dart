import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  static final instance = Get.find<SignUpController>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final RxBool _showObscureText = false.obs;
  bool get showObscureText => _showObscureText.value;

  final RxBool _showObscureConfirmText = false.obs;
  bool get showObscureConfirmText => _showObscureConfirmText.value;

  @override
  void onClose() {
    emailController.dispose();
    passwordConfirmController.dispose();
    passwordController.dispose();

    _showObscureText.close();
    _showObscureConfirmText.close();

    super.onClose();
  }

  void togglePasswordVisibility() => _showObscureText.toggle();
  void toggleConfirmPasswordVisibility() => _showObscureConfirmText.toggle();

  void signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Call the API to sign in
  }

  void goToSignIn() => Get.back();
}
