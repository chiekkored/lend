import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/home/home.controller.dart';
import 'package:lend/presentation/controllers/messages/messages.controller.dart';
import 'package:lend/presentation/controllers/my_rentals/my_rentals.controller.dart';
import 'package:lend/presentation/controllers/navigation/navigation.controller.dart';
import 'package:lend/presentation/pages/navigation/components/home/home.page.dart';
import 'package:lend/presentation/pages/navigation/components/messages/messages.page.dart';
import 'package:lend/presentation/pages/navigation/components/my_rentals/my_rentals.page.dart';
import 'package:lend/presentation/pages/navigation/components/profile/profile.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavigationPage extends GetView<NavigationController> {
  static const routeName = '/navigation';
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    const selectedIconSize = 35.0;
    const unselectedIconSize = 35.0;
    const badgeSize = 12.0;
    return PersistentTabView(
      backgroundColor: LNDColors.white,
      controller: controller.navigationController,
      navBarOverlap: const NavBarOverlap.none(),
      tabs: [
        PersistentTabConfig(
          item: ItemConfig(
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const Icon(Icons.search_outlined, size: selectedIconSize + 3),
            inactiveIcon: const Icon(
              Icons.search_rounded,
              size: unselectedIconSize + 3,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveForegroundColor: LNDColors.unselected,
          ),
          onSelectedTabPressWhenNoScreensPushed:
              () => HomeController.instance.scrollToTop(),
          screen: const HomePage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const Icon(Icons.handshake_rounded, size: selectedIconSize),
            inactiveIcon: const Icon(
              Icons.handshake_outlined,
              size: unselectedIconSize,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveForegroundColor: LNDColors.unselected,
          ),
          onSelectedTabPressWhenNoScreensPushed:
              () => MyRentalsController.instance.scrollToTop(),
          screen: const MyRentalsPage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: Center(
              child: Obx(
                () => Badge(
                  smallSize: badgeSize,
                  padding: EdgeInsets.zero,
                  isLabelVisible: MessagesController.instance.unreadCount,
                  child: const Icon(
                    Icons.inbox_rounded,
                    size: selectedIconSize,
                  ),
                ),
              ),
            ),
            inactiveIcon: Center(
              child: Obx(
                () => Badge(
                  smallSize: badgeSize,
                  padding: EdgeInsets.zero,
                  isLabelVisible: MessagesController.instance.unreadCount,
                  child: const Icon(
                    Icons.inbox_outlined,
                    size: unselectedIconSize,
                  ),
                ),
              ),
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveForegroundColor: LNDColors.unselected,
          ),
          onSelectedTabPressWhenNoScreensPushed:
              () => MessagesController.instance.scrollToTop(),
          screen: const MessagesPage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const Icon(
              Icons.account_circle_rounded,
              size: selectedIconSize,
            ),
            inactiveIcon: const Icon(
              Icons.account_circle_outlined,
              size: unselectedIconSize,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveForegroundColor: LNDColors.unselected,
          ),
          screen: const ProfilePage(),
        ),
      ],
      navBarBuilder:
          (navBarConfig) => Style1BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: const NavBarDecoration(color: LNDColors.white),
          ),
    );
  }
}
