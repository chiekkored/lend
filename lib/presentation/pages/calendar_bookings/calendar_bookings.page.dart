import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/controllers/calendar_bookings/calendar_bookings.controller.dart';
import 'package:lend/presentation/pages/calendar_bookings/widgets/calendar_view.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class CalendarBookingsPage extends GetView<CalendarBookingsController> {
  static const routeName = '/calendar-bookings';
  const CalendarBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LNDButton.back(),
        backgroundColor: LNDColors.white,
        surfaceTintColor: LNDColors.white,
      ),
      body: const CalendarView(),
    );
  }
}
