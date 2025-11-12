import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/core/models/simple_asset.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/availability.enum.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class YourListingController extends GetxController with AuthMixin {
  static YourListingController get instance =>
      Get.find<YourListingController>();

  final RxBool _isMyAssetsLoading = false.obs;
  bool get isMyAssetsLoading => _isMyAssetsLoading.value;

  final RxList<SimpleAsset> _myAssets = <SimpleAsset>[].obs;
  List<SimpleAsset> get myAssets => _myAssets;

  String get availableAssets =>
      _myAssets
          .where((asset) => asset.status == Availability.available.label)
          .length
          .toString();
  String get underMaintenanceAssets =>
      _myAssets
          .where((asset) => asset.status == Availability.underMaintenance.label)
          .length
          .toString();
  String get hiddenAssets =>
      _myAssets
          .where((asset) => asset.status == Availability.hidden.label)
          .length
          .toString();

  @override
  void onClose() {
    _isMyAssetsLoading.close();
    _myAssets.close();

    super.onClose();
  }

  Future<void> getMyAssets() async {
    try {
      _myAssets.clear();
      _isMyAssetsLoading.value = true;

      // Get users/doc/assets documents
      final assetsDocs =
          await FirebaseFirestore.instance
              .collection(LNDCollections.users.name)
              .doc(AuthController.instance.uid)
              .collection(LNDCollections.assets.name)
              .get();

      if (assetsDocs.docs.isNotEmpty) {
        final List<SimpleAsset> assetsList = [];

        for (var doc in assetsDocs.docs) {
          // Get assets/doc/bookings documents
          final bookingsDocs =
              await FirebaseFirestore.instance
                  .collection(LNDCollections.assets.name)
                  .doc(doc.id)
                  .collection(LNDCollections.bookings.name)
                  .get();
          if (bookingsDocs.docs.isNotEmpty) {
            final List<Booking> bookingsList = [];

            for (var bookingDoc in bookingsDocs.docs) {
              bookingsList.add(Booking.fromMap(bookingDoc.data()));
            }

            // Insert the bookings data to SimpleAsset data model
            final assetData = doc.data();
            assetData['bookings'] = bookingsList.where(
              (booking) => booking.status == BookingStatus.pending,
            );
            assetsList.add(SimpleAsset.fromMap(assetData));
          } else {
            assetsList.add(SimpleAsset.fromMap(doc.data()));
          }
        }

        _myAssets.assignAll(assetsList);
      }
      _isMyAssetsLoading.value = false;
    } catch (e, st) {
      _isMyAssetsLoading.value = false;
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  void goToMyAssets(BuildContext context) {
    LNDNavigate.toMyAssetPage(context, withNavbar: true);
  }

  void goToAssetPage(SimpleAsset asset) {
    LNDNavigate.toAssetPage(args: Asset.fromMap(asset.toMap()));
  }

  void goToPostListing() {
    LNDNavigate.toPostListing(args: null);
  }
}
