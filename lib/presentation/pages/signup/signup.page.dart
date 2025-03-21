import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/signup/signup.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class SignUpPage extends GetView<SignUpController> {
  static const routeName = '/signup';
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: LNDColors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: LNDButton.back(),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LNDText.bold(
                text: 'Create an account',
                fontSize: 32.0,
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LNDTextField.regular(
                        hintText: 'Email',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: FontAwesomeIcons.solidEnvelope,
                        prefixIconColor: LNDColors.gray,
                        prefixIconSize: 16.0,
                      ),
                      Obx(
                        () => LNDTextField.regular(
                          hintText: 'Password',
                          controller: controller.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !controller.showObscureText,
                          prefixIcon: FontAwesomeIcons.lock,
                          prefixIconColor: LNDColors.gray,
                          prefixIconSize: 16.0,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.none,
                          suffixIcon: controller.showObscureText
                              ? FontAwesomeIcons.solidEye
                              : FontAwesomeIcons.solidEyeSlash,
                          suffixIconSize: 16.0,
                          onTapSuffix: controller.togglePasswordVisibility,
                        ),
                      ),
                      Obx(
                        () => LNDTextField.regular(
                          hintText: 'Confirm Password',
                          controller: controller.passwordConfirmController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !controller.showObscureConfirmText,
                          prefixIcon: FontAwesomeIcons.lock,
                          prefixIconColor: LNDColors.gray,
                          prefixIconSize: 16.0,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.none,
                          suffixIcon: controller.showObscureConfirmText
                              ? FontAwesomeIcons.solidEye
                              : FontAwesomeIcons.solidEyeSlash,
                          suffixIconSize: 16.0,
                          onTapSuffix:
                              controller.toggleConfirmPasswordVisibility,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: LNDButton.primary(
                            text: 'Sign up', enabled: true, onPressed: () {}),
                      ),
                    ],
                  ).withSpacing(16.0),
                ),
              ),
              SafeArea(
                child: SizedBox(
                  height: 40.0,
                  child: Center(
                    child: GestureDetector(
                      onTap: controller.goToSignIn,
                      child: LNDText.regular(
                        text: 'Already have an account?',
                        color: LNDColors.hint,
                        textParts: [
                          LNDText.bold(
                            text: ' Sign in',
                            color: LNDColors.primary,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ).withSpacing(16.0),
        ),
      ),
    );
  }
}
