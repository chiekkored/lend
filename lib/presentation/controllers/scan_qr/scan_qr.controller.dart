import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
          BarcodeCapture? data = await scannerController.analyzeImage(
            image.path,
            formats: [BarcodeFormat.qrCode],
          );
          debugPrint('data: ${data?.barcodes}');
          debugPrint('data: ${data?.image}');
          debugPrint('data: ${data?.raw}');
          debugPrint('data: ${data?.size}');
        }
      } else {
        final result = await Gal.requestAccess();
        if (!result) _showRequestPopup('Gallery access denied');
      }
    } catch (e, st) {
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
