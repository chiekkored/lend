// ignore_for_file: deprecated_member_use
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/loading.common.dart';
import 'package:lend/presentation/common/snackbar.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/helpers/loggers.helper.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRViewPage extends StatelessWidget {
  static const routeName = '/qr-view';
  QRViewPage({super.key});

  final GlobalKey qrKey = GlobalKey();

  Future<void> saveQr() async {
    try {
      LNDLoading.show();

      final boundary =
          qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      await Gal.putImageBytes(
        pngBytes,
        album: 'Lend',
        name: 'Receive_QR_${DateTime.now().toIso8601String()}',
      );
      LNDSnackbar.showInfo('QR image downloaded');
    } catch (e, st) {
      LNDLogger.e(e.toString(), stackTrace: st);
      LNDSnackbar.showError('Failed to save QR image');
    } finally {
      LNDLoading.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final qrToken = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(
        leading: LNDButton.back(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RepaintBoundary(
              key: qrKey,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: QrImageView(
                  data: qrToken,
                  version: QrVersions.auto,
                  size: Get.width / 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          LNDButton.icon(
            icon: Icons.download_rounded,
            text: 'Save QR',
            onPressed: saveQr,
            enabled: true,
            color: LNDColors.gray,
            size: 18.0,
          ),
        ],
      ),
    );
  }
}
