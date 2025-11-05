import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lend/core/bindings/asset/asset.binding.dart';
import 'package:lend/core/bindings/calendar_bookings/calendar_bookings.binding.dart';
import 'package:lend/core/bindings/calendar_picker/calendar_picker.binding.dart';
import 'package:lend/core/bindings/chat/chat.binding.dart';
import 'package:lend/core/bindings/navigation/navigation.binding.dart';
import 'package:lend/core/bindings/post_listing/post_listing.binding.dart';
import 'package:lend/core/bindings/profile_view/profile_view.binding.dart';
import 'package:lend/core/bindings/root.binding.dart';
import 'package:lend/core/bindings/signin/signin.binding.dart';
import 'package:lend/core/bindings/signup/signup.binding.dart';
import 'package:lend/core/middlewares/auth.middleware.dart';
import 'package:lend/core/middlewares/listing_eligible.middleware.dart';
import 'package:lend/core/middlewares/rent_eligible.middleware.dart';
import 'package:lend/core/services/main.service.dart';
import 'package:lend/presentation/pages/asset/asset.page.dart';
import 'package:lend/presentation/pages/calendar_bookings/calendar_bookings.page.dart';
import 'package:lend/presentation/pages/calendar_picker/calendar_picker.page.dart';
import 'package:lend/presentation/pages/chat/chat.page.dart';
import 'package:lend/presentation/pages/eligibility/eligibility.page.dart';
import 'package:lend/presentation/pages/loading_overlay/loading_overlay.page.dart';
import 'package:lend/presentation/pages/navigation/components/messages/components/archived_messages.page.dart';
import 'package:lend/presentation/pages/profile_view/profile_view.page.dart';
import 'package:lend/presentation/pages/your_listing/your_listing.page.dart';
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
  await GetStorage.init();
  // GetStorage().erase();
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
        primaryColor: LNDColors.primary,
      ),
      builder: (_, child) {
        return LoadingOverlay(child: child ?? const SizedBox.shrink());
      },
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
          name: CalendarPickerPage.routeName,
          page: () => const CalendarPickerPage(),
          preventDuplicates: false,
          binding: CalendarPickerBinding(),
          middlewares: [AuthMiddleware(), RentEligibleMiddleware()],
        ),
        GetPage(
          name: CalendarBookingsPage.routeName,
          page: () => const CalendarBookingsPage(),
          preventDuplicates: false,
          binding: CalendarBookingsBinding(),
          middlewares: [AuthMiddleware(), ListingEligibleMiddleware()],
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
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: AddShowcasePage.routeName,
          page: () => const AddShowcasePage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: YourListingPage.routeName,
          page: () => const YourListingPage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: ChatPage.routeName,
          page: () => const ChatPage(),
          binding: ChatBinding(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: ArchivedMessagePage.routeName,
          page: () => const ArchivedMessagePage(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: EligibilityPage.routeName,
          page: () => const EligibilityPage(),
        ),
        GetPage(
          name: ProfileViewPage.routeName,
          page: () => const ProfileViewPage(),
          binding: ProfileViewBinding(),
          middlewares: [AuthMiddleware()],
        ),
      ],
      initialRoute: NavigationPage.routeName,
    );
  }
}
