import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/my_rentals/my_rentals.controller.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/presentation/pages/navigation/components/my_rentals/widgets/my_rentals_appbar.widget.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/bookingStatus.extension.dart';
import 'package:lend/utilities/extensions/int.extension.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class MyRentalsPage extends GetView<MyRentalsController> {
  const MyRentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => NestedScrollView(
            controller: controller.scrollController,
            physics:
                !controller.isAuthenticated
                    ? const NeverScrollableScrollPhysics()
                    : null,
            floatHeaderSlivers: true,
            headerSliverBuilder: (_, __) {
              return [const MyRentalsAppbar()];
            },
            body: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (!controller.isAuthenticated) {
      return _SigninView();
    }

    if (controller.isMyRentalsLoading) {
      return const Center(child: LNDSpinner());
    }

    final isEligible = ProfileController.instance.isRentingEligible;

    return RefreshIndicator.adaptive(
      onRefresh: () async => controller.refreshMyRentals(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (!isEligible) SliverToBoxAdapter(child: _buildNotEligible()),

          Obx(() {
            final rentals = controller.myRentals;
            if (rentals.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: LNDText.regular(
                    text: 'You have no rentals yet',
                    color: LNDColors.hint,
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final booking = rentals[index];
                final dates = LNDUtils.getDateRange(
                  start: booking.dates?.first.toDate(),
                  end: booking.dates?.last.toDate(),
                );
                return _buildRentalItem(booking, dates);
              }, childCount: rentals.length),
            );
          }),
        ],
      ),
    );
  }

  Padding _buildNotEligible() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Image.asset('assets/images/listing.png', width: Get.width / 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: LNDText.bold(
              text: 'Verify your account ',
              textAlign: TextAlign.center,
              textParts: [
                LNDText.regular(
                  text:
                      'to start listing and '
                      'renting out your assets securely.',
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: LNDButton.primary(
              text: 'Verify Account',
              enabled: true,
              hasPadding: false,
              onPressed: () {},
            ),
          ),
        ],
      ).withSpacing(8.0),
    );
  }

  Container _buildRentalItem(Booking rentals, String dates) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: LNDColors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: LNDColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4.0,
            children: [
              CircleAvatar(radius: 6.0, backgroundColor: rentals.status?.color),
              LNDText.regular(
                text: rentals.status?.label.capitalizeFirst ?? '',
                fontSize: 12.0,
              ),
            ],
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LNDImage.square(
                  imageUrl: rentals.asset?.images?.first,
                  size: 80.0,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LNDText.regular(text: rentals.asset?.title ?? ''),
                          LNDText.regular(
                            text: rentals.asset?.category ?? '',
                            color: LNDColors.hint,
                          ),
                        ],
                      ),
                      LNDText.regular(text: dates),
                    ],
                  ),
                ),
                LNDText.bold(text: '₱${rentals.totalPrice?.toMoney()}'),
              ],
            ).withSpacing(16.0),
          ),
          LNDButton.secondary(
            text: 'Details',
            hasPadding: false,
            enabled: true,
            onPressed:
                () => controller.goToAsset(
                  Asset.fromMap(rentals.asset?.toMap() ?? {}),
                ),
          ),
        ],
      ).withSpacing(12.0),
    );
  }
}

class _SigninView extends GetView<MyRentalsController> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LNDText.bold(text: 'Sign in to view your rentals', fontSize: 24.0),
            LNDText.regular(
              text:
                  'Keep track of your active, past, and upcoming bookings—all in one place.',
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
        ).withSpacing(24.0),
      ),
    );
  }
}
