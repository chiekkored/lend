import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/shimmer.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/int.extension.dart';

class AssetBottomNav extends GetWidget<AssetController> {
  const AssetBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.0,
      decoration: const BoxDecoration(
        color: LNDColors.white,
        border: Border(top: BorderSide(color: LNDColors.hint, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () =>
                    controller.isAssetLoading
                        ? const LNDShimmer(
                          child: LNDShimmerBox(height: 25.0, width: 100.0),
                        )
                        : LNDText.bold(
                          text:
                              '₱${controller.asset?.rates?.daily.toMoney() ?? ''}',
                          fontSize: 18.0,
                          textParts: [
                            LNDText.regular(
                              text: ' daily',
                              color: LNDColors.hint,
                              fontSize: 16.0,
                            ),
                          ],
                        ),
              ),
              if (AuthController.instance.uid != controller.asset?.ownerId)
                Obx(
                  () => LNDButton.primary(
                    text: 'Reserve now',
                    enabled: !controller.isAssetLoading,
                    onPressed: controller.goToReservation,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
