import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/presentation/pages/calendar/widgets/bottom_nav.widget.dart';
import 'package:lend/presentation/pages/calendar/widgets/calendar_view.widget.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class CalendarPage extends GetView<AssetController> {
  static const routeName = '/calendar';
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: LNDButton.back(),
        backgroundColor: LNDColors.white,
        surfaceTintColor: LNDColors.white,
      ),
      body: const CalendarView(),
      bottomNavigationBar: const CalendarBottomNav(),
    );
  }
}
