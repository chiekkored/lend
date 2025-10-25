import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lend/core/mixins/textfields.mixin.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/pages/signup/components/setup.page.dart';
import 'package:lend/presentation/pages/signup/widgets/dob.widget.dart';
import 'package:lend/utilities/enums/eligibility.enum.dart';
import 'package:lend/utilities/enums/user_types.enum.dart';
import 'package:lend/utilities/extensions/datetime.extension.dart';

class SignUpController extends GetxController with TextFieldsMixin {
  static final instance = Get.find<SignUpController>();

  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final signUpKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  final setupKey = GlobalKey<FormState>();

  final RxBool _showObscureText = false.obs;
  bool get showObscureText => _showObscureText.value;

  final RxBool _showObscureConfirmText = false.obs;
  bool get showObscureConfirmText => _showObscureConfirmText.value;

  @override
  void onClose() {
    emailController.dispose();
    confirmPasswordController.dispose();
    passwordController.dispose();

    _showObscureText.close();
    _showObscureConfirmText.close();

    super.onClose();
  }

  bool _validateSignUpForm() => setupKey.currentState?.validate() ?? false;
  void togglePasswordVisibility() => _showObscureText.toggle();
  void toggleConfirmPasswordVisibility() => _showObscureConfirmText.toggle();

  void goToSetup() async {
    if (!(signUpKey.currentState?.validate() ?? false)) {
      return;
    }
    await Get.toNamed(SetupPage.routeName);
    _resetFields();
  }

  void _resetFields() {
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    dobController.clear();
  }

  void signUp() async {
    if (!_validateSignUpForm()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    try {
      LNDLoading.show();

      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      if (userCredential.user != null) {
        // Add User to Firestore Collection: "users"
        final UserModel user = UserModel(
          uid: userCredential.user?.uid,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          dateOfBirth: dobController.text.trim().toFormattedDateTime(),
          location: null,
          photoUrl: userCredential.user?.photoURL,
          createdAt: Timestamp.now(),
          email: email,
          phone: userCredential.user?.phoneNumber,
          type: UserType.renter.label,
          isListingEligible: Eligibility.no,
          isRentingEligible: Eligibility.no,
        );

        await AuthController.instance.registerToFirestore(user: user);

        // if (!userCredential.user!.emailVerified) {
        //   await userCredential.user!.sendEmailVerification();
        //   LNDSnackbar.showInfo('Sent a verification link to email provided');
        // }

        LNDLoading.hide();
        // Get.offAll(() => const NavigationPage(), binding: NavigationBinding());

        Get.until((page) => page.isFirst);
      } else {
        LNDLoading.hide();
        LNDSnackbar.showError(
          'Something went wrong. Please try another provider',
        );
        AuthController.instance.signOut();
        return;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        LNDSnackbar.showError('The password provided is too weak');
        debugPrint('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        LNDSnackbar.showError('The account already exists for that email');
        debugPrint('The account already exists for that email.');
      } else {
        LNDSnackbar.showError('Please try again later');
      }
    }
  }

  void goToSignIn() => Get.back();

  Future<void> onTapDob() async {
    if (Platform.isIOS) {
      await LNDShow.bottomSheet(
        const DateOfBirth(),
        expand: false,
        enableDrag: false,
        isDismissible: false,
      );
    } else {
      await showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      ).then((pickedDate) {
        if (pickedDate != null) {
          dobController.text = DateFormat('MMMM dd, yyyy').format(pickedDate);
        }
      });
    }
  }
}
