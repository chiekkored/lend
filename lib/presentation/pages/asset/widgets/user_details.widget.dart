import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/image_type.enum.dart';
import 'package:lend/utilities/extensions/string.extension.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/helpers/utilities.helper.dart';
import 'package:shimmer/shimmer.dart';

class AssetUserDetails extends GetWidget<AssetController> {
  const AssetUserDetails({super.key});

  // Helper method to conditionally show address based on useSpecificLocation
  String _getAddressText() {
    final location = controller.asset?.location;
    final address = location?.description;

    // Return full address if useSpecificLocation is true
    if (location?.useSpecificLocation == true ||
        address == null ||
        address.isEmpty) {
      return (address ?? '').toObscure();
    }

    // Otherwise show only last two components
    final components = address.split(', ');
    if (components.length <= 2) return address;

    return components.sublist(components.length - 2).join(', ').toObscure();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        color: LNDColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40.0,
              child: Obx(
                () =>
                    controller.isUserLoading
                        ? Shimmer.fromColors(
                          baseColor: LNDColors.outline,
                          highlightColor: LNDColors.white,
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: LNDColors.white,
                              ),
                              Container(
                                height: 20.0,
                                width: 200.0,
                                decoration: BoxDecoration(
                                  color: LNDColors.white,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                              ),
                            ],
                          ).withSpacing(8.0),
                        )
                        : GestureDetector(
                          // onTap: controller.goToProfileView,
                          child: Row(
                            children: [
                              LNDImage.circle(
                                imageUrl: controller.asset?.owner?.photoUrl,
                                size: 40.0,
                                imageType: ImageType.user,
                              ),
                              const SizedBox(width: 8.0),
                              LNDText.bold(
                                text:
                                    LNDUtils.formatFullName(
                                      firstName:
                                          controller.asset?.owner?.firstName,
                                      lastName:
                                          controller.asset?.owner?.lastName,
                                    ).toObscure(),
                              ),
                              const SizedBox(width: 2.0),
                              const Icon(
                                Icons.verified_rounded,
                                size: 15.0,
                                color: LNDColors.primary,
                              ),
                            ],
                          ),
                        ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.locationDot,
                            color: LNDColors.hint,
                            size: 20.0,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Obx(
                              () => LNDText.regular(text: _getAddressText()),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // LNDButton.icon(
                    //   icon: FontAwesomeIcons.angleRight,
                    //   onPressed: () {},
                    //   size: 20.0,
                    // ),
                  ],
                ),
                SizedBox(
                  height: 100.0,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Obx(
                      () => GoogleMap(
                        buildingsEnabled: false,
                        initialCameraPosition: controller.cameraPosition,
                        onMapCreated: controller.onMapCreated,
                        circles: controller.circles.toSet(),
                        markers: controller.markers.toSet(),
                        myLocationButtonEnabled: false,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                      ),
                    ),
                  ),
                ),
              ],
            ).withSpacing(16.0),
          ],
        ).withSpacing(16.0),
      ),
    );
  }
}
