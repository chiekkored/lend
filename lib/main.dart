import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/core/bindings/root.binding.dart';
import 'package:lend/core/services/main.service.dart';
import 'package:lend/presentation/pages/navigation/navigation.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await MainService.initializeFirebase();

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        splashColor: LNDColors.primaryColor,
      ),
      initialBinding: RootBinding(),
      home: const NavigationPage(),
    );
  }
}
