import 'package:get/get.dart';
import 'package:lend/presentation/controllers/chat/chat.controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatController());
  }
}
