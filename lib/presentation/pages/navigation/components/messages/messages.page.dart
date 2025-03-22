import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/presentation/pages/navigation/components/messages/widgets/messages_appbar.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LNDColors.white,
      body: SafeArea(
        child: NestedScrollView(
          physics:
              !controller.isAuthenticated
                  ? const NeverScrollableScrollPhysics()
                  : null,
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) {
            return [const MessagesAppbar()];
          },
          body:
              !controller.isAuthenticated
                  ? _SigninView()
                  : const Center(child: Text('Logged in!')),
        ),
      ),
    );
  }
}

class _SigninView extends GetView<MessagesController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LNDText.bold(text: 'Sign in to view your messages', fontSize: 24.0),
            LNDText.regular(
              text:
                  'Stay connected with renters and respond to inquiries easily.',
              textAlign: TextAlign.center,
              color: LNDColors.hint,
            ),
            LNDButton.primary(
              text: 'Sign in',
              enabled: true,
              onPressed: controller.checkAuth,
            ),
          ],
        ).withSpacing(24.0),
      ),
    );
  }
}
