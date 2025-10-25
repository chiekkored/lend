import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/calendar_bookings/calendar_bookings.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/string.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class CalendarView extends GetWidget<CalendarBookingsController> {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Obx(
            () => CalendarDatePicker2(
              value: controller.selectedDates,
              onValueChanged: controller.onCalendarChanged,
              config: CalendarDatePicker2Config(
                disableVibration: false,
                allowSameValueSelection: false,
                calendarType: CalendarDatePicker2Type.single,
                calendarViewMode: CalendarDatePicker2Mode.scroll,
                dayModeScrollDirection: Axis.vertical,
                firstDate: DateTime.now().add(const Duration(days: 1)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                todayTextStyle: LNDText.boldStyle.copyWith(
                  color: LNDColors.black,
                ),
                selectedDayHighlightColor: LNDColors.primary,
                selectedRangeHighlightColor: LNDColors.primary.withValues(
                  alpha: 0.3,
                ),
                daySplashColor: LNDColors.primary.withValues(alpha: 0.5),
                // selectableDayPredicate:
                //     (day) =>
                //         controller.checkAvailability(day) &&
                //         !controller.args.isReadOnly,
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
                  final bookingColors = controller.getBookingColors(date);

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
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LNDText.regular(
                                    text: date.day.toString(),
                                    fontSize: 12.0,
                                    color: color,
                                    textDecoration:
                                        // isBooked
                                        //     ? TextDecoration.lineThrough
                                        //     :
                                        null,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children:
                                        bookingColors.map((color) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                              horizontal: 1,
                                            ),
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: color,
                                              shape: BoxShape.circle,
                                            ),
                                          );
                                        }).toList(),
                                  ),
                                ],
                              ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Container(
          height: Get.height / 3,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: LNDColors.white,
            border: Border(top: BorderSide(color: LNDColors.outline)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => Visibility(
                    visible: controller.selectedDate != null,
                    child: LNDText.bold(
                      text: controller.selectedDate.toMonthDayYear(),
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              Obx(() {
                // ignore: prefer_is_empty
                if (controller.selectedDayBookings.length == 0) {
                  return Expanded(
                    child: Center(
                      child: LNDText.regular(
                        text: 'Select a date',
                        color: LNDColors.gray,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.selectedDayBookings.length,
                  separatorBuilder:
                      (_, _) => const Divider(color: LNDColors.outline),
                  itemBuilder: (_, index) {
                    final coloredBooking =
                        controller.selectedDayBookings[index];

                    final booking = coloredBooking.booking;
                    final color = coloredBooking.color;

                    final dates = LNDUtils.getDateRange(
                      start: booking.dates?.first.toDate(),
                      end: booking.dates?.last.toDate(),
                    );

                    return ListTile(
                      dense: true,
                      leading: CircleAvatar(
                        backgroundColor: color,
                        radius: 10.0,
                      ),
                      title: LNDText.medium(
                        text: booking.renter?.getName ?? 'Unknown user',
                      ),
                      subtitle: LNDText.regular(
                        text: dates,
                        fontSize: 12.0,
                        color: LNDColors.hint,
                      ),
                      trailing: Row(
                        spacing: 4.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: LNDColors.outline,
                            ),
                            child: Center(
                              child: LNDButton.icon(
                                icon: Icons.inbox_rounded,
                                size: 25.0,
                                onPressed:
                                    () => controller.onTapGoToChat(booking),
                              ),
                            ),
                          ),
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: LNDColors.outline,
                            ),
                            child: Center(
                              child: LNDButton.icon(
                                icon: Icons.check_circle_rounded,
                                color: LNDColors.success,
                                size: 25.0,
                                onPressed:
                                    () => controller.onTapBooking(booking),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
