import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/navigation/navigation.controller.dart';
import 'package:lend/presentation/pages/navigation/components/home/home.page.dart';
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
    return PersistentTabView(
      controller: controller.navigationController,
      tabs: [
        PersistentTabConfig(
          item: ItemConfig(
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const Icon(
              Icons.home_rounded,
              size: selectedIconSize,
            ),
            inactiveIcon: const Icon(
              Icons.home_outlined,
              size: unselectedIconSize,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveForegroundColor: LNDColors.unselected,
          ),
          screen: const HomePage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const Icon(
              Icons.handshake_rounded,
              size: selectedIconSize,
            ),
            inactiveIcon: const Icon(
              Icons.handshake_outlined,
              size: unselectedIconSize,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveForegroundColor: LNDColors.unselected,
          ),
          screen: const ProfilePage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const Icon(
              Icons.inbox_rounded,
              size: selectedIconSize,
            ),
            inactiveIcon: const Icon(
              Icons.inbox_outlined,
              size: unselectedIconSize,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveForegroundColor: LNDColors.unselected,
          ),
          screen: const ProfilePage(),
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
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
