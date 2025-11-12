import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/image_type.enum.dart';
import 'package:lend/utilities/extensions/int.extension.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';

class OnGoingBookingW extends StatelessWidget {
  const OnGoingBookingW({required this.booking, super.key});

  final Booking booking;

  void _onTapHandedover(bool isOwner) {
    if (isOwner) {
      LNDNavigate.toQRViewPage(qrToken: booking.tokens?.handoverToken ?? '');
    } else {
      LNDNavigate.toScanQRPage();
    }
  }

  void _onTapReturned(bool isOwner) {
    if (isOwner) {
      LNDNavigate.toScanQRPage();
    } else {
      LNDNavigate.toQRViewPage(qrToken: booking.tokens?.returnToken ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dates = LNDUtils.getDateRange(
      start: booking.dates?.first.toDate(),
      end: booking.dates?.last.toDate(),
    );
    final latLng = LatLng(
      booking.asset?.location?.latLng?.latitude ?? 0.0,
      booking.asset?.location?.latLng?.longitude ?? 0.0,
    );
    final useSpecificLocation =
        booking.asset?.location?.useSpecificLocation ?? false;
    final isOwner = booking.asset?.owner?.uid == AuthController.instance.uid;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        spacing: 12.0,
        mainAxisSize: MainAxisSize.min,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LNDImage.square(
                  imageUrl: booking.asset?.images?.first,
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
                          LNDText.regular(text: booking.asset?.title ?? ''),
                          LNDText.regular(
                            text: booking.asset?.category ?? '',
                            color: LNDColors.hint,
                          ),
                        ],
                      ),
                      LNDText.regular(text: dates),
                    ],
                  ),
                ),
                LNDText.bold(text: '₱${booking.totalPrice?.toMoney()}'),
              ],
            ).withSpacing(16.0),
          ),
          Row(
            children: [
              LNDImage.circle(
                imageUrl: booking.asset?.owner?.photoUrl,
                size: 40.0,
                imageType: ImageType.user,
              ),
              const SizedBox(width: 8.0),
              LNDText.bold(
                text: LNDUtils.formatFullName(
                  firstName: booking.asset?.owner?.firstName,
                  lastName: booking.asset?.owner?.lastName,
                ),
              ),
              const SizedBox(width: 2.0),
              const Icon(
                Icons.verified_rounded,
                size: 15.0,
                color: LNDColors.primary,
              ),
            ],
          ),
          if (booking.asset?.location != null) ...[
            Row(
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
                      location: booking.asset?.location,
                      toObscure: false,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 100.0,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: GoogleMap(
                  buildingsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: latLng,
                    zoom: 13,
                  ),
                  onMapCreated: (gMapController) {
                    gMapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: latLng, zoom: 13),
                      ),
                    );
                  },
                  circles: {
                    if (!useSpecificLocation)
                      Circle(
                        circleId: const CircleId('selected-location'),
                        center: LNDUtils.getRandomLocationWithinRadius(
                          latLng,
                          500.0,
                        ),
                        radius: 500.0,
                        fillColor: Colors.blue.withValues(alpha: 0.5),
                        strokeColor: Colors.blue,
                        strokeWidth: 1,
                      ),
                  },
                  markers: {
                    if (useSpecificLocation)
                      Marker(
                        markerId: const MarkerId('selected-location-view'),
                        position: latLng,
                      ),
                  },
                  myLocationButtonEnabled: false,
                  zoomGesturesEnabled: false,
                  scrollGesturesEnabled: false,
                  zoomControlsEnabled: false,
                ),
              ),
            ),
          ],
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 12.0,
            children: [
              Expanded(
                child: LNDButton.secondary(
                  enabled: booking.handedOver == null,
                  icon:
                      isOwner
                          ? Icons.qr_code_scanner_rounded
                          : Icons.camera_alt_rounded,
                  iconSize: 15.0,
                  hasPadding: false,
                  text: 'Handed over?',
                  borderRadius: 16.0,
                  onPressed: () => _onTapHandedover(isOwner),
                ),
              ),
              Expanded(
                child: LNDButton.secondary(
                  enabled: booking.returned == null,
                  icon:
                      isOwner
                          ? Icons.camera_alt_rounded
                          : Icons.qr_code_scanner_rounded,
                  iconSize: 15.0,
                  hasPadding: false,
                  text: 'Returned?',
                  borderRadius: 16.0,
                  onPressed: () => _onTapReturned(isOwner),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
