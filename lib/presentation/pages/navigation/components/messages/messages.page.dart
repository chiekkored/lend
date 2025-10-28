import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/listview.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/presentation/pages/navigation/components/messages/widgets/message_item.widget.dart';
import 'package:lend/presentation/pages/navigation/components/messages/widgets/messages_appbar.widget.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class MessagesPage extends GetView<MessagesController> {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => NestedScrollView(
          controller: controller.scrollController,
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
    );
  }

  Widget _buildBody() {
    if (!controller.isAuthenticated) {
      return _SigninView();
    }

    if (controller.isChatsLoading) {
      return const Center(child: LNDSpinner());
    }

    return LNDListView(
      items: controller.activeChats,
      emptyString: 'No messages yet',

      onRefresh: () async {
        controller.listenToChats();
        return;
      },
      itemBuilder: (chat, index) {
        // Get participant that is not the logged in user
        final participant = chat.participants?.firstWhereOrNull(
          (user) => user.uid != AuthController.instance.uid,
        );

        return MessageItemW(chat: chat, participant: participant);
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
