import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDSnackbar {
  static void showInfo(
    String message, {
    String title = '',
    bool showButton = false,
    String buttonText = '',
    VoidCallback? buttonOnPressed,
  }) {
    _showSnackbar(
      title,
      message,
      Colors.blue,
      Icons.info_rounded,
      showButton,
      buttonText,
      buttonOnPressed,
    );
  }

  static void showSuccess(
    String message, {
    String title = '',
    bool showButton = false,
    String buttonText = '',
    VoidCallback? buttonOnPressed,
  }) {
    _showSnackbar(
      title,
      message,
      LNDColors.primary,
      Icons.check_circle,
      showButton,
      buttonText,
      buttonOnPressed,
    );
  }

  static void showError(
    String message, {
    String title = '',
    bool showButton = false,
    String buttonText = '',
    VoidCallback? buttonOnPressed,
  }) {
    _showSnackbar(
      title,
      message,
      LNDColors.white,
      Icons.error_rounded,
      showButton,
      buttonText,
      buttonOnPressed,
    );
  }

  static void showWarning(
    String message, {
    String title = '',
    bool showButton = false,
    String buttonText = '',
    VoidCallback? buttonOnPressed,
  }) {
    _showSnackbar(
      title,
      message,
      Colors.orange,
      Icons.warning_rounded,
      showButton,
      buttonText,
      buttonOnPressed,
    );
  }

  static void _showSnackbar(
    String title,
    String message,
    Color color,
    IconData icon,
    bool showButton,
    String buttonText,
    VoidCallback? buttonOnPressed,
  ) async {
    await Get.closeCurrentSnackbar();

    Get.rawSnackbar(
      duration: const Duration(seconds: 5),
      titleText:
          title.isEmpty
              ? null
              : LNDText.bold(
                text: title,
                color: LNDColors.white,
                fontSize: 18.0,
              ),
      messageText: LNDText.regular(
        text: message,
        color: LNDColors.white,
        overflow: TextOverflow.clip,
      ),
      backgroundColor: color,
      borderRadius: 16.0,
      snackPosition: SnackPosition.BOTTOM,
      icon: Icon(icon, color: LNDColors.white, size: 25.0),
      animationDuration: const Duration(milliseconds: 500),
      margin:
          Platform.isAndroid
              ? const EdgeInsets.all(8.0)
              : const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 4.0),
      mainButton:
          showButton
              ? Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: LNDButton.text(
                  text: buttonText,
                  onPressed: () {
                    buttonOnPressed?.call();
                  },
                  enabled: true,
                  color: LNDColors.primary,
                ),
              )
              : null,
      onTap: (snack) => Get.closeCurrentSnackbar(),
    );
  }
}
