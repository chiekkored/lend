import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class AssetPage extends GetView<AssetController> {
  static const routeName = '/asset';
  const AssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LNDColors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
                child: Center(
                  child: LNDButton.back(
                    size: 40.0,
                  ),
                )),
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
                  background: FlutterCarousel(
                    items: controller.asset?.images
                            ?.map(
                              (image) => LNDImage.custom(
                                imageUrl: image,
                                height: double.infinity,
                                width: double.infinity,
                                borderRadius: 0.0,
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
                  stretchModes: const [
                    StretchMode.fadeTitle,
                    StretchMode.zoomBackground,
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LNDText.bold(
                    text: controller.asset?.title ?? '',
                    fontSize: 24.0,
                  ),
                  LNDText.regular(
                    text: controller.asset?.category ?? '',
                    color: LNDColors.hint,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.solidStar,
                    color: LNDColors.primary,
                    size: 20.0,
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  LNDText.bold(
                    text: '4.8',
                    color: LNDColors.primary,
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  LNDText.regular(
                    text: '(400 reviews)',
                    color: LNDColors.hint,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              margin: const EdgeInsets.symmetric(vertical: 16.0),
              decoration: const BoxDecoration(
                color: LNDColors.outline,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, bottom: 16.0),
                    child: LNDText.medium(
                      text: 'Product Showcase',
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    height: 125.0,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.asset?.showcase?.length ?? 0,
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
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Obx(
                () => controller.isUserLoading
                    ? const LNDSpinner(
                        color: LNDColors.black,
                      )
                    : Row(
                        children: [
                          LNDImage.circle(
                            imageUrl: controller.user?.photoUrl,
                            size: 40.0,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          LNDText.bold(text: controller.user?.name ?? ''),
                          const SizedBox(
                            width: 2.0,
                          ),
                          const Icon(
                            Icons.verified_rounded,
                            size: 15.0,
                            color: LNDColors.primary,
                          )
                        ],
                      ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.locationDot,
                        color: LNDColors.hint,
                        size: 20.0,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      LNDText.regular(text: 'Location here')
                    ],
                  ),
                  LNDButton.icon(
                    icon: FontAwesomeIcons.angleRight,
                    onPressed: () {},
                    size: 20.0,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildDivider() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Divider(),
      ),
    );
  }
}
