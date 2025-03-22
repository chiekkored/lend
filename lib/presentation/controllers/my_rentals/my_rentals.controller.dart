import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';

class MyRentalsController extends GetxController with AuthMixin {
  static get instance => Get.find<MyRentalsController>();
}
