// ignore_for_file: deprecated_member_use

import 'dart:typed_data';

import 'package:flutter/material.dart';
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
  const QRViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final qrToken = Get.arguments as String;

    void saveQr() async {
      try {
        LNDLoading.show();

        final qrImageData = await QrPainter(
          data: qrToken,
          gapless: true,
          version: QrVersions.auto,
          color: Colors.black,
          emptyColor: Colors.white,
        ).toImageData(200.0);
        if (qrImageData == null) {
          LNDSnackbar.showError('Failed to save QR image');
          return;
        }

        Uint8List imageToBytes = qrImageData.buffer.asUint8List();
        await Gal.putImageBytes(
          imageToBytes,
          album: 'Lend',
          name: 'Receive_QR_${DateTime.now().toIso8601String()}',
        );
        LNDSnackbar.showInfo('QR image downloaded');
      } catch (e, st) {
        LNDLogger.e(e.toString(), stackTrace: st);
        LNDSnackbar.showError('Failed to save QR image');
      }
      LNDLoading.hide();
    }

    return Scaffold(
      appBar: AppBar(leading: LNDButton.back()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 24.0,
        children: [
          Center(
            child: QrImageView(
              data: qrToken,
              version: QrVersions.auto,
              size: Get.width / 1.5,
            ),
          ),
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
