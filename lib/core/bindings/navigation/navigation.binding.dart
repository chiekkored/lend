import 'package:get/get.dart';
import 'package:lend/presentation/controllers/navigation/navigation.controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigationController());
  }
}
