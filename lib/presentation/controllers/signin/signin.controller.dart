import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lend/core/models/user.model.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/utilities/enums/eligibility.enum.dart';
import 'package:lend/utilities/enums/user_types.enum.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/presentation/pages/signup/signup.page.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';

class SigninController extends GetxController {
  static final instance = Get.find<SigninController>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final RxBool _showObscureText = false.obs;
  bool get showObscureText => _showObscureText.value;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    _showObscureText.close();

    super.onClose();
  }

  void togglePasswordVisibility() => _showObscureText.toggle();

  Future<void> signIn() async {
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        return;
      }

      LNDLoading.show();

      final userCreds = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCreds.user != null) {
        _successSignin();
        // final storedEmail = await storage.read(key: 'email');

        // // If a another user logged in, remove the saved key value
        // if (storedEmail != null && storedEmail != emailText) {
        //   SPZSharedPrefsHelper.instance
        //       .remove(SPZSharedPrefsConstants.enableBiometrics);
        // }

        // storage.write(key: 'email', value: emailText);
        // storage.write(key: 'password', value: passwordText);
      }
    } on FirebaseAuthException catch (e, st) {
      // AppController.instance.setBiometricsButtonVisibility(false);
      LNDLoading.hide();

      if (e.code == 'user-not-found') {
        LNDLogger.e(e.message ?? '', error: e, stackTrace: st);

        LNDSnackbar.showError('User Not Found", "No user found for that email');
      } else if (e.code == 'invalid-email') {
        LNDSnackbar.showError('Invalid email provided');
      } else if (e.code == 'wrong-password') {
        LNDSnackbar.showError('Wrong password provided');
      } else if (e.code == 'network-request-failed') {
        LNDSnackbar.showWarning('Please check connection and try again');
      } else {
        LNDSnackbar.showError('Please try again later');
      }
    }
  }

  /// Sign in with Google Gmail
  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      LNDLoading.show();
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        LNDLoading.hide();
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );

      _checkUserCredential(userCredential);
    } on PlatformException catch (e, st) {
      LNDLoading.hide();
      if (e.details != '') {
        LNDSnackbar.showError(e.message ?? '');
      }
      LNDLogger.e(e.message ?? '', error: e, stackTrace: st);
    }
  }

  /// Sign in to Firebase authentication using Apple iCloud.
  Future<void> signInWithApple() async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      AuthorizationCredentialAppleID? appleCredential;
      try {
        LNDLoading.show();

        appleCredential = await SignInWithApple.getAppleIDCredential(
          webAuthenticationOptions: WebAuthenticationOptions(
            // clientId: dotenv.get('APPLE_CLIENT_ID'),
            clientId: '',
            redirectUri: Uri.parse(
              'https://spenza-recipe-app.firebaseapp.com/__/auth/handler',
            ),
          ),
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );
      } on SignInWithAppleAuthorizationException catch (e, st) {
        LNDLoading.hide();
        LNDLogger.e(e.message, error: e, stackTrace: st);
        LNDSnackbar.showError(e.message);
        return;
      }

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider(
        'apple.com',
      ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        oauthCredential,
      );

      _checkUserCredential(userCredential);
    } on PlatformException catch (e, st) {
      LNDLogger.e(e.message ?? '', error: e, stackTrace: st);
      LNDSnackbar.showError(e.message ?? '');
      return;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Navigate to the sign up page.
  void goToSignUp() {
    Get.toNamed(SignUpPage.routeName);
  }

  /// Check if the user is new or existing and navigate to the appropriate page.
  void _checkUserCredential(UserCredential userCredential) async {
    if (userCredential.user == null) {
      LNDSnackbar.showError(
        'Something went wrong. Please try another provider',
      );
      AuthController.instance.signOut();
      return;
    }

    if ((userCredential.additionalUserInfo?.isNewUser ?? false)) {
      final UserModel user = UserModel(
        uid: userCredential.user?.uid,
        firstName: userCredential.user?.displayName?.split(' ')[0] ?? '',
        lastName: userCredential.user?.displayName?.split(' ')[1] ?? '',
        dateOfBirth: null,
        location: null,
        photoUrl: userCredential.user?.photoURL ?? '',
        createdAt: Timestamp.now(),
        email: userCredential.user?.email ?? '',
        phone: userCredential.user?.phoneNumber ?? '',
        type: UserType.renter.label,
        isListingEligible: Eligibility.no,
        isRentingEligible: Eligibility.no,
      );

      await AuthController.instance.registerToFirestore(user: user);
    }
    _successSignin();
  }

  /// Navigate to the home page after successful sign in.
  void _successSignin() {
    // AppController.instance.setBiometricsButtonVisibility(true);
    LNDLoading.hide();
    // Get.offAll(() => const NavigationPage(), binding: NavigationBinding());

    Get.until((page) => page.isFirst);
  }
}
