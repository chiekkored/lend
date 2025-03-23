import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/shimmer.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  GestureDetector(
                    onTap: controller.openAllPrices,
                    child: LNDText.regular(
                      text: 'View all prices',
                      fontSize: 12.0,
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              LNDButton.primary(
                text: 'Reserve now',
                enabled: true,
                onPressed: controller.goToReservation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
