import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/scan_qr/scan_qr.controller.dart';
import 'package:lend/presentation/pages/scan_qr/widgets/overlay.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRPage extends GetView<ScanQRController> {
  static const routeName = '/scan-qr';

  const ScanQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scanAreaSize = Get.width * 0.6;

    return Scaffold(
      backgroundColor: LNDColors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: controller.uploadQR,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  spacing: 8.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DottedBorder(
                      color: LNDColors.outline.withValues(alpha: 0.5),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(16),
                      strokeWidth: 2,
                      dashPattern: const [10, 10],
                      child: const SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: Center(
                          child: Icon(
                            Icons.photo_rounded,
                            color: LNDColors.outline,
                            size: 40.0,
                          ),
                        ),
                      ),
                    ),
                    LNDText.regular(text: 'Upload QR', color: LNDColors.white),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            if (!controller.isPermissionGranted.value) {
              return Center(
                child: Column(
                  spacing: 16.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LNDText.medium(
                      text: 'Camera permission is required to scan QRs',
                      color: LNDColors.white,
                    ),
                    LNDButton.text(
                      text: 'Grant Permission',
                      onPressed: controller.checkAndStart,
                      enabled: true,
                      color: LNDColors.primary,
                    ),
                  ],
                ),
              );
            }

            return Stack(
              children: [
                MobileScanner(
                  controller: controller.scannerController,
                  onDetect: controller.onDetect,
                  scanWindow: Rect.fromCenter(
                    center: Offset(Get.width / 2, Get.height / 2),
                    width: scanAreaSize,
                    height: scanAreaSize,
                  ),
                ),
                QRCodeOverlayW(
                  squareSize: scanAreaSize,
                  overlayColor: Colors.black.withValues(alpha: 0.6),
                  borderColor: Colors.white,
                  borderWidth: 3.0,
                  borderRadius: 12.0,
                ),
              ],
            );
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: controller.uploadQR,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  spacing: 8.0,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DottedBorder(
                      color: LNDColors.outline.withValues(alpha: 0.5),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(16),
                      strokeWidth: 2,
                      dashPattern: const [10, 10],
                      child: const SizedBox(
                        height: 50.0,
                        width: 50.0,
                        child: Center(
                          child: Icon(
                            Icons.photo_rounded,
                            color: LNDColors.outline,
                            size: 40.0,
                          ),
                        ),
                      ),
                    ),
                    LNDText.regular(text: 'Upload QR', color: LNDColors.white),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            left: 15.0,
            child: SafeArea(
              child: SizedBox(
                height: 50.0,
                width: 50.0,
                child: ClipRect(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                    child: ClipOval(
                      child: LNDButton.back(size: 30.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
