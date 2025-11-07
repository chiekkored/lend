import 'package:flutter/material.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';

extension BookingStatusColor on BookingStatus {
  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return LNDColors.success;
      case BookingStatus.declined:
        return LNDColors.danger;
      case BookingStatus.cancelled:
        return LNDColors.danger;
    }
  }
}
