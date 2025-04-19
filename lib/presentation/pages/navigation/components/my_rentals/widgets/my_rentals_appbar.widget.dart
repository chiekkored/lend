import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/your_listing/you_listing.controller.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/eligibility.enum.dart';

class MyRentalsAppbar extends GetView<YourListingController> {
  const MyRentalsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: LNDColors.white,
      centerTitle: false,
      pinned: true,
      surfaceTintColor: LNDColors.white,
      title: LNDText.bold(text: 'My Rentals', fontSize: 32.0),
      actions: [
        Obx(
          () => Visibility(
            visible:
                controller.isAuthenticated &&
                ProfileController.instance.user?.isListingEligible ==
                    Eligibility.yes,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Badge(
                label: ClipOval(
                  child: LNDText.regular(
                    text: controller.myAssets.length.toString(),
                    fontSize: 12.0,
                    color: LNDColors.white,
                  ),
                ),
                child: LNDButton.icon(
                  icon: Icons.sell_rounded,
                  size: 25.0,
                  onPressed: () => controller.goToMyAssets(context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
