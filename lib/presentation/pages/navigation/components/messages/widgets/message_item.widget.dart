import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/simple_user.model.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/presentation/pages/chat/widgets/chat_list.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/image_type.enum.dart';
import 'package:lend/utilities/extensions/timestamp.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class MessageItemW extends StatelessWidget {
  const MessageItemW({
    super.key,
    required this.chat,
    required this.participant,
  });

  final Chat chat;
  final SimpleUserModel? participant;

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu.builder(
      enableHapticFeedback: true,
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
            child: GestureDetector(
              onTap: () {
                Get.back();
                MessagesController.instance.goToChatPage(chat);
              },
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
            ),
          );
        } else {
          // Otherwise show the regular ListTile
          return Container(
            margin: const EdgeInsets.only(bottom: 8.0),
            width: Get.width,
            height: 50.0,
            child: CupertinoListTile(
              onTap: () => MessagesController.instance.goToChatPage(chat),
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
                            imageUrl: participant!.photoUrl,
                            size: 20.0,
                            imageType: ImageType.user,
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
                              LNDText.semibold(text: chat.lastMessage ?? ''),
                            ],
                          ),
                ),
              ),
              additionalInfo: LNDText.regular(
                text: chat.lastMessageDate?.toTimeAgo() ?? '',
                fontSize: 12.0,
                color: LNDColors.hint,
              ),
            ),
          );
        }
      },
    );
  }
}
