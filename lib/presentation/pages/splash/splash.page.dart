import 'package:flutter/material.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LNDColors.primary,
      body: Center(
        child: Transform.translate(
          offset: const Offset(0.0, -63.0),
          child: const FlutterLogo(),
        ),
      ),
    );
  }
}
