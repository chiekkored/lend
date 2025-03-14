import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/home/home.controller.dart';
import 'package:lend/presentation/pages/navigation/components/home/widgets/home_appbar.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) {
          return [
            const HomeAppbarWidget(),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      controller.categories.length,
                      (index) {
                        final category = controller.categories[index];
                        final isSelected =
                            controller.selectedCategoryIndex == index;

                        return _buildCategoryWidget(
                            index, isSelected, category);
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      bottom: kBottomNavigationBarHeight + 24.0),
                  children: [
                    _buildPostWidget(),
                    _buildPostWidget(),
                    _buildPostWidget(),
                    _buildPostWidget(),
                    _buildPostWidget(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container _buildPostWidget() {
    return Container(
      height: 260.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      width: double.infinity,
      decoration: BoxDecoration(
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
              child: const Stack(
                children: [
                  Positioned.fill(child: FlutterLogo()),
                  Positioned(
                    top: 15.0,
                    right: 15.0,
                    child: FaIcon(
                      FontAwesomeIcons.solidHeart,
                      color: LNDColors.primary,
                    ),
                  ),
                ],
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
                      LNDText.regular(text: 'Sample Item'),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.solidStar,
                            size: 12.0,
                          ),
                          const SizedBox(width: 4.0),
                          LNDText.regular(text: '4.8'),
                        ],
                      ),
                    ],
                  ),
                  LNDText.bold(text: 'P1,000 / day'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryWidget(int index, bool isSelected, Categories category) {
    return GestureDetector(
      onTap: () => controller.setSelectedCategory(index),
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
                ? LNDText.semibold(
                    text: category.label,
                    color: LNDColors.white,
                  )
                : LNDText.regular(
                    text: category.label,
                    color: LNDColors.black,
                  ),
          ],
        ),
      ),
    );
  }
}
