import 'package:get/get.dart';
import 'package:lend/core/models/asset.model.dart';
import 'package:lend/presentation/pages/asset/asset.page.dart';
import 'package:lend/presentation/pages/calendar/calendar.page.dart';
import 'package:lend/presentation/pages/photo_view/photo_view.page.dart';
import 'package:lend/presentation/pages/post_listing/post_listing.page.dart';
import 'package:lend/presentation/pages/product_showcase/product_showcase.page.dart';
import 'package:lend/presentation/pages/signin/signin.page.dart';
import 'package:lend/presentation/pages/signup/signup.page.dart';

class LNDNavigate {
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

  static Future<T?>? toPostListing<T>({
    required PostListingArguments? args,
  }) async {
    return await Get.toNamed(PostListingPage.routeName, arguments: args);
  }
}
