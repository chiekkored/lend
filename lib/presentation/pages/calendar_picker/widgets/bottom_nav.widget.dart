import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/calendar_picker/calendar_picker.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/int.extension.dart';

class CalendarBottomNav extends GetWidget<CalendarPickerController> {
  const CalendarBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105.0,
      decoration: const BoxDecoration(
        color: LNDColors.white,
        border: Border(top: BorderSide(color: LNDColors.hint, width: 0.5)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => LNDText.bold(
                  text: '₱${controller.totalPrice.toMoney()}',
                  fontSize: 18.0,
                ),
              ),
              Obx(
                () => LNDButton.primary(
                  text: 'Book',
                  enabled: controller.selectedDates.isNotEmpty,
                  onPressed: controller.onTapSubmit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
