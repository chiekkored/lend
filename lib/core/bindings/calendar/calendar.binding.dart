import 'package:get/get.dart';
import 'package:lend/presentation/controllers/calendar/calendar.controller.dart';

class CalendarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalendarController());
  }
}
