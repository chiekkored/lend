import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class AssetProductShowcase extends GetWidget<AssetController> {
  const AssetProductShowcase({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final showcase = controller.asset?.showcase;
    final description = controller.asset?.description;
    return SliverToBoxAdapter(
      child: Visibility(
        visible: (showcase?.isNotEmpty ?? false) &&
            (description?.isNotEmpty ?? false),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          color: LNDColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showcase?.isNotEmpty ?? false) ...[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      LNDText.medium(
                        text: 'Product Showcase',
                        color: LNDColors.hint,
                      ),
                      Visibility(
                        visible: (showcase?.length ?? 0) > 5,
                        child: LNDButton.text(
                          text: 'See More',
                          onPressed: () {},
                          enabled: true,
                          color: LNDColors.black,
                          size: 12.0,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 125.0,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: showcase != null
                        ? (showcase.length > 5 ? 5 : showcase.length)
                        : 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 6.0,
                    ),
                    itemBuilder: (_, index) {
                      final showcase = controller.asset?.showcase?[index];
                      return LNDImage.square(
                        imageUrl: showcase,
                        size: 125.0,
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Divider(),
                ),
              ],
              Visibility(
                visible: description?.isNotEmpty ?? false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: LNDColors.primary,
                          ),
                        ),
                        Expanded(
                          child: LNDText.regular(
                            text: description ?? '',
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ],
                    ).withSpacing(16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
