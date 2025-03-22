import 'package:flutter/material.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class MyRentalsAppbar extends StatelessWidget {
  const MyRentalsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: LNDColors.white,
      centerTitle: false,
      pinned: true,
      surfaceTintColor: LNDColors.white,
      title: LNDText.bold(text: 'My Rentals', fontSize: 32.0),
    );
  }
}
