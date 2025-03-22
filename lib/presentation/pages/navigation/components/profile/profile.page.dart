import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/presentation/pages/navigation/components/profile/widgets/profile_appbar.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: LNDColors.white,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) {
          return [const ProfileAppbar()];
        },
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(12.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: LNDColors.white,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: LNDColors.outline),
              ),
              child:
                  !controller.isAuthenticated
                      ? _SigninView()
                      : ListTile(
                        leading: const CircleAvatar(radius: 24.0),
                        title: LNDText.regular(text: 'Chiekko Red Alino'),
                        subtitle: LNDText.regular(
                          text: 'View Profile',
                          color: LNDColors.gray,
                          fontSize: 12.0,
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: LNDColors.gray,
                          size: 30.0,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SigninView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LNDText.bold(text: 'Sign in to access your profile', fontSize: 24.0),
          LNDText.regular(
            text: 'Manage your information, preferences, and rental listings.',
            textAlign: TextAlign.center,
            color: LNDColors.hint,
          ),
          LNDButton.primary(
            text: 'Sign in',
            enabled: true,
            onPressed: controller.checkAuth,
          ),
        ],
      ).withSpacing(8.0),
    );
  }
}
