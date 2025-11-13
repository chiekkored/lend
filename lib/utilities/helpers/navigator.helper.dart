import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/core/models/chat.model.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/controllers/calendar_bookings/calendar_bookings.controller.dart';
import 'package:lend/presentation/controllers/calendar_picker/calendar_picker.controller.dart';
import 'package:lend/presentation/controllers/location_picker/location_picker.controller.dart';
import 'package:lend/presentation/controllers/profile_view/profile_view.controller.dart';
import 'package:lend/presentation/pages/asset/asset.page.dart';
import 'package:lend/presentation/pages/calendar_bookings/calendar_bookings.page.dart';
import 'package:lend/presentation/pages/calendar_picker/calendar_picker.page.dart';
import 'package:lend/presentation/pages/chat/chat.page.dart';
import 'package:lend/presentation/pages/navigation/components/messages/components/archived_messages.page.dart';
import 'package:lend/presentation/pages/navigation/navigation.page.dart';
import 'package:lend/presentation/pages/profile_view/profile_view.page.dart';
import 'package:lend/presentation/pages/qr_view/qr_view.page.dart';
import 'package:lend/presentation/pages/scan_qr/scan_qr.page.dart';
import 'package:lend/presentation/pages/token_view/token_view.page.dart';
import 'package:lend/presentation/pages/your_listing/your_listing.page.dart';
import 'package:lend/presentation/pages/photo_view/photo_view.page.dart';
import 'package:lend/presentation/pages/post_listing/post_listing.page.dart';
import 'package:lend/presentation/pages/post_listing/widgets/add_inclusions.widget.dart';
import 'package:lend/presentation/pages/post_listing/components/add_showcase.page.dart';
import 'package:lend/presentation/pages/post_listing/widgets/categories.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/location_picker.widget.dart';
import 'package:lend/presentation/pages/product_showcase/product_showcase.page.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';
import 'package:lend/presentation/pages/signup/signup.page.dart';
import 'package:lend/utilities/enums/categories.enum.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class LNDNavigate {
  LNDNavigate._();
  static final LNDNavigate _instance = LNDNavigate._();
  factory LNDNavigate() {
    return _instance;
  }

  static Future<T?>? toHomePage<T>() async {
    return await Get.offAllNamed(NavigationPage.routeName);
  }

  static Future<T?>? toSigninPage<T>() async {
    return await Get.toNamed(SigninPage.routeName);
  }

  static Future<T?>? toSignupPage<T>() async {
    return await Get.toNamed(SignUpPage.routeName);
  }

  static Future<T?>? toProfileViewPage<T>({
    required ProfileViewArgs args,
  }) async {
    return await Get.toNamed(ProfileViewPage.routeName, arguments: args);
  }

  static Future<T?>? toAssetPage<T>({required Asset? args}) async {
    return await Get.toNamed(AssetPage.routeName, arguments: args);
  }

  static Future<T?>? toScanQRPage<T>() async {
    return await Get.toNamed(ScanQRPage.routeName);
  }

  static Future<T?>? toTokenViewPage<T>({required TokenViewArgs args}) async {
    return await Get.toNamed(TokenViewPage.routeName, arguments: args);
  }

  static Future<T?>? toQRViewPage<T>({required String qrToken}) async {
    return await Get.toNamed(QRViewPage.routeName, arguments: qrToken);
  }

  static Future<T?>? toPhotoViewPage<T>({
    required PhotoViewArguments args,
  }) async {
    return await Get.toNamed(PhotoViewPage.routeName, arguments: args);
  }

  static Future<T?>? toProductShowcasePage<T>({
    required ProductShowcaseArguments args,
  }) async {
    return await Get.toNamed(ProductShowcasePage.routeName, arguments: args);
  }

  static Future<T?>? toCalendarPickerPage<T>({
    required CalendarPickerPageArgs args,
  }) async {
    return await Get.toNamed(CalendarPickerPage.routeName, arguments: args);
  }

  static Future<T?>? toCalendarBookingsPage<T>({
    required CalendarBookingsPageArgs args,
  }) async {
    return await Get.toNamed(CalendarBookingsPage.routeName, arguments: args);
  }

  static Future<T?>? toChatPage<T>({required Chat chat}) async {
    return await Get.toNamed(ChatPage.routeName, arguments: chat);
  }

  static Future<T?>? toArchivedMessagesPage<T>() async {
    return await Get.toNamed(ArchivedMessagePage.routeName);
  }

  static Future<T?>? toMyAssetPage<T>(
    BuildContext context, {
    required bool withNavbar,
  }) async {
    if (withNavbar) {
      return await pushScreen(
        context,
        screen: const YourListingPage(),
        withNavBar: true,
        settings: RouteSettings(
          name: YourListingPage.routeName,
          arguments: withNavbar,
        ),
      );
    }
    return await Get.toNamed(YourListingPage.routeName, arguments: withNavbar);
  }

  static Future<T?>? toPostListing<T>({
    required PostListingArguments? args,
  }) async {
    return await Get.toNamed(PostListingPage.routeName, arguments: args);
  }

  static Future<T?>? showAddInclusions<T>({
    required BuildContext context,
  }) async {
    // Suggestion: Return a value from the modal bottom sheet
    return LNDShow.modalSheet(
      context,
      expand: true,
      content: const AddInclusions(),
    );
  }

  static Future<T?>? toAddShowcase<T>() async {
    return await Get.toNamed(AddShowcasePage.routeName);
  }

  static Future<LocationCallbackModel?>? showLocationPicker({
    required BuildContext context,
    required LocationCallbackModel? location,
  }) async {
    return LNDShow.modalSheet<LocationCallbackModel?>(
      context,
      content: LocationPickerW(locationCallback: location),
      enableDrag: false,
      expand: false,
      isDismissible: false,
    );
  }

  static Future<Categories?>? showCategories({
    required BuildContext context,
    required Categories? category,
  }) async {
    return LNDShow.modalSheet(
      context,
      expand: true,
      content: CategoriesW(category: category),
    );
  }
}
