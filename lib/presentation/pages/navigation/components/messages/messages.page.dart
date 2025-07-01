import 'package:flutter/cupertino.dart';
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
import 'package:lend/presentation/pages/chat/widgets/chat_list.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/timestamp.extension.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

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

    if (controller.chats.isEmpty) {
      return Center(
        child: LNDText.regular(text: 'No messages yet', color: LNDColors.hint),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.chats.length,
      itemBuilder: (context, index) {
        final chat = controller.chats[index];
        // Get participant that is not the logged in user
        final participant = chat.participants?.firstWhereOrNull(
          (user) => user.uid != AuthController.instance.uid,
        );

        return CupertinoContextMenu.builder(
          actions: <Widget>[
            CupertinoContextMenuAction(
              onPressed: () {
                Get.back();
              },
              isDestructiveAction: true,
              trailingIcon: Icons.delete,
              child: LNDText.regular(text: 'Delete', color: LNDColors.danger),
            ),
          ],
          builder: (_, animation) {
            // Use animation to determine which widget to show
            if (animation.value > 0.8) {
              // When context menu is more than half opened, show the ChatListW
              return Material(
                borderRadius: BorderRadius.circular(16),
                child: AbsorbPointer(
                  absorbing: true,
                  child: Container(
                    height: Get.height * 0.5,
                    width: Get.width * 0.9,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ChatListW(chat: chat),
                  ),
                ),
              );
            } else {
              // Otherwise show the regular ListTile
              return Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                width: Get.width,
                height: 50.0,
                child: CupertinoListTile(
                  onTap: () => controller.goToChatPage(chat),
                  leadingSize: 50.0,
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
                                border: Border.all(
                                  color: LNDColors.white,
                                  width: 2.0,
                                ),
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
                  title: Expanded(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child:
                          (chat.hasRead ?? false)
                              ? LNDText.medium(
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
                    ),
                  ),
                  subtitle: Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child:
                          (chat.hasRead ?? false)
                              ? LNDText.regular(
                                text: '',
                                textParts: [
                                  if (chat.lastMessageSenderId ==
                                      AuthController.instance.uid)
                                    LNDText.regular(
                                      text: 'You: ',
                                      color: LNDColors.hint,
                                    ),
                                  LNDText.regular(
                                    text: chat.lastMessage ?? '',
                                    color: LNDColors.disabled,
                                  ),
                                ],
                              )
                              : LNDText.bold(
                                text: '',
                                textParts: [
                                  if (chat.lastMessageSenderId ==
                                      AuthController.instance.uid)
                                    LNDText.regular(
                                      text: 'You: ',
                                      color: LNDColors.hint,
                                    ),
                                  LNDText.semibold(
                                    text: chat.lastMessage ?? '',
                                  ),
                                ],
                              ),
                    ),
                  ),
                  additionalInfo: LNDText.regular(
                    text:
                        chat.lastMessageDate?.toFormattedStringTimeOnly() ?? '',
                    fontSize: 12.0,
                    color: LNDColors.hint,
                  ),
                ),
              );
            }
          },
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
