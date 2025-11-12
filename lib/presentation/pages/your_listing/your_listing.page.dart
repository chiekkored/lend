import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/your_listing/your_listing.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';
import 'package:lend/utilities/extensions/int.extension.dart';

class YourListingPage extends GetView<YourListingController> {
  static const String routeName = '/your-listing';
  const YourListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final withNavbar =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: LNDColors.white,
        backgroundColor: LNDColors.white,
        leading: LNDButton.back(
          onPressed: withNavbar ? () => Navigator.of(context).pop() : null,
        ),
        title: LNDText.bold(text: 'Your listing', fontSize: 18.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: LNDButton.primary(
                text: '+ Create listing',
                enabled: true,
                hasPadding: false,
                onPressed: controller.goToPostListing,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () => _buildStatusIndicator(
                        icon: Icons.check_circle,
                        label: 'Available',
                        color: Colors.blue,
                        value: controller.availableAssets,
                      ),
                    ),
                    Obx(
                      () => _buildStatusIndicator(
                        icon: Icons.build,
                        label: 'Under Maintenance',
                        color: Colors.orange,
                        value: controller.underMaintenanceAssets,
                      ),
                    ),
                    Obx(
                      () => _buildStatusIndicator(
                        icon: Icons.visibility_off,
                        label: 'Hidden',
                        color: Colors.grey,
                        value: controller.hiddenAssets,
                      ),
                    ),
                  ],
                ).withSpacing(12.0),
              ),
            ),
            Column(
              children: [
                Obx(
                  () =>
                      controller.myAssets.isEmpty
                          ? const SizedBox.shrink()
                          : Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 24.0,
                                right: 24.0,
                                bottom: 8.0,
                              ),
                              child: LNDText.bold(
                                text: 'All',
                                color: LNDColors.hint,
                              ),
                            ),
                          ),
                ),
                Obx(
                  () =>
                      controller.isMyAssetsLoading
                          ? const LNDSpinner(color: LNDColors.black)
                          : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.myAssets.length.upTo(10),
                            itemBuilder: (_, index) {
                              final asset = controller.myAssets[index];
                              return ListTile(
                                tileColor: LNDColors.white,
                                onTap: () => controller.goToAssetPage(asset),
                                leading: LNDImage.square(
                                  imageUrl: asset.images?.first ?? '',
                                ),
                                title: LNDText.regular(text: asset.title ?? ''),
                                subtitle: Row(
                                  children: [
                                    Icon(
                                      asset.status == 'Available'
                                          ? Icons.check_circle
                                          : asset.status == 'Under Maintenance'
                                          ? Icons.build
                                          : Icons.visibility_off,
                                      color:
                                          asset.status == 'Available'
                                              ? Colors.blue
                                              : asset.status ==
                                                  'Under Maintenance'
                                              ? Colors.orange
                                              : Colors.grey,
                                      size: 16.0,
                                    ),
                                    LNDText.regular(
                                      text: asset.category ?? '',
                                      color: LNDColors.hint,
                                    ),
                                  ],
                                ).withSpacing(4.0),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (asset.bookings?.isNotEmpty ?? false)
                                      Badge.count(
                                        count: asset.bookings!.length,
                                      ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: LNDColors.hint,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Creates a status indicator with an icon, color and label
  Widget _buildStatusIndicator({
    required IconData icon,
    required String label,
    required Color color,
    required String value,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: LNDColors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [Icon(icon, color: color), LNDText.medium(text: value)],
            ).withSpacing(8.0),
            LNDText.regular(
              text: label,
              fontSize: 10.0,
              textAlign: TextAlign.start,
            ),
          ],
        ).withSpacing(8.0),
      ),
    );
  }
}
