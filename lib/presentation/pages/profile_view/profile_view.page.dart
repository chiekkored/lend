import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/shimmer.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/profile_view/profile_view.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/eligibility.enum.dart';
import 'package:lend/utilities/enums/image_type.enum.dart';
import 'package:lend/utilities/extensions/string.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class ProfileViewPage extends GetView<ProfileViewController> {
  static const routeName = '/profile-view';
  const ProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: LNDColors.white,
        backgroundColor: LNDColors.white,
        leading: LNDButton.back(
          onPressed: canPop ? () => Navigator.of(context).pop() : null,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) return const _LoadingWidget();

        if (controller.user == null) return Container();

        final user = controller.user!;
        final isListingEligible = user.isListingEligible == Eligibility.yes;
        final isRentingEligible = user.isRentingEligible == Eligibility.yes;
        final isFullyVerified = isListingEligible && isRentingEligible;
        final isSemiVerified = isListingEligible || isRentingEligible;

        return Column(
          spacing: 12.0,
          children: [
            const SizedBox(height: 24.0),
            Center(
              child: LNDImage.circle(
                imageUrl: user.photoUrl,
                size: 100.0,
                imageType: ImageType.user,
              ),
            ),
            if (!isSemiVerified)
              Visibility(
                visible: controller.isCurrentUser(user.uid),
                child: SizedBox(
                  width: 200.0,
                  child: LNDButton.primary(
                    text: 'Verify now',
                    enabled: true,
                    onPressed: () {},
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                decoration: BoxDecoration(
                  color: LNDColors.primary.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: LNDText.regular(
                  text: isFullyVerified ? 'Fully Verified' : 'Semi Verified',
                  color: LNDColors.white,
                  fontSize: 12.0,
                ),
              ),
            Expanded(
              child: Container(
                width: Get.width,
                color: LNDColors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildItem(
                      label: 'Fullname',
                      value: LNDUtils.formatFullName(
                        firstName: user.firstName,
                        lastName: user.lastName,
                      ),
                    ),
                    _buildItem(label: 'Email', value: user.email),
                    _buildItem(label: 'Phone Number', value: user.phone),
                    _buildItem(
                      label: 'Date of Birth',
                      value: user.dateOfBirth.toMonthDayYear(),
                    ),
                    _buildItem(
                      label: 'Location',
                      value: user.location?.description,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildItem({required String label, required String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        spacing: 4.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LNDText.bold(text: label, fontSize: 12.0),
          LNDText.regular(text: value == null || value.isEmpty ? 'N/A' : value),
        ],
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return LNDShimmer(
      child: Column(
        spacing: 12.0,
        children: [
          const SizedBox(height: 24.0),
          const LNDShimmerCircle(size: 100.0),
          const LNDShimmerBox(height: 20.0, width: 200.0),
          Expanded(
            child: Container(
              color: LNDColors.white,
              width: Get.width,
              child: LNDShimmerBox(height: 20.0, width: Get.width),
            ),
          ),
        ],
      ),
    );
  }
}
