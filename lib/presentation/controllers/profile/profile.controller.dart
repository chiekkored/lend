import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class ProfileController extends GetxController with AuthMixin {
  static ProfileController get instance => Get.find<ProfileController>();

  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  void getUserData() async {
    _isLoading.value = true;

    final userCollection = FirebaseFirestore.instance
        .collection(LNDCollections.users.name)
        .doc(AuthController.instance.uid);

    final userDoc = await userCollection.get();

    if (userDoc.exists) {
      _user.value = UserModel.fromMap(userDoc.data()!);
      _isLoading.value = false;
    } else {
      LNDLogger.e('Could not get user data', stackTrace: StackTrace.current);
      signOut();
    }
  }

  void signOut() {
    AuthController.instance.signOut();
  }
}
