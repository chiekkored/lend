import 'package:get/get.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/home/home.controller.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/presentation/controllers/your_listing/your_listing.controller.dart';
import 'package:lend/presentation/controllers/my_rentals/my_rentals.controller.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);

    Get.put(ProfileController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(MyRentalsController(), permanent: true);
    Get.put(YourListingController(), permanent: true);
    Get.put(MessagesController(), permanent: true);
  }
}
