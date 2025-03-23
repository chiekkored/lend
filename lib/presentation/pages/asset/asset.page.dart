import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/shimmer.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/presentation/pages/asset/widgets/appbar.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/bottom_nav.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/inclusions.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/product_details.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/product_showcase.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/user_details.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class AssetPage extends GetView<AssetController> {
  static const routeName = '/asset';
  const AssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LNDColors.outline,
      body: Obx(
        () => CustomScrollView(
          slivers: [
            const AssetAppBar(),
            const AssetProductDetails(),
            if (controller.isAssetLoading) ...[
              const _LoadingWidget(),
            ] else ...[
              const AssetProductShowcase(),
              const AssetInclusions(),
              const AssetUserDetails(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const AssetBottomNav(),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 285.0,
            color: LNDColors.white,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: LNDShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const LNDShimmerBox(height: 20.0, width: 80.0),
                  SizedBox(
                    height: 125.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: List.generate(
                        5,
                        (_) => const Padding(
                          padding: EdgeInsets.only(right: 6.0, top: 16.0),
                          child: LNDShimmerBox(height: 125.0, width: 125.0),
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: LNDShimmerBox(height: 70.0, width: double.infinity),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 285.0,
            color: LNDColors.white,
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: LNDShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(backgroundColor: LNDColors.white),
                      LNDShimmerBox(height: 20.0, width: 80.0),
                    ],
                  ).withSpacing(8.0),
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: LNDShimmerBox(height: 180.0, width: double.infinity),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
