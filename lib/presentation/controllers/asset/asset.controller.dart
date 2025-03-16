import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/utilities/constants/collections.constant.dart';

class AssetController extends GetxController {
  static final instance = Get.find<AssetController>();

  Asset? asset = Get.arguments['asset'];

  final RxBool _isUserLoading = false.obs;
  final Rx<User?> _user = Rx(null);

  bool get isUserLoading => _isUserLoading.value;
  User? get user => _user.value;

  @override
  void onReady() {
    _getUser();

    super.onReady();
  }

  @override
  void onClose() {
    _isUserLoading.close();

    super.onClose();
  }

  void _getUser() async {
    _isUserLoading.value = true;

    final usersCollection =
        FirebaseFirestore.instance.collection(LNDCollections.users);

    final result = await usersCollection.doc(asset?.ownerId ?? '').get();

    if (result.data() != null) {
      debugPrint('result.data(): ${result.data()}');
      _user.value = User.fromMap(result.data()!);
      _isUserLoading.value = false;
    }
  }
}
