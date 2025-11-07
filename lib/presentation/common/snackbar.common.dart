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
      LNDColors.danger,
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
    ScaffoldMessenger.of(Get.context!)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 5),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          margin:
              Platform.isAndroid
                  ? const EdgeInsets.all(8.0)
                  : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
          dismissDirection: DismissDirection.horizontal,
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: LNDColors.white, size: 25.0),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title.isNotEmpty)
                      LNDText.bold(
                        text: title,
                        color: LNDColors.white,
                        fontSize: 18.0,
                      ),
                    LNDText.regular(
                      text: message,
                      color: LNDColors.white,
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
              if (showButton)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: LNDButton.text(
                    text: buttonText,
                    onPressed: () {
                      buttonOnPressed?.call();
                      ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
                    },
                    enabled: true,
                    color: LNDColors.primary,
                  ),
                ),
            ],
          ),
        ),
      );
  }
}
