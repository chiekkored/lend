import 'package:get/get.dart';

class LoadingController extends GetxController {
  static LoadingController get instance => Get.find<LoadingController>();

  var isLoading = false.obs;

  void show() => isLoading.value = true;
  void hide() => isLoading.value = false;

  @override
  void onClose() {
    isLoading.close();

    super.onClose();
  }
}
