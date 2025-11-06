import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationCallbackModel {
  final String address;
  final String country;
  final String cityState;
  final LatLng? latLng;
  final bool useSpecificLocation;

  LocationCallbackModel({
    required this.address,
    required this.country,
    required this.cityState,
    required this.latLng,
    required this.useSpecificLocation,
  });
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

  String country = '';
  String cityState = '';

  final marker = <Marker>{}.obs;
  final circle = <Circle>{}.obs;

  final RxBool useSpecificLocation = true.obs;

  GoogleMapController? mapController;

  @override
  void onClose() {
    locationController.dispose();
    mapController?.dispose();
    cameraPosition.close();
    _currentPosition.close();
    _pinnedPosition.close();
    marker.close();
    circle.close();
    useSpecificLocation.close();

    super.onClose();
  }

  @override
  void onInit() {
    ever(useSpecificLocation, (_) => _toggleLocationUsage());

    super.onInit();
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
      useSpecificLocation.value = locationCallback?.useSpecificLocation ?? true;
      country = locationCallback?.country ?? '';
      cityState = locationCallback?.cityState ?? '';

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
    _addMarker(latLng);

    // Update camera position
    cameraPosition.value = CameraPosition(target: latLng, zoom: _zoomLevel);

    // Animate camera to new position
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition.value),
    );

    _pinnedPosition.value = latLng;
  }

  void _addMarker(LatLng latLng) {
    // Clear previous markers
    marker.clear();
    circle.clear();

    // Add new marker or circle based on the useSpecificLocation value
    if (useSpecificLocation.isTrue) {
      // Add new marker
      marker.add(
        Marker(markerId: const MarkerId('selected-location'), position: latLng),
      );
    } else {
      // Add new circle
      circle.add(
        Circle(
          circleId: const CircleId('selected-location'),
          center: latLng,
          radius: 500,
          fillColor: Colors.blue.withValues(alpha: 0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
    }
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
    circle.clear();
    _pinnedPosition.value = null;
  }

  void _toggleLocationUsage() {
    if (_pinnedPosition.value != null) {
      _addMarker(_pinnedPosition.value!);
    }
  }

  void setAddressDetails(Prediction? prediction) {
    final addressDetails = prediction?.terms ?? [];
    List<Terms> lastTwo = addressDetails.sublist(addressDetails.length - 2);

    country = lastTwo.last.value ?? '';
    cityState = lastTwo.first.value ?? '';
  }

  void applyLocation() {
    Get.back<LocationCallbackModel>(
      result: LocationCallbackModel(
        address: locationController.text,
        country: country,
        cityState: cityState,
        useSpecificLocation: useSpecificLocation.value,
        latLng:
            _pinnedPosition.value == null
                ? null
                : LatLng(
                  _pinnedPosition.value?.latitude ?? 0.0,
                  _pinnedPosition.value?.longitude ?? 0.0,
                ),
      ),
    );
  }
}
