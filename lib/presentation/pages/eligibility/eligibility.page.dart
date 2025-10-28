import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/signin/signin.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class EligibilityPage extends GetView<SigninController> {
  static const routeName = '/eligiblity';
  const EligibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:
            canPop
                ? AppBar(
                  leading: LNDButton.close(),
                  surfaceTintColor: LNDColors.white,
                  backgroundColor: LNDColors.white,
                )
                : null,
        backgroundColor: LNDColors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/listing.png', width: Get.width / 1.5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: LNDText.bold(
                  text: 'Verify your account ',
                  textAlign: TextAlign.center,
                  textParts: [
                    LNDText.regular(
                      text:
                          'to start listing and '
                          'renting out your assets securely.',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: LNDButton.primary(
                  text: 'Verify Account',
                  enabled: true,
                  hasPadding: false,
                  onPressed: () {},
                ),
              ),
            ],
          ).withSpacing(8.0),
        ),
      ),
    );
  }
}
