import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/pages/post_listing/widgets/edit_rates.widget.dart';
import 'package:lend/utilities/extensions/string.extension.dart';

class PostListingController extends GetxController {
  static final PostListingController instance =
      Get.find<PostListingController>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final dailyPriceController = TextEditingController();
  final weeklyPriceController = TextEditingController();
  final monthlyPriceController = TextEditingController();
  final annualPriceController = TextEditingController();
  final locationController = TextEditingController();

  final RxString weeklyPrice = ''.obs;
  final RxString monthlyPrice = ''.obs;
  final RxString annualPrice = ''.obs;

  final RxBool isCustomLocation = true.obs;
  final RxBool isCustomPrice = true.obs;

  @override
  void onInit() {
    // Listen to daily price change and multiply by each prices
    dailyPriceController.addListener(_calculatePrices);
    weeklyPriceController.addListener(_weeklyPriceListener);
    monthlyPriceController.addListener(_monthlyPriceListener);
    annualPriceController.addListener(_annualPriceListener);

    ever(isCustomPrice, (_) => _calculatePrices());

    super.onInit();
  }

  @override
  void onClose() {
    isCustomPrice.close();
    isCustomLocation.close();
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    dailyPriceController.dispose();
    weeklyPriceController.dispose();
    monthlyPriceController.dispose();
    annualPriceController.dispose();
    locationController.dispose();

    weeklyPrice.close();
    monthlyPrice.close();
    annualPrice.close();
    // Loop remove listeners
    for (var controller in [
      dailyPriceController,
      weeklyPriceController,
      monthlyPriceController,
      annualPriceController,
    ]) {
      controller.removeListener(_calculatePrices);
    }

    super.onClose();
  }

  void _monthlyPriceListener() {
    monthlyPrice.value = monthlyPriceController.text;
  }

  void _weeklyPriceListener() {
    weeklyPrice.value = weeklyPriceController.text;
  }

  void _annualPriceListener() {
    annualPrice.value = annualPriceController.text;
  }

  void _calculatePrices() {
    if (isCustomPrice.isTrue) {
      final dailyPrice =
          double.tryParse(dailyPriceController.text.replaceAll(',', '')) ?? 0;
      final decimalCount = dailyPriceController.text.contains('.') ? 2 : 0;

      calculatePrice(int multiplier) =>
          dailyPrice == 0
              ? ''
              : (dailyPrice * multiplier)
                  .toStringAsFixed(decimalCount)
                  .toMoney();

      weeklyPriceController.text = calculatePrice(7);
      monthlyPriceController.text = calculatePrice(30);
      annualPriceController.text = calculatePrice(365);
    }
  }

  // void toggleCustomLocation() => isCustomLocation.toggle();

  void showEditPrices() {
    LNDShow.bottomSheet(const EditRates());
  }

  void next() {
    debugPrint('dailyPriceController: ${dailyPriceController.text}');
    debugPrint('weeklyPriceController: ${weeklyPriceController.text}');
    debugPrint('monthlyPriceController: ${monthlyPriceController.text}');
    debugPrint('annualPriceController: ${annualPriceController.text}');
  }
}
