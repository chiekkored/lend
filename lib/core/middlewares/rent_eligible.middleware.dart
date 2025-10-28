import 'package:get/get.dart';
import 'package:lend/presentation/controllers/profile/profile.controller.dart';
import 'package:lend/presentation/pages/eligibility/eligibility.page.dart';

class RentEligibleMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    final isRentingEligible = ProfileController.instance.isRentingEligible;
    if (!isRentingEligible) {
      return GetPage(
        name: EligibilityPage.routeName,
        page: () => const EligibilityPage(),
        fullscreenDialog: true,
      );
    }
    return super.onPageCalled(page);
  }
}
