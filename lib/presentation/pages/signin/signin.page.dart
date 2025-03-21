import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/signin/signin.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class SigninPage extends GetView<SigninController> {
  static const routeName = '/signin';
  const SigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: canPop
            ? AppBar(
                leading: LNDButton.close(),
              )
            : null,
        backgroundColor: LNDColors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const FlutterLogo(
                  size: 150.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      LNDText.bold(
                        text: 'Welcome to Lend!',
                        fontSize: 32.0,
                      ),
                      LNDText.regular(
                        text: 'Find and rent what you need, when you need it.',
                        color: LNDColors.hint,
                      )
                    ],
                  ),
                ),
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
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.none,
                    suffixIcon: controller.showObscureText
                        ? FontAwesomeIcons.solidEye
                        : FontAwesomeIcons.solidEyeSlash,
                    suffixIconSize: 16.0,
                    onTapSuffix: controller.togglePasswordVisibility,
                    onFieldSubmitted: (_) => controller.signIn(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: LNDButton.primary(
                      text: 'Sign in', enabled: true, onPressed: () {}),
                ),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(),
                    ),
                    LNDText.regular(
                      text: 'OR',
                      color: LNDColors.gray,
                    ),
                    const Expanded(
                      child: Divider(),
                    ),
                  ],
                ).withSpacing(8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LNDButton.widget(
                      color: const Color(0xFF4285F4),
                      onPressed: () {},
                      child: const FaIcon(
                        FontAwesomeIcons.google,
                      ),
                    ),
                    LNDButton.widget(
                      color: Colors.black,
                      onPressed: () {},
                      child: const FaIcon(
                        FontAwesomeIcons.apple,
                      ),
                    ),
                    LNDButton.widget(
                      color: const Color(0xFF316FF6),
                      onPressed: () {},
                      child: const FaIcon(
                        FontAwesomeIcons.facebookF,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: GestureDetector(
                    onTap: controller.goToSignUp,
                    child: LNDText.regular(
                      text: 'Don\'t have an account?',
                      color: LNDColors.hint,
                      textParts: [
                        LNDText.bold(
                          text: ' Sign up',
                          color: LNDColors.primary,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ).withSpacing(16.0),
          ),
        ),
      ),
    );
  }
}
