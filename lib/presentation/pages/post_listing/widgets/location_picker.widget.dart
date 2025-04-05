import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/location_picker/location_picker.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LocationPickerW extends StatelessWidget {
  const LocationPickerW({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: LocationPickerController(),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0.0,
                      vertical: 8.0,
                    ),
                    child: GooglePlaceAutoCompleteTextField(
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
                    child: Obx(
                      () => GoogleMap(
                        buildingsEnabled: false,
                        initialCameraPosition: controller.cameraPosition.value,
                        onMapCreated: controller.onMapCreated,
                        markers: controller.marker.toSet(),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        zoomGesturesEnabled: true,
                        scrollGesturesEnabled: true,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: LNDButton.primary(
                        text: 'Apply',
                        enabled: true,
                        onPressed: () {},
                        hasPadding: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
