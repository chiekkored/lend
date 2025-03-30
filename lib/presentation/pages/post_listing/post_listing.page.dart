import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class PostListingArguments {
  final String? assetId;
  PostListingArguments({required this.assetId});
}

class PostListingPage extends GetView<PostListingController> {
  static const routeName = '/post_listing';
  const PostListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: LNDColors.white,
        appBar: AppBar(
          leading: LNDButton.close(),
          backgroundColor: LNDColors.white,
          surfaceTintColor: LNDColors.white,
          title: LNDText.bold(text: 'Create Listing', fontSize: 24.0),
          centerTitle: false,
          actions: [
            LNDButton.text(
              text: 'Next',
              onPressed: () {
                controller.next();
                // if (controller.isCustomPrice.isTrue) {
                //   controller.showEditPrices();
                // } else {
                //   controller.showPreview();
                // }
              },
              enabled: true,
              color: LNDColors.primary,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCoverPhotos(),
              _buildTextField(
                controller: controller.titleController,
                text: 'Product Title',
                subtitle:
                    'Provide a clear and concise title that accurately '
                    'represents your product.',
                example: 'DJI Osmo Pocket 3',
              ),
              _buildTextBox(
                text: 'Description',
                subtitle:
                    'Describe your product in detail, highlighting key features and specifications.',
              ),
              _buildTextField(
                controller: controller.categoryController,
                text: 'Category',
                subtitle: 'Select the category that best fits your product.',
              ),
              _buildRateField(
                controller: controller.dailyPriceController,
                text: 'Daily Rate',
                // subtitle:
                //     'Set your daily rental rate; weekly, monthly, and annual '
                //     'rates will be auto-calculated unless you choose to edit '
                //     'them. Note: Only the daily rate is required.',
              ),

              // Column(
              //   children: [
              //     _buildSwitchField(
              //       label: 'Use auto-calculated rates',
              //       icon: Icons.money_rounded,
              //       // icon: Icons.currency_exchange_rounded,
              //       value: controller.isCustomPrice,
              //     ),
              //     Obx(() {
              //       return controller.isCustomPrice.isFalse
              //           ? _buildPricing()
              //           : const SizedBox.shrink();
              //     }),
              //   ],
              // ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                child: Divider(),
              ),
              _buildListField(
                label: 'Add Inclusions',
                icon: Icons.list_alt_outlined,
                subtitle:
                    'List all items and services '
                    'included with the rental to set clear expectations.',
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSwitchField(
                    label: 'Use Registered Address',
                    icon: Icons.location_searching_rounded,
                    value: controller.isCustomLocation,
                    subtitle:
                        'Toggle to enter a custom address or use your registered '
                        'home/business address.',
                  ),
                  Obx(() {
                    return controller.isCustomLocation.isFalse
                        ? Padding(
                          padding: const EdgeInsets.only(top: 0.0),
                          child: _buildTextField(
                            controller: controller.locationController,
                            text: 'Location',
                            subtitle:
                                'Enter the exact address where the product is available for rent.',
                            example:
                                '123 Main St., Brgy. San Antonio, Pasig City',
                          ),
                        )
                        : const SizedBox.shrink();
                  }),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                child: Divider(),
              ),
              _buildListField(
                label: 'Availability',
                icon: Icons.visibility_outlined,
                subtitle:
                    'Indicate the current availability of your product: '
                    'Available, Hidden, or Under Maintenance.',
              ),
            ],
          ).withSpacing(16.0),
        ),
      ),
    );
  }

  Widget _buildSwitchField({
    required String label,
    required IconData icon,
    required RxBool value,
    String? subtitle,
  }) {
    return Obx(
      () => SwitchListTile.adaptive(
        title: LNDText.medium(text: label),
        value: value.value,
        visualDensity: VisualDensity.comfortable,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        secondary: Icon(icon),
        subtitle:
            subtitle != null
                ? LNDText.regular(
                  text: subtitle,
                  fontSize: 12.0,
                  color: LNDColors.hint,
                )
                : null,
        onChanged: (_) => value.toggle(),
      ),
    );
  }

  Padding _buildCoverPhotos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          SizedBox(
            width: Get.width,
            height: 150.0,
            child: DottedBorder(
              color: LNDColors.hint,
              borderType: BorderType.RRect,
              radius: const Radius.circular(16),
              strokeWidth: 2,
              dashPattern: const [6, 6],
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/image.svg',
                      colorFilter: const ColorFilter.mode(
                        LNDColors.hint,
                        BlendMode.srcIn,
                      ),
                    ),
                    LNDText.bold(text: 'Add Cover Photos'),
                  ],
                ),
              ),
            ),
          ),
          LNDText.regular(
            text:
                'Upload up to 6 high-quality photos showcasing '
                'the actual product available for rent',
            fontSize: 12.0,
            color: LNDColors.hint,
            textAlign: TextAlign.center,
          ),
        ],
      ).withSpacing(8.0),
    );
  }

  Padding _buildListField({
    required String label,
    required IconData icon,
    String? subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        title: LNDText.medium(text: label),
        leading: Icon(icon),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: LNDColors.hint,
        ),
        subtitle:
            (subtitle?.isNotEmpty ?? false)
                ? LNDText.regular(
                  text: subtitle ?? '',
                  fontSize: 12.0,
                  color: LNDColors.hint,
                )
                : null,
        onTap: () {},
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String text,
    String? prefixText,
    String? suffixText,
    String? subtitle,
    String? example,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LNDTextField.regular(
            controller: controller,
            hintText: text,
            borderRadius: 12.0,
            prefixText: prefixText,
            keyboardType: keyboardType ?? TextInputType.text,
            prefixStyle:
                prefixText != null
                    ? LNDText.mediumStyle.copyWith(
                      color: LNDColors.black,
                      fontSize: 16.0,
                    )
                    : null,
            suffixText: suffixText,
          ),
          if (subtitle?.isNotEmpty ?? false)
            LNDText.regular(
              text: subtitle ?? '',
              fontSize: 12.0,
              color: LNDColors.hint,
            ),
          if (example?.isNotEmpty ?? false)
            LNDText.regular(
              text: 'e.g. ',
              fontSize: 12.0,
              color: LNDColors.hint,
              textAlign: TextAlign.start,
              textParts: [
                LNDText.semibold(
                  text: '"$example"',
                  fontSize: 12.0,
                  color: LNDColors.hint,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRateField({
    required TextEditingController controller,
    required String text,
    String? suffixText,
    String? subtitle,
    String? example,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LNDTextField.money(
            controller: controller,
            hintText: text,
            borderRadius: 12.0,
            suffixText: suffixText,
          ),
          if (subtitle?.isNotEmpty ?? false)
            LNDText.regular(
              text: subtitle ?? '',
              fontSize: 12.0,
              color: LNDColors.hint,
            ),
          if (example?.isNotEmpty ?? false)
            LNDText.regular(
              text: 'e.g. ',
              fontSize: 12.0,
              color: LNDColors.hint,
              textAlign: TextAlign.start,
              textParts: [
                LNDText.semibold(
                  text: '"$example"',
                  fontSize: 12.0,
                  color: LNDColors.hint,
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTextBox({
    required String text,
    String? subtitle,
    String? example,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LNDTextField.textBox(
            controller: TextEditingController(),
            maxLines: 4,
            hintText: text,
            borderRadius: 12.0,
          ),
          if (subtitle?.isNotEmpty ?? false)
            LNDText.regular(
              text: subtitle ?? '',
              fontSize: 12.0,
              color: LNDColors.hint,
            ),
          if (example?.isNotEmpty ?? false)
            LNDText.regular(
              text: 'e.g. ',
              fontSize: 12.0,
              color: LNDColors.hint,
              textAlign: TextAlign.start,
              textParts: [
                LNDText.semibold(
                  text: '"$example"',
                  fontSize: 12.0,
                  color: LNDColors.hint,
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Widget _buildPricing() {
  //   return Container(
  //     width: double.infinity,
  //     margin: const EdgeInsets.symmetric(horizontal: 24.0),
  //     padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
  //     decoration: BoxDecoration(
  //       color: LNDColors.outline,
  //       borderRadius: BorderRadius.circular(12.0),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Align(
  //           alignment: AlignmentDirectional.topEnd,
  //           child: LNDButton.text(
  //             text: 'Edit',
  //             onPressed: controller.showEditPrices,
  //             enabled: true,
  //             color: Colors.blueAccent,
  //           ),
  //         ),
  //         const SizedBox(height: 8.0),
  //         Wrap(
  //           spacing: 40.0,
  //           runSpacing: 16.0,
  //           alignment: WrapAlignment.center,
  //           children: [
  //             Column(
  //               children: [
  //                 LNDText.medium(
  //                   text: 'Weekly',
  //                   color: LNDColors.hint,
  //                   fontSize: 12.0,
  //                 ),
  //                 Obx(
  //                   () => LNDText.regular(
  //                     text:
  //                         controller.weeklyPrice.isEmpty
  //                             ? ''
  //                             : '₱${controller.weeklyPrice}',
  //                   ),
  //                 ),
  //               ],
  //             ),

  //             Column(
  //               children: [
  //                 LNDText.medium(
  //                   text: 'Monthly',
  //                   color: LNDColors.hint,
  //                   fontSize: 12.0,
  //                 ),
  //                 Obx(
  //                   () => LNDText.regular(
  //                     text:
  //                         controller.monthlyPrice.isEmpty
  //                             ? ''
  //                             : '₱${controller.monthlyPrice}',
  //                   ),
  //                 ),
  //               ],
  //             ),

  //             Column(
  //               children: [
  //                 LNDText.medium(
  //                   text: 'Annually',
  //                   color: LNDColors.hint,
  //                   fontSize: 12.0,
  //                 ),
  //                 Obx(
  //                   () => LNDText.regular(
  //                     text:
  //                         controller.annualPrice.isEmpty
  //                             ? ''
  //                             : '₱${controller.annualPrice}',
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
