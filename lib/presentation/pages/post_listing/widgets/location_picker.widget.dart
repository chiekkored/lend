import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/location_picker/location_picker.controller.dart';
import 'package:lend/presentation/pages/post_listing/widgets/fields/post_switch_field.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LocationPickerW extends StatelessWidget {
  final LocationCallbackModel? locationCallback;
  const LocationPickerW({super.key, this.locationCallback});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    focusNode.requestFocus();

    return GetBuilder(
      init: LocationPickerController(locationCallback: locationCallback),
      builder:
          (controller) => GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              backgroundColor: LNDColors.white,
              appBar: AppBar(
                leading: LNDButton.close(),
                title: LNDText.bold(text: 'Custom Location', fontSize: 18.0),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GooglePlaceAutoCompleteTextField(
                      focusNode: focusNode,
                      textEditingController: controller.locationController,
                      googleAPIKey: dotenv.env['GOOGLE_MAPS_PLACES_API_KEY']!,
                      isLatLngRequired: true,
                      textStyle: LNDText.regularStyle,
                      containerVerticalPadding: 0.0,
                      boxDecoration: const BoxDecoration(
                        borderRadius: BorderRadius.zero,
                      ),
                      inputDecoration: LNDTextField.inputDecoration(
                        hintText: 'Your location here...',
                        borderRadius: 0.0,
                        suffixIcon: (Icons.close),
                        onTapSuffix: () {
                          controller.clearLocation();
                        },
                      ),
                      isCrossBtnShown: false,
                      getPlaceDetailWithLatLng: (prediction) {
                        controller.updateCameraWithMarker(
                          LatLng(
                            double.tryParse(prediction.lat ?? '') ?? 0.0,
                            double.tryParse(prediction.lng ?? '') ?? 0.0,
                          ),
                        );
                      },
                      itemClick: (prediction) {
                        controller.locationController.text =
                            prediction.description ?? '';
                        controller.setAddressDetails(prediction);

                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      itemBuilder: (_, __, prediction) {
                        return ListTile(
                          title: LNDText.regular(
                            text: prediction.description ?? '',
                            fontSize: 12.0,
                            color: LNDColors.black,
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Obx(
                          () => GoogleMap(
                            buildingsEnabled: false,
                            initialCameraPosition:
                                controller.cameraPosition.value,
                            onMapCreated: controller.onMapCreated,
                            markers: controller.marker.toSet(),
                            circles: controller.circle.toSet(),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomGesturesEnabled: true,
                            scrollGesturesEnabled: true,
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          right: 10.0,
                          child: LNDButton.widget(
                            color: LNDColors.outline,
                            borderRadius: 8.0,
                            size: 30.0,
                            onPressed: () {
                              controller.getToCurrentLocation();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            child: const Icon(
                              Icons.near_me_outlined,
                              color: LNDColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        PostSwitchFieldW(
                          label: 'Use specific location',
                          subtitle:
                              'The exact location will be displayed on the map',
                          icon: Icons.location_searching_rounded,
                          value: controller.useSpecificLocation,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 24.0,
                            right: 24.0,
                            top: 8.0,
                          ),
                          child: LNDButton.primary(
                            text: 'Apply',
                            enabled: true,
                            onPressed: controller.applyLocation,
                            hasPadding: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
