import 'package:get/get.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';

mixin AuthMixin {
  bool get isAuthenticated => AuthController.instance.firebaseUser != null;

  /// Check if the user is authenticated.
  /// If not, redirect to the SigninPage
  bool checkAuth() {
    if (AuthController.instance.firebaseUser == null) {
      Get.toNamed(SigninPage.routeName);

      return false;
    }
    return true;
  }
}
