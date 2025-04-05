import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:lend/core/mixins/textfields.mixin.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/pages/post_listing/widgets/add_inclusions.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/availability.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/edit_rates.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/location_picker.widget.dart';
import 'package:lend/utilities/enums/availability.enum.dart';
import 'package:lend/utilities/extensions/string.extension.dart';

class PostListingController extends GetxController with TextFieldsMixin {
  static final PostListingController instance =
      Get.find<PostListingController>();

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final dailyPriceController = TextEditingController();
  final weeklyPriceController = TextEditingController();
  final monthlyPriceController = TextEditingController();
  final annualPriceController = TextEditingController();
  final locationController = TextEditingController();
  final inclusionController = TextEditingController();

  final RxString weeklyPrice = ''.obs;
  final RxString monthlyPrice = ''.obs;
  final RxString annualPrice = ''.obs;

  final RxBool isCustomLocation = true.obs;
  final RxBool isCustomPrice = true.obs;

  final RxList<String> inclusions = <String>[].obs;
  final Rx<Availability> availability = Availability.available.obs;

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
    availability.close();
    isCustomPrice.close();
    isCustomLocation.close();
    inclusions.close();
    inclusionController.dispose();
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

  void showEditPrices() {
    LNDShow.bottomSheet(const EditRates());
  }

  void showAddInclusions(BuildContext context) {
    inclusionController.clear();

    CupertinoScaffold.showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (_) => const AddInclusions(),
    );
  }

  void showLocationPicker(BuildContext context) {
    LNDShow.modalSheet(
      context,
      content: const LocationPickerW(),
      enableDrag: false,
      expand: false,
      isDismissible: false,
    );
  }

  void showAvailability() {
    LNDShow.bottomSheet(const AvailabilityW());
  }

  void addInclusion() {
    if (inclusionController.text.isNotEmpty) {
      inclusions.add(inclusionController.text.capitalizeFirst ?? '');
      inclusionController.clear();
    }
  }

  void removeInclusion(int index) {
    inclusions.removeAt(index);
  }

  void onChangedAvailability(Availability? value) {
    if (value == null) return;

    availability.value = value;
  }

  void next() {
    if (formKey.currentState?.validate() == false) {
      return;
    }

    debugPrint('dailyPriceController: ${dailyPriceController.text}');
    debugPrint('weeklyPriceController: ${weeklyPriceController.text}');
    debugPrint('monthlyPriceController: ${monthlyPriceController.text}');
    debugPrint('annualPriceController: ${annualPriceController.text}');
  }
}
