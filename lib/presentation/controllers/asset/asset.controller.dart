import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/availability.model.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/controllers/home/home.controller.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/presentation/pages/asset/widgets/all_prices.widget.dart';
import 'package:lend/presentation/pages/photo_view/photo_view.page.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class AssetController extends GetxController {
  static final instance = Get.find<AssetController>();

  final Rx<Asset?> _asset = Rx<Asset?>(Get.arguments as Asset?);
  Asset? get asset => _asset.value;

  final RxBool _isAssetLoading = false.obs;
  bool get isAssetLoading => _isAssetLoading.value;

  final RxBool _isUserLoading = false.obs;
  bool get isUserLoading => _isUserLoading.value;

  final Rxn<UserModel> _user = Rxn();
  UserModel? get user => _user.value;

  final _mapController = Rxn<GoogleMapController>();
  GoogleMapController? get mapController => _mapController.value;

  final markers = <Circle>{}.obs;

  final RxString _address = ''.obs;
  String get address => _address.value;

  final RxList<DateTime> _selectedDates = <DateTime>[].obs;
  List<DateTime> get selectedDates => _selectedDates;

  final RxInt _totalPrice = 0.obs;
  int get totalPrice => _totalPrice.value;

  CameraPosition get cameraPosition => CameraPosition(
    target: LatLng(
      asset?.location?.latitude ?? 0.0,
      asset?.location?.longitude ?? 0.0,
    ),
    zoom: 13,
  );

  @override
  void onInit() {
    if (asset?.description == null) {
      getAsset();
    }
    _getUser();

    super.onInit();
  }

  @override
  void onClose() {
    _asset.close();
    markers.close();

    _mapController.close();
    _isUserLoading.close();
    _address.close();
    _user.close();
    _selectedDates.close();

    super.onClose();
  }

  Future<void> refreshAsset() async {
    try {
      final assetsCollection = FirebaseFirestore.instance.collection(
        LNDCollections.assets.name,
      );

      final result = await assetsCollection.doc(asset?.id).get();

      if (result.exists) {
        HomeController.instance.updateAsset(Asset.fromMap(result.data()!));
      }
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  Future<void> getAsset() async {
    try {
      _isAssetLoading.value = true;
      final assetsCollection = FirebaseFirestore.instance.collection(
        LNDCollections.assets.name,
      );

      final result = await assetsCollection.doc(asset?.id).get();

      if (result.exists) {
        _asset.value = Asset.fromMap(result.data()!);
        _isAssetLoading.value = false;
      } else {
        LNDSnackbar.showError('Product unavailable');
        Get.back();
      }
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  void onMapCreated(GoogleMapController mapCtrl) {
    _mapController.value = mapCtrl;

    markers.add(
      Circle(
        circleId: const CircleId('current_location_circle'),
        center: cameraPosition.target,
        radius: 500,
        fillColor: Colors.blue.withValues(alpha: 0.5),
        strokeColor: Colors.blue,
        strokeWidth: 1,
      ),
    );

    _getAddressFromLatLng(cameraPosition.target);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _address.value =
            '${place.street}, ${place.locality}, ${place.isoCountryCode}';
      } else {
        _address.value = "No address found";
      }
    } catch (e, st) {
      _address.value = 'No address found';
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  void _getUser() async {
    try {
      _isUserLoading.value = true;

      final usersCollection = FirebaseFirestore.instance.collection(
        LNDCollections.users.name,
      );

      final result = await usersCollection.doc(asset?.ownerId ?? '').get();

      if (result.data() != null) {
        _user.value = UserModel.fromMap(result.data()!);
        _isUserLoading.value = false;
      }
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  void openAllPrices() async {
    LNDShow.bottomSheet(const AssetAllPricesSheet(), enableDrag: false);
  }

  void goToReservation() async {
    await LNDNavigate.toCalendar();
    _selectedDates.clear();
  }

  void onCalendarChanged(List<DateTime> dates) async {
    if (dates.first == dates.last) {
      _selectedDates.value = [dates.last];
      return;
    }

    if (asset?.availability?.any(
          (av) =>
              !av.date.toDate().isBefore(dates.first) &&
              !av.date.toDate().isAfter(dates.last),
        ) ??
        false) {
      _selectedDates.value = [dates.last];
    } else {
      _selectedDates.value = dates;
    }
    calculateTotalPrice();
  }

  void calculateTotalPrice() {
    if (selectedDates.length < 2 || selectedDates.first == selectedDates.last) {
      _totalPrice.value = 0;
    }

    int totalPrice = 0;
    DateTime startDate = selectedDates.first;
    DateTime endDate = selectedDates.last;
    int totalDays = endDate.difference(startDate).inDays;

    if (asset?.rates?.annually != null && totalDays >= 365) {
      totalPrice += asset?.rates?.annually ?? 0;
      int remainingDays = totalDays - 365;
      if (remainingDays > 0) {
        // For simplicity, we'll apply daily rate for extra days beyond a year
        if (asset?.rates?.daily != null) {
          totalPrice += remainingDays * (asset?.rates?.daily ?? 0);
        }
      }
      _totalPrice.value = totalPrice;
    }

    DateTime currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      if (asset?.rates?.monthly != null) {
        DateTime nextMonth = DateTime(
          currentDate.year,
          currentDate.month + 1,
          currentDate.day,
        );
        if (!nextMonth.isAfter(endDate)) {
          totalPrice += asset?.rates?.monthly ?? 0;
          currentDate = nextMonth;
          continue;
        }
      }

      if (asset?.rates?.weekly != null) {
        DateTime nextWeek = currentDate.add(const Duration(days: 7));
        if (!nextWeek.isAfter(endDate)) {
          totalPrice += asset?.rates?.weekly ?? 0;
          currentDate = nextWeek;
          continue;
        }
      }

      if (asset?.rates?.daily != null) {
        totalPrice += asset?.rates?.daily ?? 0;
      }
      currentDate = currentDate.add(const Duration(days: 1));
    }

    _totalPrice.value = totalPrice;
  }

  void bookAsset() async {
    if (selectedDates.length < 2 || selectedDates.first == selectedDates.last) {
      return;
    }
    try {
      LNDLoading.show();

      final List<Availability> dates = [];
      final start = selectedDates.first;
      final end = selectedDates.last;
      DateTime currentDate = start;

      while (currentDate.isBefore(end)) {
        dates.add(
          Availability(
            date: Timestamp.fromDate(currentDate),
            userId: ProfileController.instance.user?.uid,
            firstName: ProfileController.instance.user?.firstName,
            lastName: ProfileController.instance.user?.lastName,
          ),
        );
        currentDate = currentDate.add(const Duration(days: 1));
      }

      final batch = FirebaseFirestore.instance.batch();
      final assetsCollection = FirebaseFirestore.instance.collection(
        LNDCollections.assets.name,
      );
      final bookingsCollection = FirebaseFirestore.instance
          .collection(LNDCollections.users.name)
          .doc(AuthController.instance.uid)
          .collection(LNDCollections.bookings.name);

      final newAvailability = {
        'availability': FieldValue.arrayUnion(
          dates.map((d) => d.toMap()).toList(),
        ),
      };

      batch.update(assetsCollection.doc(asset?.id), newAvailability);

      batch.set(
        bookingsCollection.doc(),
        Booking(
          asset: Asset(
            id: asset?.id ?? '',
            ownerId: asset?.ownerId,
            title: asset?.title,
            images: asset?.images,
            category: asset?.category,
          ),
          dates: dates.map((d) => d.date).toList(),
          createdAt: Timestamp.now(),
          payment: Payment(method: 'debit', transactionId: '123456'),
          renterId: AuthController.instance.uid,
          status: BookingStatus.confirmed.label,
          totalPrice: totalPrice,
        ).toMap(),
      );

      await batch.commit();

      await refreshAsset();

      LNDLoading.hide();
      Get.until((page) => page.isFirst);
    } catch (e, st) {
      LNDLoading.hide();
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  bool checkAvailability(DateTime date) =>
      !(asset?.availability?.any((av) => av.date.toDate() == date) ?? true);

  void addBookmark() async {
    if (AuthController.instance.isAuthenticated) return;
  }

  void openPhotoShowcase(int index) {
    LNDNavigate.toPhotoView(
      args: PhotoViewArguments(
        images: asset?.showcase ?? [],
        intialIndex: index,
      ),
    );
  }

  void openPhotoAsset(int index) {
    LNDNavigate.toPhotoView(
      args: PhotoViewArguments(images: asset?.images ?? [], intialIndex: index),
    );
  }
}
