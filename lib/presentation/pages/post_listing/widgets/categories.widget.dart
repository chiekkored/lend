import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/categories.enum.dart';

class CategoriesW extends StatelessWidget {
  final Categories? category;

  final Rx<Categories> selectedCategory = Categories.all.obs;

  CategoriesW({super.key, required this.category}) {
    if (category != null) {
      selectedCategory.value = category!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LNDColors.white,
      appBar: AppBar(
        leading: LNDButton.close(),
        backgroundColor: LNDColors.white,
        surfaceTintColor: LNDColors.white,
        title: LNDText.bold(text: 'Select Category', fontSize: 18.0),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  // Iterate except all category
                  for (var category in Categories.values)
                    if (category != Categories.all)
                      GestureDetector(
                        onTap: () {
                          selectedCategory.value = category;
                        },
                        child: _buildCategoryCard(
                          icon: category.icon,
                          name: category.label,
                        ),
                      ),
                ],
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24.0,
                  top: 8.0,
                ),
                child: LNDButton.primary(
                  text: 'Apply',
                  enabled: true,
                  onPressed: () {
                    Get.back(result: selectedCategory.value);
                  },
                  hasPadding: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Category card widget
  Widget _buildCategoryCard({required IconData icon, required String name}) {
    return Obx(() {
      final isSelected = selectedCategory.value.label == name;

      return Container(
        decoration: BoxDecoration(
          // color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? LNDColors.primary : LNDColors.white,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: LNDColors.black),
            const SizedBox(height: 8),
            LNDText.regular(text: name, fontSize: 14.0),
          ],
        ),
      );
    });
  }
}
