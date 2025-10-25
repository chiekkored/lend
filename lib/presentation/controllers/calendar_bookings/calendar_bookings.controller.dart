import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/models/rates.model.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class CalendarBookingsPageArgs {
  final bool isReadOnly;
  final List<Booking> bookings;
  final Rates rates;

  CalendarBookingsPageArgs({
    required this.isReadOnly,
    required this.bookings,
    required this.rates,
  });
}

class CalendarBookingsController extends GetxController {
  static CalendarBookingsController get instance =>
      Get.find<CalendarBookingsController>();

  final args = Get.arguments as CalendarBookingsPageArgs;

  final RxList<DateTime> _selectedDates = <DateTime>[].obs;
  List<DateTime> get selectedDates => _selectedDates;

  DateTime? get selectedDate =>
      selectedDates.isNotEmpty ? selectedDates.first : null;

  final Map<String, Color> _bookingColorMap = {};

  List<ColoredBookings> get _coloredBookings {
    return args.bookings.map((booking) {
      final bookingId = booking.id ?? '';
      if (!_bookingColorMap.containsKey(bookingId)) {
        _bookingColorMap[bookingId] = _getRandomColor();
      }
      return ColoredBookings(
        booking: booking,
        color: _bookingColorMap[bookingId]!,
      );
    }).toList();
  }

  List<ColoredBookings> get selectedDayBookings {
    if (selectedDate == null) return [];

    return _coloredBookings.where((colored) {
      return colored.booking.dates?.any(
            (d) => d.toDate().isAtSameMomentAs(selectedDate!),
          ) ??
          false;
    }).toList();
  }

  @override
  void onClose() {
    _selectedDates.close();

    super.onClose();
  }

  Color _getRandomColor() {
    final random = Random();

    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  void onCalendarChanged(List<DateTime> dates) async {
    _selectedDates.value = dates;
  }

  List<Color> getBookingColors(DateTime date) {
    List<Color> colors = [];

    for (var colored in _coloredBookings) {
      final booking = colored.booking;
      final color = colored.color;

      booking.dates?.forEach((bookedDate) {
        if (bookedDate.toDate().isAtSameMomentAs(date)) {
          colors.add(color);
        }
      });
    }

    return colors;
  }

  void onTapGoToChat(Booking booking) {
    if (booking.id == null) return;

    try {
      final chat = MessagesController.instance.findChatByBookingId(booking.id!);

      if (chat == null) throw 'Cannot find chat for this booking';

      LNDNavigate.toChatPage(chat: chat);
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
      LNDSnackbar.showError('Something went wrong');
    }
  }

  void onTapBooking(Booking booking) {
    try {
      LNDShow.alertDialog(title: 'title', content: 'content');
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }
}

class ColoredBookings {
  final Booking booking;
  final Color color;

  ColoredBookings({required this.booking, required this.color});
}
