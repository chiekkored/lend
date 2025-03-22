import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/my_rentals/my_rentals.controller.dart';
import 'package:lend/presentation/pages/navigation/components/my_rentals/widgets/my_rentals_appbar.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class MyRentalsPage extends GetView<MyRentalsController> {
  const MyRentalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LNDColors.white,
      body: NestedScrollView(
        physics:
            !controller.isAuthenticated
                ? const NeverScrollableScrollPhysics()
                : null,
        floatHeaderSlivers: true,
        headerSliverBuilder: (_, __) {
          return [const MyRentalsAppbar()];
        },
        body:
            !controller.isAuthenticated
                ? _SigninView()
                : const Center(child: Text('Logged in!')),
      ),
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
              onPressed: controller.checkAuth,
            ),
          ],
        ).withSpacing(24.0),
      ),
    );
  }
}
