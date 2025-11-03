import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/profile_view/profile_view.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class ProfileViewPage extends GetView<ProfileViewController> {
  static const routeName = '/profile-view';
  const ProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Scaffold(
      backgroundColor: LNDColors.white,
      appBar: AppBar(
        surfaceTintColor: LNDColors.white,
        backgroundColor: LNDColors.white,
        leading: LNDButton.back(
          onPressed: canPop ? () => Navigator.of(context).pop() : null,
        ),
        actions: [
          if (AuthController.instance.uid == controller.args.user.uid)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: LNDButton.text(
                text: 'EDIT',
                onPressed: () {},
                enabled: true,
                isBold: true,
                color: LNDColors.primary,
              ),
            ),
        ],
      ),
      body: Column(
        children: [Obx(() => Text(controller.user?.firstName ?? ''))],
      ),
    );
  }
}
