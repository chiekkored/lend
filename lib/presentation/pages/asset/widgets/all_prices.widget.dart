import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/asset/asset.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/int.extension.dart';

class AssetAllPricesSheet extends GetWidget<AssetController> {
  const AssetAllPricesSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final daily = controller.asset?.rates?.daily;
    final weekly = controller.asset?.rates?.weekly;
    final monthly = controller.asset?.rates?.monthly;
    final annually = controller.asset?.rates?.annually;
    final notes = controller.asset?.rates?.notes;

    return SafeArea(
      child: Container(
        // height: height != null ? height + (Platform.isIOS ? 16.0 : 0) : null,
        width: Get.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.only(
            top: 8.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 5.0,
                width: 60.0,
                decoration: BoxDecoration(
                    color: LNDColors.gray,
                    borderRadius: BorderRadius.circular(16.0)),
              ),
            ),
            ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 16.0),
              shrinkWrap: true,
              children: [
                _buildListItem(
                    label: 'Daily',
                    value: daily,
                    icon: Icons.calendar_view_day_rounded),
                _buildListItem(
                    label: 'Weekly',
                    value: weekly,
                    icon: Icons.calendar_view_week_rounded),
                _buildListItem(
                    label: 'Monthly',
                    value: monthly,
                    icon: Icons.calendar_view_month_rounded),
                _buildListItem(
                  label: 'Annually',
                  value: annually,
                  icon: Icons.calendar_month_rounded,
                ),
                LNDText.bold(
                  text: 'Notes:',
                  color: LNDColors.hint,
                ),
                LNDText.regular(text: notes ?? '')
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      {required String label, required int? value, required IconData icon}) {
    return Visibility(
      visible: value != null && value > 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            visualDensity: VisualDensity.compact,
            leading: Icon(
              icon,
              color: LNDColors.black,
            ),
            title: LNDText.bold(
              text: label,
              fontSize: 18.0,
            ),
            trailing: LNDText.regular(
              text: '₱${value?.toMoney() ?? ''}',
              fontSize: 18.0,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
