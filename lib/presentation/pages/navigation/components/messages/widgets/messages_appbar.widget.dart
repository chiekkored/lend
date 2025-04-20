import 'package:flutter/material.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class MessagesAppbar extends StatelessWidget {
  const MessagesAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: LNDColors.white,
      centerTitle: false,
      surfaceTintColor: LNDColors.white,
      title: LNDText.bold(text: 'Messages', fontSize: 32.0),
    );
  }
}
