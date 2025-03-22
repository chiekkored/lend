import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';

class ProfileController extends GetxController with AuthMixin {
  static get instance => Get.find<ProfileController>();
}
