import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/presentation/pages/navigation/components/profile/widgets/profile_appbar.widget.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    UserModel? user = controller.user;
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(),
          floatHeaderSlivers: true,
          headerSliverBuilder: (_, __) {
            return [const ProfileAppbar()];
          },
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: LNDColors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: LNDColors.outline),
                ),
                child: Obx(
                  () =>
                      !controller.isAuthenticated
                          ? _SigninView()
                          : ListTile(
                            leading:
                                controller.isLoading
                                    ? Shimmer.fromColors(
                                      baseColor: LNDColors.outline,
                                      highlightColor: LNDColors.white,
                                      child: const CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: LNDColors.white,
                                      ),
                                    )
                                    : LNDImage.circle(
                                      imageUrl: user?.photoUrl,
                                      size: 50.0,
                                    ),
                            title:
                                controller.isLoading
                                    ? Shimmer.fromColors(
                                      baseColor: LNDColors.outline,
                                      highlightColor: LNDColors.white,
                                      child: Container(
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          color: LNDColors.white,
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                      ),
                                    )
                                    : Obx(
                                      () => LNDText.regular(
                                        text: LNDUtils.formatFullName(
                                          firstName: controller.user?.firstName,
                                          lastName: controller.user?.lastName,
                                        ),
                                      ),
                                    ),
                            subtitle: LNDText.regular(
                              text: 'View Profile',
                              color: LNDColors.gray,
                              fontSize: 12.0,
                            ),
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: LNDColors.gray,
                              size: 30.0,
                            ),
                          ),
                ),
              ),
              ColoredBox(
                color: LNDColors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildListWidget(
                      label: 'Settings',
                      icon: Icons.settings_rounded,
                      onTap: () {},
                    ),
                    _buildListWidget(
                      label: 'About',
                      icon: Icons.menu_book_rounded,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              ColoredBox(
                color: LNDColors.white,
                child: _buildListWidget(
                  label: 'Logout',
                  icon: Icons.logout_rounded,
                  color: LNDColors.danger,
                  showTrailing: false,
                  onTap: controller.signOut,
                ),
              ),
            ],
          ).withSpacing(16.0),
        ),
      ),
    );
  }

  Widget _buildListWidget({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color color = LNDColors.black,
    bool showTrailing = true,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: color),
      onTap: onTap,
      splashColor: Colors.transparent,
      title: LNDText.regular(text: label, color: color),
      trailing:
          showTrailing ? Icon(Icons.chevron_right_rounded, color: color) : null,
    );
  }
}

class _SigninView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LNDText.bold(text: 'Sign in to access your profile', fontSize: 24.0),
          LNDText.regular(
            text: 'Manage your information, preferences, and rental listings.',
            textAlign: TextAlign.center,
            color: LNDColors.hint,
          ),
          LNDButton.primary(
            text: 'Sign in',
            enabled: true,
            onPressed:
                controller.isAuthenticated
                    ? null
                    : () => Get.toNamed(SigninPage.routeName),
          ),
        ],
      ).withSpacing(8.0),
    );
  }
}
