import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/controllers/location_picker/location_picker.controller.dart';
import 'package:lend/presentation/pages/asset/asset.page.dart';
import 'package:lend/presentation/pages/calendar/calendar.page.dart';
import 'package:lend/presentation/pages/your_listing/you_listing.page.dart';
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

  static Future<T?>? toSigninPage<T>() async {
    return await Get.toNamed(SigninPage.routeName);
  }

  static Future<T?>? toSignupPage<T>() async {
    return await Get.toNamed(SignUpPage.routeName);
  }

  static Future<T?>? toAssetPage<T>({required Asset? args}) async {
    return await Get.toNamed(AssetPage.routeName, arguments: args);
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

  static Future<T?>? toCalendarPage<T>() async {
    return await Get.toNamed(CalendarPage.routeName);
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
