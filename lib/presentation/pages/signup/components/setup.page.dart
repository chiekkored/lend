import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/signup/signup.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class SetupPage extends GetView<SignUpController> {
  static const routeName = '/setup';
  const SetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: LNDColors.white,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: LNDButton.back(),
          backgroundColor: LNDColors.white,
          surfaceTintColor: LNDColors.white,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LNDText.bold(text: 'Finish setting up', fontSize: 32.0),
                Form(
                  key: controller.setupKey,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LNDTextField.regular(
                        labelText: 'Email',
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: FontAwesomeIcons.solidEnvelope,
                        prefixIconColor: LNDColors.gray,
                        prefixIconSize: 16.0,
                        validator: controller.validateEmail,
                        readOnly: true,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.0),
                        child: Divider(),
                      ),
                      Column(
                        children: [
                          LNDTextField.regular(
                            labelText: 'First Name',
                            controller: controller.firstNameController,
                            validator:
                                (value) => controller.validateField(
                                  value,
                                  label: 'First Name',
                                ),
                          ),
                          LNDTextField.regular(
                            labelText: 'Last Name',
                            controller: controller.lastNameController,
                            validator:
                                (value) => controller.validateField(
                                  value,
                                  label: 'Last Name',
                                ),
                          ),
                          LNDText.regular(
                            text:
                                'Enter your first and last name exactly as it '
                                'appears on your government-issued ID to ensure '
                                'accurate identity verification and prevent delays.',
                            fontSize: 12.0,
                            color: LNDColors.hint,
                          ),
                        ],
                      ).withSpacing(4.0),

                      Column(
                        children: [
                          LNDTextField.regular(
                            labelText: 'Date of Birth',
                            controller: controller.dobController,
                            readOnly: true,
                            validator: controller.validateDateOfBirth,
                            onTap: controller.onTapDob,
                          ),
                          LNDText.regular(
                            text:
                                'Collecting your date of birth helps us verify '
                                'your identity and ensure you meet age-related '
                                'eligibility requirements.',
                            fontSize: 12.0,
                            color: LNDColors.hint,
                          ),
                        ],
                      ).withSpacing(6.0),
                      Column(
                        children: [
                          Obx(
                            () => LNDTextField.regular(
                              labelText: 'Password',
                              controller: controller.passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !controller.showObscureText,
                              prefixIcon: FontAwesomeIcons.lock,
                              prefixIconColor: LNDColors.gray,
                              prefixIconSize: 16.0,
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.none,
                              suffixIcon:
                                  controller.showObscureText
                                      ? FontAwesomeIcons.solidEye
                                      : FontAwesomeIcons.solidEyeSlash,
                              suffixIconSize: 16.0,
                              onTapSuffix: controller.togglePasswordVisibility,
                              // validator: controller.validatePassword,
                            ),
                          ),
                          Obx(
                            () => LNDTextField.regular(
                              labelText: 'Confirm Password',
                              controller: controller.confirmPasswordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !controller.showObscureConfirmText,
                              prefixIcon: FontAwesomeIcons.lock,
                              prefixIconColor: LNDColors.gray,
                              prefixIconSize: 16.0,
                              textInputAction: TextInputAction.done,
                              textCapitalization: TextCapitalization.none,
                              suffixIcon:
                                  controller.showObscureConfirmText
                                      ? FontAwesomeIcons.solidEye
                                      : FontAwesomeIcons.solidEyeSlash,
                              suffixIconSize: 16.0,
                              onTapSuffix:
                                  controller.toggleConfirmPasswordVisibility,
                              // validator:
                              //     (value) => controller.validateConfirmPassword(
                              //       controller.passwordController.text,
                              //       value,
                              //     ),
                            ),
                          ),
                        ],
                      ).withSpacing(4.0),
                    ],
                  ).withSpacing(28.0),
                ),
              ],
            ).withSpacing(16.0),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          height: kBottomNavigationBarHeight + 75.0,
          color: LNDColors.white,
          child: Column(
            children: [
              LNDText.regular(
                text: 'By clicking ',
                fontSize: 12.0,
                textParts: [
                  LNDText.bold(text: 'Agree and sign up ', fontSize: 12.0),
                  LNDText.regular(
                    text: 'you confirm that you have read and agree to our ',
                    fontSize: 12.0,
                  ),
                  LNDText.bold(text: 'Terms and Conditions', fontSize: 12.0),
                  LNDText.regular(text: ' and ', fontSize: 12.0),
                  LNDText.bold(text: 'Privacy Policy', fontSize: 12.0),
                  LNDText.regular(text: '.', fontSize: 12.0),
                ],
              ),
              LNDButton.primary(
                text: 'Agree and sign up',
                enabled: true,
                onPressed: controller.signUp,
              ),
            ],
          ).withSpacing(12.0),
        ),
      ),
    );
  }
}
