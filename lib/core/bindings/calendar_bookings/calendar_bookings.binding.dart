import 'package:get/get.dart';
import 'package:lend/presentation/controllers/calendar_bookings/calendar_bookings.controller.dart';

class CalendarBookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalendarBookingsController());
  }
}
