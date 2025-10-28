import 'package:lend/presentation/controllers/loading/loading.controller.dart';

class LNDLoading {
  static void show({bool allowDismiss = false}) {
    // SPZLogger.iNoStack(
    //   'The loading indicator is displayed and can be dismissed at any time if kDebugMode is enabled.',
    // );
    // Get.dialog(
    //   _loadingWidget(allowDismiss),
    //   barrierDismissible: kDebugMode ? true : allowDismiss,
    // );
    LoadingController.instance.show();
  }

  // static Widget _loadingWidget(bool allowDismiss) {
  //   return PopScope(
  //     canPop: kDebugMode ? true : allowDismiss,
  //     child: Center(
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(12),
  //         child: BackdropFilter(
  //           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //           child: Container(
  //             padding: const EdgeInsets.all(20.0),
  //             decoration: BoxDecoration(
  //               color: Colors.white.withValues(alpha: 0.2),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: const LNDSpinner(color: LNDColors.white),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  static void hide() {
    // if (Get.isDialogOpen ?? false) {
    //   Get.back();
    // }

    LoadingController.instance.hide();
  }
}
