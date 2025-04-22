import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/chat/chat.controller.dart';
import 'package:lend/presentation/pages/chat/widgets/chat_list.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class ChatPage extends GetView<ChatController> {
  static const String routeName = '/chat';
  const ChatPage({super.key});

  // Private method to build the chat input box
  Widget _buildChatBox() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: LNDTextField.form(
              hintText: 'Type a message',
              controller: controller.textController,
              textInputAction: TextInputAction.send,
              onFieldSubmitted: (_) => controller.sendMessage(),
            ),
          ),
          LNDButton.primary(
            enabled: true,
            text: 'Send',
            onPressed: () => controller.sendMessage(),
            textColor: LNDColors.white,
          ),
        ],
      ).withSpacing(8.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: LNDColors.white,
        appBar: AppBar(
          leading: LNDButton.back(),
          automaticallyImplyLeading: false,
          backgroundColor: LNDColors.white,
          surfaceTintColor: LNDColors.white,
          title: LNDText.regular(
            text: LNDUtils.formatFullName(
              firstName: controller.recepientUser?.firstName,
              lastName: controller.recepientUser?.lastName,
            ),
            fontSize: 18.0,
            color: LNDColors.black,
          ),
          actionsPadding: const EdgeInsets.only(right: 24.0),
          actions: [
            LNDButton.icon(
              icon: Icons.info_outline_rounded,
              size: 25.0,
              onPressed: controller.goToAsset,
            ).withSpacing(8.0),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(55.0),
            child: GestureDetector(
              onTap: controller.goToAsset,
              child: ColoredBox(
                color: LNDColors.outline,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      LNDImage.square(
                        imageUrl: controller.chat.asset?.images?.first,
                        size: 40.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LNDText.medium(
                            text: controller.chat.asset?.title ?? '',
                          ),
                          LNDText.regular(
                            text: LNDUtils.getDateRange(
                              start:
                                  controller.chat.bookings?.first.date.toDate(),
                              end: controller.chat.bookings?.last.date.toDate(),
                            ),
                            fontSize: 12.0,
                            color: LNDColors.gray,
                          ),
                        ],
                      ),
                    ],
                  ).withSpacing(8.0),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: ChatListW(chat: controller.chat)),
              _buildChatBox(),
            ],
          ),
        ),
      ),
    );
  }
}
