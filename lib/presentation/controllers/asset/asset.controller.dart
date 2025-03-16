import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/utilities/constants/collections.constant.dart';

class AssetController extends GetxController {
  static final instance = Get.find<AssetController>();

  Asset? asset = Get.arguments['asset'];

  final RxBool _isUserLoading = false.obs;
  final Rxn<User> _user = Rxn();

  final _mapController = Rxn<GoogleMapController>();
  final markers = <Circle>{}.obs;
  final RxString _address = ''.obs;

  bool get isUserLoading => _isUserLoading.value;
  User? get user => _user.value;

  GoogleMapController? get mapController => _mapController.value;
  CameraPosition get cameraPosition => CameraPosition(
      target: LatLng(
          asset?.location?.latitude ?? 0.0, asset?.location?.longitude ?? 0.0),
      zoom: 13);
  String get address => _address.value;

  @override
  void onInit() {
    _getUser();

    super.onInit();
  }

  @override
  void onClose() {
    markers.close();

    _mapController.close();
    _isUserLoading.close();
    _address.close();
    _user.close();

    super.onClose();
  }

  void onMapCreated(GoogleMapController mapCtrl) {
    _mapController.value = mapCtrl;

    markers.add(
      Circle(
        circleId: const CircleId('current_location_circle'),
        center: cameraPosition.target,
        radius: 500, // Radius in meters
        fillColor: Colors.blue.withOpacity(0.5),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ),
    );

    _getAddressFromLatLng(cameraPosition.target);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _address.value =
            "${place.street}, ${place.locality}, ${place.isoCountryCode}";
      } else {
        _address.value = "No address found";
      }
    } catch (e) {
      _address.value = "Error: $e";
    }
  }

  void _getUser() async {
    _isUserLoading.value = true;

    final usersCollection =
        FirebaseFirestore.instance.collection(LNDCollections.users);

    final result = await usersCollection.doc(asset?.ownerId ?? '').get();

    if (result.data() != null) {
      _user.value = User.fromMap(result.data()!);
      _isUserLoading.value = false;
    }
  }
}
