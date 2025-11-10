import 'package:get/get.dart';
import 'package:lend/presentation/controllers/scan_qr/scan_qr.controller.dart';

class ScanQRBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScanQRController());
  }
}
