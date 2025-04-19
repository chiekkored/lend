import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/presentation/pages/navigation/components/messages/widgets/messages_appbar.widget.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LNDColors.white,
      body: SafeArea(
        child: Obx(
          () => NestedScrollView(
            physics:
                !controller.isAuthenticated
                    ? const NeverScrollableScrollPhysics()
                    : null,
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, __) {
              return [const MessagesAppbar()];
            },
            body: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (!controller.isAuthenticated) {
      return _SigninView();
    }

    if (controller.isChatsLoading) {
      return const Center(child: LNDSpinner());
    }

    if (controller.chats.isEmpty) {
      return Center(
        child: LNDText.regular(
          text: 'No messages yet',
          fontSize: 16.0,
          color: LNDColors.hint,
        ),
      );
    }

    return ListView.builder(
      itemCount: controller.chats.length,
      itemBuilder: (context, index) {
        final chat = controller.chats[index];
        // Get participant that is not the logged in user
        final participant = chat.participants?.firstWhereOrNull(
          (user) => user.uid != AuthController.instance.uid,
        );
        return ListTile(
          leading: SizedBox(
            height: 50.0,
            width: 50.0,
            child: Stack(
              children: [
                LNDImage.square(imageUrl: chat.asset?.images?.first),
                if (participant != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 25.0,
                      height: 25.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: LNDColors.white, width: 2.0),
                      ),
                      child: LNDImage.circle(
                        imageUrl: participant.photoUrl,
                        size: 20.0,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          title:
              (chat.hasRead ?? false)
                  ? LNDText.regular(
                    text: LNDUtils.formatFullName(
                      firstName: participant?.firstName,
                      lastName: participant?.lastName,
                    ),
                  )
                  : LNDText.bold(
                    text: LNDUtils.formatFullName(
                      firstName: participant?.firstName,
                      lastName: participant?.lastName,
                    ),
                  ),
          subtitle: LNDText.regular(
            text: chat.lastMessage ?? '',
            fontSize: 12.0,
          ),
        );
      },
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
              onPressed:
                  controller.isAuthenticated
                      ? null
                      : () => Get.toNamed(SigninPage.routeName),
            ),
          ],
        ).withSpacing(24.0),
      ),
    );
  }
}
