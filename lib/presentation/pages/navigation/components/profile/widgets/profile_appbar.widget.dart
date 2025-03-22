import 'package:flutter/material.dart';
import 'package:lend/presentation/common/texts.common.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: false,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      title: LNDText.bold(text: 'Profile', fontSize: 32.0),
    );
  }
}
