import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDShow {
  LNDShow._();
  static Future<T?> bottomSheet<T>(
    Widget content, {
    double? height,
    bool enableDrag = true,
    bool hasPadding = true,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Get.bottomSheet(
      Container(
        height: height,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.only(
          top: 8.0,
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 5.0,
                width: 60.0,
                decoration: BoxDecoration(
                  color: LNDColors.gray,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            content,
          ],
        ),
      ),
      backgroundColor: LNDColors.white,
      enableDrag: enableDrag,
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
        builder: (context) => CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                onCancel?.call();
                Get.back();
              },
              child: Text(
                cancelText,
                style: TextStyle(color: cancelColor),
              ),
            ),
            CupertinoDialogAction(
              onPressed: () {
                onConfirm?.call();
                Get.back();
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
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                onCancel?.call();
                Navigator.pop(context);
              },
              child: Text(
                cancelText,
                style: TextStyle(color: cancelColor),
              ),
            ),
            TextButton(
              onPressed: () {
                onConfirm?.call();
                Navigator.pop(context);
              },
              child: Text(
                confirmText,
                style: TextStyle(color: confirmColor),
              ),
            ),
          ],
        ),
      );
    }
  }
}
