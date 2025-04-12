import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationCallbackModel {
  final String? address;
  final LatLng? latLng;

  LocationCallbackModel({this.address, this.latLng});
}

class LocationPickerController extends GetxController {
  final LocationCallbackModel? locationCallback;
  LocationPickerController({this.locationCallback});

  static final LocationPickerController instance =
      Get.find<LocationPickerController>();

  final locationController = TextEditingController();

  final _zoomLevel = 14.0;

  Rx<CameraPosition> cameraPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 14.0).obs;

  final Rx<LatLng> _currentPosition = const LatLng(0, 0).obs;

  final Rx<LatLng?> _pinnedPosition = Rx(null);

  final marker = <Marker>{}.obs;

  GoogleMapController? mapController;

  @override
  void onClose() {
    locationController.dispose();
    mapController?.dispose();
    cameraPosition.close();
    _currentPosition.close();
    _pinnedPosition.close();
    marker.close();

    super.onClose();
  }

  @override
  void onReady() {
    if (locationCallback != null) {
      _setInitialValues();
    } else {
      getToCurrentLocation();
    }
    super.onReady();
  }

  void _setInitialValues() {
    if (locationCallback != null) {
      locationController.text = locationCallback?.address ?? '';

      if (locationCallback?.latLng != null) {
        updateCameraWithMarker(
          LatLng(
            locationCallback?.latLng?.latitude ?? 0.0,
            locationCallback?.latLng?.longitude ?? 0.0,
          ),
        );
      } else {
        getToCurrentLocation();
      }
    }
  }

  Future<void> getToCurrentLocation() async {
    try {
      // Request permission first
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          _showPermissionDeniedMessage();
          return;
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Update camera position
      cameraPosition.value = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: _zoomLevel,
      );

      // Update current location
      _currentPosition.value = LatLng(position.latitude, position.longitude);

      // If map is already created, animate to the position
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(cameraPosition.value),
        );
      }
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    // If we already have location, move camera to it
    if (cameraPosition.value.target.latitude != 0) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition.value),
      );
    }
  }

  void updateCameraWithMarker(LatLng latLng) {
    // Clear previous markers
    marker.clear();
    // Add new marker
    marker.add(
      Marker(markerId: const MarkerId('selected-location'), position: latLng),
    );

    // Update camera position
    cameraPosition.value = CameraPosition(target: latLng, zoom: _zoomLevel);

    // Animate camera to new position
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition.value),
    );

    _pinnedPosition.value = latLng;
  }

  void _showPermissionDeniedMessage() {
    LNDShow.alertDialog(
      title: 'Location Access Denied',
      content:
          'You have previously denied location access. Please go to Settings '
          'to enable it.',
      cancelText: 'Close',
      confirmText: 'Settings',
      onConfirm: () async {
        final canOpen = await openAppSettings();

        if (!canOpen) {
          LNDSnackbar.showWarning(
            "Unable to open app settings. Open phone's settings and enable "
            'location access manually.',
          );
        }
      },
    );
  }

  void clearLocation() {
    locationController.clear();
    marker.clear();
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _currentPosition.value, zoom: _zoomLevel),
      ),
    );
  }

  void applyLocation() {
    // Logic to apply the selected location
    // For example, you might want to save the location or update the UI
    Get.back<LocationCallbackModel>(
      result:
          locationController.text.isNotEmpty
              ? LocationCallbackModel(
                address: locationController.text,
                latLng:
                    _pinnedPosition.value == null
                        ? null
                        : LatLng(
                          _pinnedPosition.value?.latitude ?? 0.0,
                          _pinnedPosition.value?.longitude ?? 0.0,
                        ),
              )
              : null,
    );
  }
}
