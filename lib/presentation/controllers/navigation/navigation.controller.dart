import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavigationController extends GetxController {
  static NavigationController instance = Get.find<NavigationController>();

  final PersistentTabController _navigationController =
      PersistentTabController(historyLength: 0);

  PersistentTabController get navigationController => _navigationController;

  void changeTab(int index) {
    _navigationController.jumpToTab(index);
  }

  void openTapProfileTab() {
    // SPZPopup.bottomSheet(PopupProfileTabWidget(), hasPadding: false);
  }
}
