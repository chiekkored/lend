import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/presentation/pages/asset/widgets/appbar.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/bottom_nav.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/inclusions.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/product_details.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/product_showcase.widget.dart';
import 'package:lend/presentation/pages/asset/widgets/user_details.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class AssetPage extends GetView<AssetController> {
  static const routeName = '/asset';
  const AssetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: LNDColors.outline,
      bottomNavigationBar: AssetBottomNav(),
      body: CustomScrollView(
        slivers: [
          AssetAppBar(),
          AssetProductDetails(),
          AssetProductShowcase(),
          AssetInclusions(),
          AssetUserDetails(),
        ],
      ),
    );
  }
}
