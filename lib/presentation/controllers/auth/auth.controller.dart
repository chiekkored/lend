import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/core/services/get_storage.service.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/utilities/constants/collections.constant.dart';

class AuthController extends GetxController {
  static final instance = Get.find<AuthController>();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // final LocalAuthentication auth = LocalAuthentication();

  // Observable User
  final Rxn<User> firebaseUser = Rxn<User>();
  final RxString _token = ''.obs;

  String get token => _token.value;
  String? get uid => firebaseUser.value?.uid;
  bool get isAuthenticated => firebaseUser.value != null;

  @override
  void onInit() {
    // Listen to auth state changes
    firebaseUser.bindStream(firebaseAuth.authStateChanges());
    ever(firebaseUser, _handleAuthChanged);

    super.onInit();
  }

  @override
  void onClose() {
    firebaseUser.close();
    _token.close();

    super.onClose();
  }

  void _handleAuthChanged(User? user) {
    if (user != null) {
      ProfileController.instance.getUserData(user);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    if (firebaseAuth.currentUser == null) return;

    LNDLoading.show();

    await LNDStorageService.clear();
    _token.value = '';

    await firebaseAuth.signOut();

    LNDLoading.hide();
    Get.until((page) => page.isFirst);
  }

  void resendEmailVerification() async {
    await firebaseUser.value?.sendEmailVerification();
  }

  Future<void> registerToFirestore({required UserModel user}) async {
    final userCollection = FirebaseFirestore.instance.collection(
      LNDCollections.users.name,
    );

    await userCollection.doc(user.uid).set(user.toMap());
  }
}
