import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';

mixin AuthMixin {
  Rxn<User> get firebaseUser => AuthController.instance.firebaseUser;
  bool get isAuthenticated => firebaseUser.value != null;
  bool isCurrentUser(uid) => AuthController.instance.uid == uid;

  /// Check if the user is authenticated.
  /// If not, redirect to the SigninPage
  bool checkAuth() {
    if (!isAuthenticated) {
      Get.toNamed(SigninPage.routeName);

      return false;
    }
    return true;
  }
}
