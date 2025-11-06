import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/core/models/message.model.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/chat/chat_list.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/timestamp.extension.dart';

class ChatListW extends StatelessWidget {
  final Chat chat;
  const ChatListW({super.key, required this.chat});

  // Private method to build the date separator
  Widget? _buildDateSeparator(int index, List<Message> messages) {
    final message = messages[index];

    if (message.createdAt == null) return null;

    if (index < messages.length - 1) {
      final currentDate = DateTime(
        message.createdAt!.toDate().year,
        message.createdAt!.toDate().month,
        message.createdAt!.toDate().day,
      );

      final nextMessage = messages[index + 1];
      final nextDate = DateTime(
        nextMessage.createdAt!.toDate().year,
        nextMessage.createdAt!.toDate().month,
        nextMessage.createdAt!.toDate().day,
      );

      if (currentDate != nextDate) {
        return _createDateSeparator(message.createdAt!);
      }
    } else if (index == messages.length - 1) {
      // Always show date for the last message in the list (oldest message when reversed)
      return _createDateSeparator(message.createdAt!);
    }

    return null;
  }

  // Helper method to create the actual separator widget
  Widget _createDateSeparator(Timestamp timestamp) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: LNDColors.gray.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: LNDText.regular(
          text: timestamp.toFormattedString(),
          fontSize: 12.0,
          color: LNDColors.black.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(
      init: ChatListController(chat: chat),
      builder: (controller) {
        return ListView.builder(
          reverse: true,
          itemCount: controller.messages.length,
          itemBuilder: (_, index) {
            final message = controller.messages[index];
            final isCurrentUser =
                message.senderId == AuthController.instance.uid;

            // Check if we need to display a date separator
            Widget? dateSeparator = _buildDateSeparator(
              index,
              controller.messages,
            );

            return Column(
              children: [
                if (dateSeparator != null) dateSeparator,
                Align(
                  alignment:
                      isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    padding: const EdgeInsets.all(12.0),
                    constraints: BoxConstraints(maxWidth: Get.width * 0.75),
                    decoration: BoxDecoration(
                      color:
                          isCurrentUser
                              ? LNDColors.primary.withValues(alpha: 0.8)
                              : LNDColors.gray.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LNDText.regular(
                          isSelectable: true,
                          text: message.text ?? '',
                          color:
                              isCurrentUser ? LNDColors.white : LNDColors.black,
                        ),
                        LNDText.regular(
                          text: message.createdAt.toFormattedStringTimeOnly(),
                          fontSize: 10.0,
                          color:
                              isCurrentUser
                                  ? LNDColors.white.withValues(alpha: 0.8)
                                  : LNDColors.black.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
