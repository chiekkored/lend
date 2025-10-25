import 'package:get/get.dart';
import 'package:lend/presentation/controllers/calendar_picker/calendar_picker.controller.dart';

class CalendarPickerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CalendarPickerController());
  }
}
