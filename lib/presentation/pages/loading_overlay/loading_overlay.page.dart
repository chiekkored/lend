import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/controllers/loading/loading.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart'; // adjust import

class LoadingOverlay extends GetWidget<LoadingController> {
  final Widget child;
  const LoadingOverlay({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        GestureDetector(
          onTap: kDebugMode ? controller.hide : null,
          child: Obx(() {
            if (!controller.isLoading.value) return const SizedBox.shrink();
            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.4),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const LNDSpinner(color: LNDColors.white),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
