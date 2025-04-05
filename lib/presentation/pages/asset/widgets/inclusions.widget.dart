import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class AssetInclusions extends GetWidget<AssetController> {
  const AssetInclusions({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Visibility(
        visible: controller.asset?.inclusions?.isNotEmpty ?? false,
        child: Container(
          margin: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: LNDColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LNDText.semibold(text: 'What\'s Included', fontSize: 18.0),
                  ],
                ),
                ...controller.asset?.inclusions?.map(
                      (inclusion) => Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: LNDColors.success,
                          ),
                          LNDText.regular(text: inclusion, isSelectable: true),
                        ],
                      ).withSpacing(8.0),
                    ) ??
                    [],
              ],
            ).withSpacing(8.0),
          ),
        ),
      ),
    );
  }
}
