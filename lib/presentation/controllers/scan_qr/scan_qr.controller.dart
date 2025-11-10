import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lend/core/models/qr_raw.model.dart';
import 'package:lend/core/services/booking.service.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/show.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanQRController extends GetxController {
  static final instance = Get.find<ScanQRController>();

  final MobileScannerController scannerController = MobileScannerController();
  RxBool isPermissionGranted = false.obs;
  RxString lastScanned = ''.obs;

  @override
  void onInit() {
    checkAndStart();

    super.onInit();
  }

  @override
  void onClose() {
    scannerController.dispose();
    isPermissionGranted.close();
    lastScanned.close();

    super.onClose();
  }

  Future<void> checkAndStart() async {
    // Check camera permission status
    final status = await Permission.camera.status;

    if (status.isGranted) {
      isPermissionGranted.value = true;
      _startScanner();
    } else {
      // Request permission
      final result = await Permission.camera.request();
      if (result.isGranted) {
        isPermissionGranted.value = true;
        _startScanner();
      } else if (result.isPermanentlyDenied) {
        isPermissionGranted.value = false;
        _showRequestPopup('Camera access denied');
      } else {
        isPermissionGranted.value = false;
      }
    }
  }

  void _startScanner() {
    scannerController.start();
  }

  void onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final raw = barcodes.first.rawValue;
      if (raw != null && raw.isNotEmpty) {
        lastScanned.value = raw;
        debugPrint('raw: ${raw}');
        scannerController.stop(); // optional
      }
    }
  }

  void uploadQR() async {
    try {
      final hasAccess = await Gal.hasAccess();
      if (hasAccess) {
        final image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (image != null) {
          LNDLoading.show();

          BarcodeCapture? data = await scannerController.analyzeImage(
            image.path,
            formats: [BarcodeFormat.qrCode],
          );
          if (data != null && data.raw != null) {
            final qrMap =
                json.decode(json.encode(data.raw)) as Map<String, dynamic>;
            final qrData = QrRaw.fromMap(qrMap);

            if ((qrData.data?.first.rawValue?.isEmpty ?? false) ||
                qrData.data?.first.rawValue == null) {
              LNDLoading.hide();
              throw 'Empty raw value';
            }
            final result = await BookingService.markBooking(
              token: qrData.data?.first.rawValue ?? '',
            );
            if (result != null || result?['success']) {
              Get.back(result: true);
            }
          } else {
            LNDSnackbar.showError('Invalid QR');
          }
          LNDLoading.hide();
        }
      } else {
        final result = await Gal.requestAccess();
        if (!result) _showRequestPopup('Gallery access denied');
      }
    } catch (e, st) {
      LNDLoading.hide();
      LNDSnackbar.showError('Invalid QR');
      LNDLogger.e(e.toString(), stackTrace: st);
    }
  }

  void _showRequestPopup(String title) {
    LNDShow.alertDialog(
      title: title,
      content:
          'You have previously denied camera access. Please go to Settings '
          'to enable it.',
      cancelText: 'Close',
      confirmText: 'Settings',
      onConfirm: () async {
        final canOpen = await openAppSettings();

        if (!canOpen) {
          LNDSnackbar.showWarning(
            "Unable to open app settings. Open phone's settings and enable "
            'camera access manually.',
          );
        }
      },
    );
  }
}
