import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/controllers/signup/signup.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/string.extension.dart';

class DateOfBirth extends GetWidget<SignUpController> {
  const DateOfBirth({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate =
        controller.dobController.text.isNotEmpty
            ? DateFormat('MMMM dd, yyyy').parse(controller.dobController.text)
            : DateTime.now();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: LNDButton.text(
              text: 'Done',
              onPressed: () {
                final formattedDate = selectedDate.toMonthDayYear();
                controller.dobController.text = formattedDate;
                Get.back();
              },
              enabled: true,
              color: LNDColors.primary,
            ),
          ),
          Container(
            height: 300.0,
            padding: const EdgeInsets.all(16.0),
            child: CupertinoDatePicker(
              initialDateTime: selectedDate,
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime value) {
                selectedDate = value;

                final formattedDate = value.toMonthDayYear();
                controller.dobController.text = formattedDate;
              },
            ),
          ),
        ],
      ),
    );
  }
}
