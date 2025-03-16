import 'package:get/get.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';

class AssetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AssetController());
  }
}
