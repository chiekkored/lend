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
          backgroundColor: LNDColors.white,
          surfaceTintColor: LNDColors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LNDText.bold(text: 'Create an account', fontSize: 32.0),
              Expanded(
                flex: 3,
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: controller.signUpKey,
                      autovalidateMode: AutovalidateMode.onUnfocus,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          LNDTextField.regular(
                            labelText: 'Email',
                            autofocus: true,
                            controller: controller.emailController,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: FontAwesomeIcons.solidEnvelope,
                            textInputAction: TextInputAction.done,
                            prefixIconColor: LNDColors.gray,
                            prefixIconSize: 16.0,
                            validator: controller.validateEmail,
                            onFieldSubmitted: (_) => controller.goToSetup(),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: LNDButton.primary(
                              text: 'Continue',
                              enabled: true,
                              onPressed: controller.goToSetup,
                            ),
                          ),
                        ],
                      ).withSpacing(16.0),
                    ),
                  ),
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
