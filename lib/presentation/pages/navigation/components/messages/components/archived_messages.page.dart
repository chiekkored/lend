import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/listview.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/presentation/pages/navigation/components/messages/widgets/message_item.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class ArchivedMessagePage extends GetWidget<MessagesController> {
  static const routeName = '/archived-messages';
  const ArchivedMessagePage({super.key});

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
        title: LNDText.bold(text: 'Archived', fontSize: 18.0),
      ),
      body: Obx(
        () => LNDListView(
          items: controller.archivedChats,
          emptyString: 'No archives yet',
          itemBuilder: (chat, index) {
            // Get participant that is not the logged in user
            final participant = chat.participants?.firstWhereOrNull(
              (user) => user.uid != AuthController.instance.uid,
            );

            return MessageItemW(chat: chat, participant: participant);
          },
        ),
      ),
    );
  }
}
