import 'package:get/get.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
  }
}
