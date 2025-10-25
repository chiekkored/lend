import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/calendar/calendar.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class CalendarView extends GetWidget<CalendarController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(
        () => CalendarDatePicker2(
          value: controller.selectedDates,
          onValueChanged: controller.onCalendarChanged,
          config: CalendarDatePicker2Config(
            disableVibration: false,
            allowSameValueSelection: false,
            calendarType: CalendarDatePicker2Type.range,
            calendarViewMode: CalendarDatePicker2Mode.scroll,
            dayModeScrollDirection: Axis.vertical,
            firstDate: DateTime.now().add(const Duration(days: 1)),
            todayTextStyle: LNDText.boldStyle.copyWith(color: LNDColors.black),
            selectedDayHighlightColor: LNDColors.primary,
            selectedRangeHighlightColor: LNDColors.primary.withValues(
              alpha: 0.3,
            ),
            daySplashColor: LNDColors.primary.withValues(alpha: 0.5),
            selectableDayPredicate:
                (day) =>
                    controller.checkAvailability(day) &&
                    !controller.args.isReadOnly,
            dayBuilder: ({
              required date,
              decoration,
              isDisabled,
              isSelected,
              isToday,
              textStyle,
            }) {
              Color color = LNDColors.black;
              if (isDisabled ?? false) color = LNDColors.gray;
              if (isSelected ?? false) color = LNDColors.white;
              final isBooked = !controller.checkAvailability(date);

              return Container(
                decoration: decoration,
                child: Center(
                  child:
                      (isToday ?? false)
                          ? LNDText.bold(
                            text: date.day.toString(),
                            fontSize: 16.0,
                            color: Colors.red,
                          )
                          : LNDText.regular(
                            text: date.day.toString(),
                            fontSize: 12.0,
                            color: color,
                            textDecoration:
                                isBooked ? TextDecoration.lineThrough : null,
                          ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
