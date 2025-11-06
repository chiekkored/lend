import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/home/home.controller.dart';
import 'package:lend/presentation/pages/navigation/components/home/widgets/home_appbar.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/categories.enum.dart';
import 'package:lend/utilities/extensions/int.extension.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: controller.scrollController,
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) {
          return [const HomeAppbarWidget()];
        },
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ColoredBox(
              color: LNDColors.white,
              child: Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children:
                        Categories.values.map((category) {
                          final isSelected =
                              controller.selectedCategory == category;
                          return _buildCategoryWidget(isSelected, category);
                        }).toList(),
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: () => controller.getAssets(),
                child: Obx(
                  () =>
                      controller.isLoading
                          ? const Center(
                            child: LNDSpinner(color: LNDColors.black),
                          )
                          : ListView.builder(
                            itemCount: controller.assets.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 12.0),
                            itemBuilder:
                                (context, index) =>
                                    _buildPostWidget(controller.assets[index]),
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostWidget(Asset asset) {
    return GestureDetector(
      key: Key(asset.id),
      onTap: () => controller.openAssetPage(asset),
      child: Container(
        height: 340.0,
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: LNDColors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(color: LNDColors.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: LNDColors.outline,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  child: LNDImage.custom(
                    height: double.infinity,
                    width: double.infinity,
                    imageUrl: asset.images?.first,
                    borderRadius: 0.0,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        LNDText.regular(
                          text: asset.title ?? '',
                          isSelectable: true,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.solidStar,
                              color: LNDColors.primary,
                              size: 12.0,
                            ),
                            const SizedBox(width: 4.0),
                            LNDText.regular(text: '4.8'),
                          ],
                        ),
                      ],
                    ),
                    LNDText.regular(
                      text: asset.category ?? '',
                      color: LNDColors.hint,
                    ),
                    LNDText.bold(
                      text: '₱${asset.rates?.daily.toMoney()} / day',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryWidget(bool isSelected, Categories category) {
    return GestureDetector(
      onTap: () => controller.setSelectedCategory(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSelected ? LNDColors.primary : LNDColors.outline,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            FaIcon(
              category.icon,
              size: 20.0,
              color: isSelected ? LNDColors.white : LNDColors.black,
            ),
            const SizedBox(width: 8.0),
            isSelected
                ? LNDText.semibold(text: category.label, color: LNDColors.white)
                : LNDText.regular(text: category.label, color: LNDColors.black),
          ],
        ),
      ),
    );
  }
}
