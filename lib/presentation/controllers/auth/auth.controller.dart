import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/core/services/get_storage.service.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/utilities/constants/collections.constant.dart';

class AuthController extends GetxController {
  static final instance = Get.find<AuthController>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // final LocalAuthentication auth = LocalAuthentication();

  // Observable User
  final Rxn<User> _firebaseUser = Rxn<User>();
  final RxString _token = ''.obs;

  /// Firebase User
  User? get firebaseUser => _firebaseUser.value;
  FirebaseAuth get firebaseAuth => _firebaseAuth;
  String get token => _token.value;
  String? get uid => firebaseUser?.uid;
  bool get isAuthenticated => _firebaseUser.value != null;

  @override
  void onInit() {
    // Listen to auth state changes
    _firebaseUser.bindStream(_firebaseAuth.authStateChanges());
    // ever(_firebaseUser, _handleAuthChanged);

    super.onInit();
  }

  @override
  void onClose() {
    _firebaseUser.close();
    _token.close();

    super.onClose();
  }

  /// Handle Auth State Changes for Screen Navigation
  // void _handleAuthChanged(User? user) async {
  //   try {
  //     // Future.delayed(const Duration(seconds: 3), () async {
  //     if (user == null) {
  //       Get.offAll(() => const SigninPage(), binding: SigninBinding());
  //     } else {
  //       _token.value = await user.getIdToken(true) ?? '';
  //       _startTokenCheck();

  //       if (user.emailVerified) {
  //         Get.offAll(
  //           () => const NavigationPage(),
  //           binding: NavigationBinding(),
  //         );
  //       } else {
  //         // Get.offAll(() => const VerificationPage());
  //       }
  //     }
  //     // });
  //   } catch (e, st) {
  //     LNDLogger.e(e.toString(), stackTrace: st);
  //     signOut();
  //   }
  // }

  /// Start periodic token check every 10 minutes
  // void _startTokenCheck() {
  //   _tokenCheckTimer?.cancel();
  //   _tokenCheckTimer = Timer.periodic(
  //     const Duration(minutes: 10),
  //     (timer) async => await _checkAndRefreshToken(),
  //   );
  // }

  // Future<void> _checkAndRefreshToken() async {
  //   try {
  //     User? user = _firebaseAuth.currentUser;

  //     if (user == null) {
  //       _tokenCheckTimer?.cancel();
  //       return; // No user is signed in
  //     }

  //     // Get the current ID token result
  //     IdTokenResult tokenResult = await user.getIdTokenResult();

  //     // Calculate the expiration time
  //     DateTime? expirationTime = tokenResult.expirationTime;
  //     if (expirationTime == null) return;

  //     // Check if the token is about to expire (e.g., within 5 minutes)
  //     Duration timeLeft = expirationTime.difference(DateTime.now());
  //     if (timeLeft.inMinutes <= 10) {
  //       _refreshToken();
  //     }
  //   } catch (e, st) {
  //     LNDLogger.e(e.toString(), stackTrace: st);
  //     signOut();
  //   }
  // }

  // void _refreshToken() async {
  //   _token.value = await _firebaseAuth.currentUser?.getIdToken(true) ?? '';
  //   // LNDLogger.iNoStack('Firebase Token Refreshed');
  // }

  // Sign Out
  Future<void> signOut() async {
    if (_firebaseAuth.currentUser == null) return;

    LNDLoading.show();

    await LNDStorageService.clear();
    _token.value = '';

    await _firebaseAuth.signOut();

    LNDLoading.hide();
    Get.until((page) => page.isFirst);
  }

  void resendEmailVerification() async {
    await firebaseUser?.sendEmailVerification();
  }

  Future<void> registerToFirestore({required UserModel user}) async {
    final userCollection = FirebaseFirestore.instance.collection(
      LNDCollections.users.name,
    );

    await userCollection.doc(user.uid).set(user.toMap());
  }

  // Future<bool> _biometricsCheck() async {
  //   final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  //   return canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  // }

  // Future<bool> authenticateBiometrics() async {
  //   try {
  //     final List<BiometricType> availableBiometrics =
  //         await auth.getAvailableBiometrics();

  //     if (availableBiometrics.isEmpty) {
  //       _showSecurityPopup();
  //     }

  //     if (await _biometricsCheck()) {
  //       return await auth.authenticate(
  //         localizedReason: 'Please authenticate to sign in to Spenza',
  //         authMessages: <AuthMessages>[
  //           IOSAuthMessages(
  //             goToSettingsButton: 'Settings',
  //             cancelButton: 'Cancel',
  //             goToSettingsDescription:
  //                 'Please enable Touch ID or Face ID in your device settings.',
  //           ),
  //           AndroidAuthMessages(
  //             goToSettingsButton: 'Settings',
  //             cancelButton: 'Close',
  //             goToSettingsDescription:
  //                 'Please enable biometrics in your device settings',
  //           ),
  //         ],
  //         options: AuthenticationOptions(
  //           useErrorDialogs: false,
  //           biometricOnly: true,
  //         ),
  //       );
  //     } else {
  //       return false;
  //     }
  //   } on PlatformException catch (e, st) {
  //     switch (e.code) {
  //       case 'NotAvailable':
  //         if (e.message == 'Biometry is not available.') {
  //           _showRequestPopup();
  //         } else {
  //           // LNDLogger.dNoStack(e.message ?? '', error: e);
  //         }
  //       default:
  //       // LNDLogger.e(e.message ?? '', error: e, stackTrace: st);
  //     }
  //     return false;
  //   } catch (e, st) {
  //     // LNDLogger.e(e.toString(), error: e, stackTrace: st);
  //     return false;
  //   }
  // }

  /// Shows popup from user's permanently disabled camera settings
  // void _showRequestPopup() {
  //   SPZPopup.alertDialog(
  //     title: Platform.isIOS ? 'Face ID Denied' : 'Biometrics Denied',
  //     content:
  //         'You have previously denied ${Platform.isIOS ? 'Face ID' : 'biometrics'} access. Please go to Settings '
  //         'to enable it.',
  //     cancelText: 'Close',
  //     confirmText: 'Settings',
  //     onConfirm: () async {
  //       final canOpen = await openAppSettings();

  //       if (!canOpen) {
  //         SPZBanner.showWarning(
  //           "Unable to open app settings. Open phone's settings and enable "
  //           "${Platform.isIOS ? 'Face ID' : 'biometrics'} access manually.",
  //         );
  //       }
  //     },
  //   );
  // }

  // /// Shows popup from user's permanently disabled camera settings
  // void _showSecurityPopup() {
  //   SPZPopup.alertDialog(
  //     title: Platform.isIOS ? 'Face ID Unavailable' : 'Biometrics Unavailable',
  //     content:
  //         '${Platform.isIOS ? 'Face ID' : 'Biometrics'} is not set up or unavailable. Please configure it in your device settings first.',
  //     cancelText: 'Close',
  //     confirmText: 'Settings',
  //     onConfirm: () {
  //       AppSettings.openAppSettings(
  //         type: AppSettingsType.lockAndPassword,
  //       );
  //     },
  //   );
  // }
}
