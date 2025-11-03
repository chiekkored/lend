import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:lend/core/mixins/auth.mixin.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class ProfileViewArgs {
  final UserModel user;

  ProfileViewArgs({required this.user});
}

class ProfileViewController extends GetxController with AuthMixin {
  static ProfileViewController get instance =>
      Get.find<ProfileViewController>();

  final ProfileViewArgs args = Get.arguments as ProfileViewArgs;

  final Rx<UserModel?> _user = Rx<UserModel?>(null);
  UserModel? get user => _user.value;

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onClose() {
    _isLoading.close();
    _user.close();

    super.onClose();
  }

  @override
  void onReady() {
    if (AuthController.instance.uid == args.user.uid) {
      _user.value = args.user;
    } else {
      _getProfile();
    }

    super.onReady();
  }

  Future<void> _getProfile() async {
    try {
      _isLoading.value = true;

      final userCollection = FirebaseFirestore.instance
          .collection(LNDCollections.users.name)
          .doc(args.user.uid);

      final userDoc = await userCollection.get();

      if (userDoc.exists) {
        _user.value = UserModel.fromMap(userDoc.data()!);
        _isLoading.value = false;
      } else {
        throw 'User does not exist';
      }
    } catch (e, st) {
      LNDLogger.e(e.toString(), stackTrace: st);
      Get.back();
      LNDSnackbar.showError('User does not exist');
    }
  }
}
