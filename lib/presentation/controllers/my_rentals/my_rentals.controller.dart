import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';
import 'package:lend/core/mixins/scroll.mixin.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/booking.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class MyRentalsController extends GetxController
    with AuthMixin, LNDScrollMixin {
  static MyRentalsController get instance => Get.find<MyRentalsController>();

  final RxBool _isMyRentalsLoading = false.obs;
  bool get isMyRentalsLoading => _isMyRentalsLoading.value;

  final RxList<Booking> _myRentals = <Booking>[].obs;
  List<Booking> get myRentals => _myRentals;

  @override
  void onClose() {
    _isMyRentalsLoading.close();
    _myRentals.close();

    super.onClose();
  }

  Future<void> getMyRentals() async {
    try {
      _isMyRentalsLoading.value = true;

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

  void goToAsset(Asset? asset) {
    LNDNavigate.toAssetPage(args: asset);
  }
}
