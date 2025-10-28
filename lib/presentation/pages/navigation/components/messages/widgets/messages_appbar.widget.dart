import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class MessagesAppbar extends GetWidget<MessagesController> {
  const MessagesAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: LNDColors.white,
      centerTitle: false,
      surfaceTintColor: LNDColors.white,
      title: LNDText.bold(text: 'Messages', fontSize: 32.0),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: LNDButton.widget(
            color: Colors.transparent,
            onPressed: controller.goToArchivedMessagesPage,
            child: const Icon(
              Icons.inventory_2_rounded,
              size: 25.0,
              color: LNDColors.black,
            ),
          ),
        ),
      ],
    );
  }
}
