import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDSpinner extends StatelessWidget {
  final Color? color;
  final double? size;
  const LNDSpinner({this.color, this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoActivityIndicator(
            color: color ?? LNDColors.white,
          )
        : SizedBox.square(
            dimension: size ?? 18.0,
            child: CircularProgressIndicator(
              color: color ?? LNDColors.white,
            ),
          );
  }
}
