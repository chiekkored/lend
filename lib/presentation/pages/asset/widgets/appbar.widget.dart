import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class AssetAppBar extends GetWidget<AssetController> {
  const AssetAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leadingWidth: 52.0,
      backgroundColor: LNDColors.white,
      leading: Container(
        height: 40.0,
        width: 40.0,
        margin: const EdgeInsets.only(left: 12.0),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: LNDColors.white,
        ),
        child: Center(child: LNDButton.back()),
      ),
      actions: [
        Visibility(
          visible: AuthController.instance.uid == controller.asset?.ownerId,
          child: Container(
            height: 40.0,
            width: 40.0,
            margin: const EdgeInsets.only(right: 12.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: LNDColors.primary,
            ),
            child: Center(
              child: LNDButton.icon(
                icon: Icons.calendar_today_rounded,
                color: LNDColors.white,
                size: 25.0,
                onPressed: controller.goToViewCalendar,
              ),
            ),
          ),
        ),
      ],
      expandedHeight: 300.0,
      surfaceTintColor: LNDColors.white,
      stretch: true,
      pinned: true,
      shadowColor: LNDColors.black,
      flexibleSpace: LayoutBuilder(
        builder: (_, constraints) {
          // This is for displaying widgets when appbar is collapsed

          // final top = constraints.biggest.height;

          return FlexibleSpaceBar(
            // title: Opacity(
            //   opacity: top == Get.mediaQuery.padding.top + kToolbarHeight
            //       ? 1.0
            //       : 0.0,
            //   child: LNDText.bold(
            //     text: controller.asset?.title ?? '',
            //     fontSize: 24.0,
            //   ),
            // ),
            centerTitle: false,
            background: Stack(
              children: [
                FlutterCarousel(
                  items:
                      controller.asset?.images
                          ?.asMap()
                          .entries
                          .map(
                            (entry) => GestureDetector(
                              onTap: () => controller.openPhotoAsset(entry.key),
                              child: LNDImage.custom(
                                imageUrl: entry.value,
                                height: double.infinity,
                                width: double.infinity,
                                borderRadius: 0.0,
                              ),
                            ),
                          )
                          .toList() ??
                      [],
                  options: FlutterCarouselOptions(
                    height: double.infinity,
                    viewportFraction: 1.0,
                    enableInfiniteScroll:
                        (controller.asset?.images?.length ?? 0) > 1,
                    autoPlay: (controller.asset?.images?.length ?? 0) > 1,
                    autoPlayInterval: const Duration(seconds: 4),
                    indicatorMargin: 12.0,
                  ),
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 100.0,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [LNDColors.white, Colors.transparent],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            stretchModes: const [
              StretchMode.fadeTitle,
              StretchMode.zoomBackground,
            ],
          );
        },
      ),
    );
  }
}
