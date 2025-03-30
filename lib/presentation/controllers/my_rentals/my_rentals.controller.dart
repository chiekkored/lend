import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class MyRentalsController extends GetxController with AuthMixin {
  static MyRentalsController get instance => Get.find<MyRentalsController>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxList<Booking> _myRentals = <Booking>[].obs;
  List<Booking> get myRentals => _myRentals;

  Future<void> getMyRentals({required String? userId}) async {
    _isLoading.value = true;
    final bookingsDocs =
        await FirebaseFirestore.instance
            .collection(LNDCollections.users.name)
            .doc(userId)
            .collection(LNDCollections.bookings.name)
            .get();

    if (bookingsDocs.docs.isNotEmpty) {
      final rentalsList =
          bookingsDocs.docs.map((e) => Booking.fromMap(e.data())).toList();

      _myRentals.assignAll(rentalsList);
      _isLoading.value = false;
    }
  }

  void goToAsset(Asset? asset) {
    LNDNavigate.toAssetPage(args: asset);
  }

  void goToPostListing() {
    LNDNavigate.toPostListing(args: null);
  }
}
