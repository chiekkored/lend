import 'package:flutter/material.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';

extension BookingStatusColor on BookingStatus {
  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.declined:
        return Colors.red;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }
}
