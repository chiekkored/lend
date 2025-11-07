import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';
import 'package:lend/core/mixins/scroll.mixin.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/enums/booking_status.enum.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class MyRentalsController extends GetxController
    with AuthMixin, LNDScrollMixin {
  static MyRentalsController get instance => Get.find<MyRentalsController>();

  final RxBool _isMyRentalsLoading = false.obs;
  bool get isMyRentalsLoading => _isMyRentalsLoading.value;

  final RxList<Booking> _myRentals = <Booking>[].obs;
  List<Booking> get myRentals => _myRentals;

  final RxList<Booking> _onGoingRentals = <Booking>[].obs;
  List<Booking> get onGoingRentals => _onGoingRentals;

  StreamSubscription? _rentalsSubscription;

  @override
  void onClose() {
    _isMyRentalsLoading.close();
    _myRentals.close();

    super.onClose();
  }

  void cancelSubscriptions() {
    if (_rentalsSubscription != null) {
      _rentalsSubscription?.cancel();
      LNDLogger.dNoStack('🔴 Rentals Subscription Cancelled');
    }
  }

  void listenToRentals() {
    final userId = AuthController.instance.uid;

    try {
      cancelSubscriptions();

      final now = DateTime.now().add(const Duration(days: 2));
      final todayMidnight = DateTime(now.year, now.month, now.day);

      final todayTimestamp = Timestamp.fromDate(todayMidnight);

      LNDLogger.dNoStack('🟢 Rentals Subscription Started');
      _rentalsSubscription = FirebaseFirestore.instance
          .collection(LNDCollections.users.name)
          .doc(userId)
          .collection(LNDCollections.bookings.name)
          .where('dates', arrayContains: todayTimestamp)
          .where('status', isEqualTo: BookingStatus.confirmed.label)
          .snapshots()
          .listen(
            (snapshot) {
              final List<Booking> bookingList = [];

              for (var doc in snapshot.docs) {
                final booking = Booking.fromMap(doc.data());
                bookingList.add(booking);
              }

              _onGoingRentals.value = bookingList;
            },
            onError: (e, st) {
              LNDLogger.e(
                'Error listening to rentals',
                error: e,
                stackTrace: st,
              );
            },
          );
    } catch (e, st) {
      LNDLogger.e('Error setting up rental listener', error: e, stackTrace: st);
    }
  }

  Future<void> getMyRentals({bool showLoading = true}) async {
    try {
      if (showLoading) _isMyRentalsLoading.value = true;

      final bookingsDocs =
          await FirebaseFirestore.instance
              .collection(LNDCollections.users.name)
              .doc(AuthController.instance.uid)
              .collection(LNDCollections.bookings.name)
              .get();

      final rentalsList =
          bookingsDocs.docs.map((e) => Booking.fromMap(e.data())).toList();

      _myRentals.assignAll(rentalsList);
      _isMyRentalsLoading.value = false;
    } catch (e, st) {
      LNDLogger.e(e.toString(), error: e, stackTrace: st);
    }
  }

  Future<void> refreshMyRentals() async {
    _myRentals.clear();
    await getMyRentals();
  }

  void goToAsset(Asset? asset) {
    LNDNavigate.toAssetPage(args: asset);
  }
}
