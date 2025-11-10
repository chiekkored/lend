import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LNDShow {
  LNDShow._();
  static Future<T?> bottomSheet<T>(
    Widget content, {
    double? height,
    bool expand = false,
    bool enableDrag = true,
    bool hasPadding = true,
    bool isDismissible = true,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return showBarModalBottomSheet(
      context: Get.context!,
      expand: expand,
      builder: (_) => content,
      backgroundColor: LNDColors.white,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
    );
  }

  static Future<T?> modalSheet<T>(
    BuildContext context, {
    required Widget content,
    double? height,
    bool expand = false,
    bool enableDrag = true,
    bool hasPadding = true,
    bool isDismissible = true,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return CupertinoScaffold.showCupertinoModalBottomSheet(
      builder: (_) => content,
      backgroundColor: LNDColors.white,
      context: context,
      expand: expand,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      duration: const Duration(milliseconds: 300),
    );
  }

  static Future<T?> alertDialog<T>({
    required String title,
    required String content,
    String cancelText = 'Cancel',
    String confirmText = 'OK',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    Color? cancelColor,
  }) {
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
        context: Get.context!,
        builder:
            (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    onCancel?.call();
                    Get.back(result: false);
                  },
                  child: Text(
                    cancelText,
                    style: TextStyle(color: cancelColor ?? LNDColors.black),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    onConfirm?.call();
                    Get.back(result: true);
                  },
                  isDefaultAction: true,
                  child: Text(
                    confirmText,
                    style: TextStyle(color: confirmColor),
                  ),
                ),
              ],
            ),
      );
    } else {
      return showDialog<T>(
        context: Get.context!,
        builder:
            (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () {
                    onCancel?.call();
                    Get.back(result: false);
                  },
                  child: Text(
                    cancelText,
                    style: TextStyle(color: cancelColor ?? LNDColors.black),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onConfirm?.call();
                    Get.back(result: true);
                  },
                  child: Text(
                    confirmText,
                    style: TextStyle(color: confirmColor ?? LNDColors.black),
                  ),
                ),
              ],
            ),
      );
    }
  }
}
