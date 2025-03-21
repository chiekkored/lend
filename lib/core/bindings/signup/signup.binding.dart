import 'package:get/get.dart';
import 'package:lend/presentation/controllers/signup/signup.controller.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SignUpController());
  }
}
