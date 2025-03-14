import 'package:get/get.dart';
import 'package:lend/presentation/controllers/signin/signin.controller.dart';

class SigninBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SigninController>(() => SigninController());
  }
}
