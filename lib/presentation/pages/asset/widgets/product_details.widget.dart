import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/shimmer.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class AssetProductDetails extends GetWidget<AssetController> {
  const AssetProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        margin: const EdgeInsets.only(bottom: 4.0),
        color: LNDColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LNDText.bold(
                        text: controller.asset?.title ?? '',
                        fontSize: 24.0,
                        overflow: TextOverflow.visible,
                        isSelectable: true,
                      ),
                    ),
                    LNDButton.icon(
                      icon: Icons.bookmark_add_outlined,
                      size: 30.0,
                      color: LNDColors.hint,
                      onPressed: controller.addBookmark,
                    ),
                    // const Icon(
                    //   Icons.bookmark_added_rounded,
                    //   size: 30.0,
                    //   color: LNDColors.primary,
                    // )
                  ],
                ),
                LNDText.regular(
                  text: controller.asset?.category ?? '',
                  color: LNDColors.hint,
                ),
              ],
            ),
            Obx(
              () => Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: LNDColors.primary,
                    size: 20.0,
                  ),
                  if (controller.isAssetLoading)
                    const LNDShimmer(
                      child: LNDShimmerBox(height: 20.0, width: 100.0),
                    )
                  else ...[
                    LNDText.bold(text: '4.8', color: LNDColors.primary),
                    LNDText.regular(
                      text: '(400 reviews)',
                      color: LNDColors.hint,
                    ),
                  ],
                ],
              ).withSpacing(6.0),
            ),
          ],
        ).withSpacing(16.0),
      ),
    );
  }
}
