import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/models/rates.model.dart';
import 'package:lend/core/services/booking.service.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';
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
  DateTime? get selectedDate =>
      _selectedDates.isNotEmpty ? _selectedDates.first : null;

  /// For Calendar Widget. It only accepts list of dates
  List<DateTime> get selectedDates => _selectedDates;

  final Map<String, Color> _bookingColorMap = {};

  /// Assign a unique color to each booking
  List<ColoredBookings> get _coloredBookings {
    return args.bookings.map((booking) {
      final bookingId = booking.id ?? '';
      if (!_bookingColorMap.containsKey(bookingId)) {
        _bookingColorMap[bookingId] = _getRandomColor(bookingId);
      }
      return ColoredBookings(
        booking: booking,
        color: _bookingColorMap[bookingId]!,
      );
    }).toList();
  }

  /// Gets bookings for the selected day
  List<ColoredBookings> get selectedDayBookings {
    if (selectedDate == null) return [];

    return _coloredBookings.where((colored) {
      return colored.booking.dates?.any(
            (d) =>
                d.toDate().isAtSameMomentAs(selectedDate!) &&
                colored.booking.status == BookingStatus.pending,
          ) ??
          false;
    }).toList();
  }

  final renterColors = [
    const Color(0xFFE57373), // red
    const Color(0xFF64B5F6), // blue
    const Color(0xFF81C784), // green
    const Color(0xFFFFB74D), // orange
    const Color(0xFFBA68C8), // purple
    const Color(0xFF4DB6AC), // teal
    const Color(0xFFFF8A65), // coral
    const Color(0xFF7986CB), // indigo
  ];

  @override
  void onClose() {
    _selectedDates.close();

    super.onClose();
  }

  /// Generates random color
  Color _getRandomColor(String id) {
    // final random = Random();

    // Limit values between 0 and 180 to avoid very bright colors
    // const min = 0;
    // const max = 180;

    // return Color.fromARGB(
    //   255,
    //   min + random.nextInt(max - min),
    //   min + random.nextInt(max - min),
    //   min + random.nextInt(max - min),
    // );

    if (id.isEmpty) return renterColors.first;

    // Convert id string to a numeric hash
    final bytes = utf8.encode(id);
    final hash = bytes.fold<int>(0, (prev, byte) => (prev + byte) % 100000);

    // Use hash to pick a color deterministically
    final index = hash % renterColors.length;
    return renterColors[index];
  }

  void onCalendarChanged(List<DateTime> dates) async {
    _selectedDates.value = dates;
  }

  /// Gets the designated colors to display dots on the calendar day
  List<Color> getBookingColors(DateTime date) {
    List<Color> colors = [];

    for (var colored in _coloredBookings) {
      final booking = colored.booking;
      final color = colored.color;

      booking.dates?.forEach((bookedDate) {
        if (bookedDate.toDate().isAtSameMomentAs(date) &&
            booking.status == BookingStatus.pending) {
          colors.add(color);
        }
      });
    }

    return colors;
  }

  bool checkAvailability(DateTime date) {
    for (var booking in args.bookings) {
      for (var bookedDate in booking.dates ?? []) {
        if (bookedDate.toDate().isAtSameMomentAs(date)) {
          if (booking.status == BookingStatus.confirmed) {
            return true;
          }
        }
      }
    }
    return false;
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

  Future<void> onTapBooking(Booking booking) async {
    final result = await LNDShow.alertDialog<bool?>(
      title: 'Accept this booking?',
      content:
          'Are you sure you want to accept this booking request? '
          'All other pending bookings for the same day will be declined.',
    );

    if (result == null || !result) return;

    try {
      LNDLoading.show();

      final result = await BookingService.acceptBooking(booking);

      result.fold(
        ifLeft: (response) async {
          await AssetController.instance.getBookings();
          update();
          LNDLoading.hide();
        },
        ifRight: (error) {
          throw error;
        },
      );
    } catch (e, st) {
      LNDLoading.hide();
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
      if (Get.isRegistered<AssetController>()) {
        AssetController.instance.getBookings();
      }
      LNDSnackbar.showError(e.toString());
    }
  }
}

class ColoredBookings {
  final Booking booking;
  final Color color;

  ColoredBookings({required this.booking, required this.color});
}
