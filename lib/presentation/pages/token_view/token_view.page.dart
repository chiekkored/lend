import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/services/booking.service.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/pulsing_dot.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/pages/chat/chat.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/int.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class TokenViewArgs {
  final Booking booking;
  final String token;

  TokenViewArgs({required this.booking, required this.token});
}

class TokenViewPage extends StatelessWidget {
  static const routeName = '/token-view';
  const TokenViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as TokenViewArgs;

    void markBooking() async {
      LNDLoading.show();
      final result = await BookingService.markBooking(token: args.token);
      LNDLoading.hide();
      if (result != null) {
        Get.until((a) {
          return a.settings.name == ChatPage.routeName;
        });
      } else {
        LNDSnackbar.showError('Something went wrong');
      }
    }

    return Scaffold(
      appBar: AppBar(leading: LNDButton.close()),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        color: LNDColors.primary.withValues(alpha: 0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            SizedBox(
              height: 300.0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: Stack(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: LNDColors.outline,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12.0),
                              topRight: Radius.circular(12.0),
                            ),
                            child: LNDImage.custom(
                              height: double.infinity,
                              width: double.infinity,
                              imageUrl: args.booking.asset?.images?.first,
                              borderRadius: 0.0,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: LNDUtils.isTodayInTimestamps(
                            args.booking.dates ?? [],
                          ),
                          child: const Positioned(
                            top: 15.0,
                            left: 15.0,
                            child: LNDPulsingDot(color: LNDColors.success),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: LNDColors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16.0),
                          bottomRight: Radius.circular(16.0),
                        ),
                      ),
                      child: Column(
                        spacing: 2.0,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              LNDText.regular(
                                text: args.booking.asset?.title ?? '',
                                isSelectable: true,
                              ),
                              LNDText.bold(
                                text: '₱${args.booking.totalPrice.toMoney()}',
                              ),
                            ],
                          ),
                          LNDText.regular(
                            text: LNDUtils.getDateRange(
                              start: args.booking.dates?.first.toDate(),
                              end: args.booking.dates?.last.toDate(),
                            ),
                            color: LNDColors.hint,
                          ),
                          Visibility(
                            visible: args.booking.asset?.location != null,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FaIcon(
                                  FontAwesomeIcons.locationDot,
                                  color: LNDColors.hint,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: LNDText.regular(
                                    text: LNDUtils.getAddressText(
                                      location: args.booking.asset?.location,
                                      toObscure: false,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            LNDButton.primary(
              text: 'Proceed',
              enabled: true,
              onPressed: markBooking,
            ),
          ],
        ),
      ),
    );
  }
}
