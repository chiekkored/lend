import 'package:get/get.dart';
import 'package:lend/core/bindings/signin/signin.binding.dart';
import 'package:lend/presentation/controllers/auth/auth.controller.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    final isAuthenticated = AuthController.instance.uid != null;
    if (!isAuthenticated) {
      return GetPage(
        name: SigninPage.routeName,
        page: () => const SigninPage(),
        binding: SigninBinding(),
        fullscreenDialog: true,
      );
    }
    return super.onPageCalled(page);
  }
}
