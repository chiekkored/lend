import 'package:get/get.dart';
import 'package:lend/presentation/controllers/chat/chat.controller.dart';
import 'package:lend/presentation/controllers/profile_view/profile_view.controller.dart';

class ProfileViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileViewController());
  }
}
