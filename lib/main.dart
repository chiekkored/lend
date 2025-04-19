import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:lend/core/bindings/asset/asset.binding.dart';
import 'package:lend/core/bindings/navigation/navigation.binding.dart';
import 'package:lend/core/bindings/post_listing/post_listing.binding.dart';
import 'package:lend/core/bindings/root.binding.dart';
import 'package:lend/core/bindings/signin/signin.binding.dart';
import 'package:lend/core/bindings/signup/signup.binding.dart';
import 'package:lend/core/middlewares/auth.middleware.dart';
import 'package:lend/core/services/main.service.dart';
import 'package:lend/presentation/pages/asset/asset.page.dart';
import 'package:lend/presentation/pages/calendar/calendar.page.dart';
import 'package:lend/presentation/pages/your_listing/you_listing.page.dart';
import 'package:lend/presentation/pages/navigation/navigation.page.dart';
import 'package:lend/presentation/pages/photo_view/photo_view.page.dart';
import 'package:lend/presentation/pages/post_listing/post_listing.page.dart';
import 'package:lend/presentation/pages/post_listing/components/add_showcase.page.dart';
import 'package:lend/presentation/pages/product_showcase/product_showcase.page.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';
import 'package:lend/presentation/pages/signup/components/setup.page.dart';
import 'package:lend/presentation/pages/signup/signup.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MainService.initializeFirebase();
  await dotenv.load(fileName: '.env');

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: LNDColors.outline,
        splashFactory: NoSplash.splashFactory,
        fontFamily: 'Inter',
      ),
      initialBinding: RootBinding(),
      getPages: [
        GetPage(
          name: NavigationPage.routeName,
          page: () => const NavigationPage(),
          binding: NavigationBinding(),
        ),
        GetPage(
          name: AssetPage.routeName,
          page: () => const AssetPage(),
          binding: AssetBinding(),
          preventDuplicates: false,
        ),
        GetPage(
          name: CalendarPage.routeName,
          page: () => const CalendarPage(),
          preventDuplicates: false,
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: SigninPage.routeName,
          page: () => const SigninPage(),
          binding: SigninBinding(),
          fullscreenDialog: true,
        ),
        GetPage(
          name: SignUpPage.routeName,
          page: () => const SignUpPage(),
          binding: SignupBinding(),
        ),
        GetPage(name: SetupPage.routeName, page: () => const SetupPage()),
        GetPage(
          name: PhotoViewPage.routeName,
          page: () => const PhotoViewPage(),
          fullscreenDialog: true,
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: ProductShowcasePage.routeName,
          page: () => ProductShowcasePage(),
        ),
        GetPage(
          name: PostListingPage.routeName,
          page: () => const CupertinoScaffold(body: PostListingPage()),
          binding: PostListingBinding(),
          fullscreenDialog: true,
        ),
        GetPage(
          name: AddShowcasePage.routeName,
          page: () => const AddShowcasePage(),
        ),
        GetPage(
          name: YourListingPage.routeName,
          page: () => const YourListingPage(),
        ),
      ],
      initialRoute: NavigationPage.routeName,
    );
  }
}
