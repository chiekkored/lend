import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    return PersistentTabView(
      controller: controller.navigationController,
      tabs: [
        PersistentTabConfig(
          item: ItemConfig(
            title: 'Home',
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const FaIcon(
              FontAwesomeIcons.house,
              size: 23.0,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveBackgroundColor: LNDColors.unselected,
          ),
          screen: const HomePage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            title: 'Rentals',
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const FaIcon(
              FontAwesomeIcons.handshakeAngle,
              size: 23.0,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveBackgroundColor: LNDColors.unselected,
          ),
          screen: const ProfilePage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            title: 'Chat',
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const FaIcon(
              FontAwesomeIcons.inbox,
              size: 23.0,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveBackgroundColor: LNDColors.unselected,
          ),
          screen: const ProfilePage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            title: 'Profile',
            textStyle: LNDText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const FaIcon(
              FontAwesomeIcons.solidIdBadge,
              size: 23.0,
            ),
            activeForegroundColor: LNDColors.primary,
            inactiveBackgroundColor: LNDColors.unselected,
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
