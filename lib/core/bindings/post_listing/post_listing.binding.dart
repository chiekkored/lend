import 'package:get/get.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';

class PostListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostListingController());
  }
}
