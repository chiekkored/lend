import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/chat/chat.controller.dart';
import 'package:lend/presentation/pages/chat/widgets/chat_list.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';
import 'package:lend/utilities/extensions/bookingStatus.extension.dart';
import 'package:lend/utilities/extensions/int.extension.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class ChatPage extends GetView<ChatController> {
  static const String routeName = '/chat';
  const ChatPage({super.key});

  // Private method to build the chat input box
  Widget _buildChatBox() {
    final isCurrentDay = LNDUtils.isTodayInTimestamps(
      controller.booking?.dates ?? [],
    );
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        spacing: 4.0,
        children: [
          if (isCurrentDay)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: LNDColors.outline)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 12.0,
                children: [
                  Expanded(
                    child: LNDButton.secondary(
                      enabled: true,
                      icon: Icons.camera_alt_rounded,
                      iconSize: 15.0,
                      hasPadding: false,
                      text: 'Handed over?',
                      borderRadius: 16.0,
                      onPressed: controller.goToScanQR,
                    ),
                  ),
                  Expanded(
                    child: LNDButton.secondary(
                      enabled: true,
                      icon: Icons.qr_code_scanner_rounded,
                      iconSize: 15.0,
                      hasPadding: false,
                      text: 'Returned?',
                      borderRadius: 16.0,
                      onPressed: controller.goToQRView,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
                ),
              ],
            ).withSpacing(8.0),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAppbar(Chat chat) {
    final isOwner = chat.asset?.owner?.uid == AuthController.instance.uid;

    return SizedBox(
      child: Obx(() {
        if (controller.booking != null) {
          final booking = controller.booking;

          return GestureDetector(
            onTap: controller.goToAsset,
            child: Container(
              color: LNDColors.outline,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    spacing: 4.0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 4.0,
                        children: [
                          CircleAvatar(
                            radius: 6.0,
                            backgroundColor: booking?.status?.color,
                          ),
                          LNDText.regular(
                            text: booking?.status?.label.capitalizeFirst ?? '',
                            fontSize: 12.0,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          LNDImage.square(
                            imageUrl: chat.asset?.images?.first,
                            size: 40.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LNDText.medium(text: chat.asset?.title ?? ''),
                              LNDText.regular(
                                text: LNDUtils.getDateRange(
                                  start: booking?.dates?.first.toDate(),
                                  end: booking?.dates?.last.toDate(),
                                ),
                                fontSize: 12.0,
                                color: LNDColors.gray,
                                textParts: [
                                  LNDText.regular(
                                    text: ' • ',
                                    color: LNDColors.gray,
                                    fontSize: 12.0,
                                  ),
                                  LNDText.bold(
                                    text:
                                        '₱${controller.booking?.totalPrice.toMoney()}',
                                    fontSize: 12.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ).withSpacing(8.0),
                    ],
                  ),
                  const Spacer(),
                  Visibility(
                    visible:
                        isOwner && booking?.status == BookingStatus.pending,
                    child: LNDButton.primary(
                      text: 'Accept',
                      enabled: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 8.0,
                      ),
                      onPressed: controller.onTapAccept,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chat = controller.chat;

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
            Obx(() {
              if (controller.booking == null) return const SizedBox.shrink();

              final isOwner =
                  chat.asset?.owner?.uid == AuthController.instance.uid;
              final isConfirmed =
                  controller.booking?.status == BookingStatus.confirmed ||
                  isOwner;
              return Tooltip(
                message:
                    'Owner\'s complete information is available only for confirmed bookings.',
                textStyle: LNDText.regularStyle.copyWith(
                  color: LNDColors.white,
                  overflow: TextOverflow.clip,
                ),
                margin: const EdgeInsets.only(left: 24.0, right: 8.0),
                triggerMode:
                    isConfirmed
                        ? TooltipTriggerMode.manual
                        : TooltipTriggerMode.tap,
                child: LNDButton.icon(
                  icon: Icons.info_outline_rounded,
                  size: 25.0,
                  color: isConfirmed ? LNDColors.black : LNDColors.outline,
                  onPressed: isConfirmed ? controller.viewBookingInfo : null,
                ).withSpacing(8.0),
              );
            }),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight + 20),
            child: _buildBottomAppbar(chat),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: ChatListW(chat: chat)),
              Obx(() => _buildChatBox()),
            ],
          ),
        ),
      ),
    );
  }
}
