import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/controllers/navigation/navigation.controller.dart';
import 'package:lend/presentation/pages/navigation/components/home/home.page.dart';
import 'package:lend/presentation/pages/navigation/components/profile/profile.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class NavigationPage extends GetView<NavigationController> {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: controller.navigationController,
      tabs: [
        PersistentTabConfig(
          item: ItemConfig(
            // textStyle: SPZText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const FaIcon(FontAwesomeIcons.house),
            activeForegroundColor: LNDColors.primary,
            inactiveBackgroundColor: LNDColors.unselected,
          ),
          screen: const HomePage(),
        ),
        PersistentTabConfig(
          item: ItemConfig(
            // textStyle: SPZText.mediumStyle.copyWith(fontSize: 10.0),
            icon: const FaIcon(FontAwesomeIcons.solidUser),
            activeForegroundColor: LNDColors.primary,
            inactiveBackgroundColor: LNDColors.unselected,
          ),
          screen: const ProfilePage(),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style5BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
