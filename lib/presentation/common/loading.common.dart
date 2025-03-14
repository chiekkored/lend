import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDLoading {
  static void show({bool allowDismiss = false}) {
    // SPZLogger.iNoStack(
    //   'The loading indicator is displayed and can be dismissed at any time if kDebugMode is enabled.',
    // );
    Get.dialog(
      _loadingWidget(allowDismiss),
      barrierDismissible: kDebugMode ? true : allowDismiss,
    );
  }

  static Widget _loadingWidget(bool allowDismiss) {
    return PopScope(
      canPop: kDebugMode ? true : allowDismiss,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const LNDSpinner(
                color: LNDColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void hide() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}
