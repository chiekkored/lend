import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';

class ProfileController extends GetxController with AuthMixin {
  static get instance => Get.find<ProfileController>();

  void signOut() {
    AuthController.instance.signOut();
  }
}
