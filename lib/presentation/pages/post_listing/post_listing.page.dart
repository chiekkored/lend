import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
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
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: LNDColors.white,
        appBar: AppBar(
          leading: LNDButton.text(
            text: 'Cancel',
            onPressed: Get.back,
            enabled: true,
            color: LNDColors.primary,
          ),
          leadingWidth: 80.0,
          automaticallyImplyLeading: true,
          backgroundColor: LNDColors.white,
          surfaceTintColor: LNDColors.white,
          title: LNDText.bold(text: 'Create Listing', fontSize: 24.0),
          actionsPadding: const EdgeInsets.only(right: 12.0),
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
              isBold: true,
              color: LNDColors.primary,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCoverPhotos(),
                _buildTextField(
                  textController: controller.titleController,
                  text: 'Product Title',
                  subtitle:
                      'Provide a clear and concise title that accurately '
                      'represents your product.',
                  example: 'DJI Osmo Pocket 3',
                  required: true,
                ),
                _buildTextBox(
                  textController: controller.descriptionController,
                  required: false,
                  text: 'Description',
                  subtitle:
                      'Describe your product in detail, highlighting key features and specifications.',
                ),
                _buildTextField(
                  textController: controller.categoryController,
                  required: true,
                  text: 'Category',
                  subtitle: 'Select the category that best fits your product.',
                  readOnly: true,
                  onTap: () {
                    controller.showCategories(context);
                  },
                ),
                _buildRateField(
                  textController: controller.dailyPriceController,
                  text: 'Daily Rate',
                ),

                _buildListField(
                  label: 'Add Showcase Photos',
                  subtitle: 'Add up to 10 showcase photos of your product.',
                  icon: Icons.wallpaper_outlined,
                  trailing: Obx(() {
                    return controller.isShowcaseUploading.value
                        ? const LNDSpinner(color: LNDColors.black)
                        : ColoredBox(
                          color: Colors.transparent,
                          child: SizedBox(
                            width: 50.0,
                            height: 30.0,
                            child: Stack(
                              children: [
                                if (controller.showcasePhotos.isNotEmpty)
                                  for (
                                    int i = 0;
                                    i < 3 &&
                                        i < controller.showcasePhotos.length;
                                    i++
                                  )
                                    Positioned(
                                      bottom: 0.0,
                                      left: i * 10.0,
                                      child: LNDImage.square(
                                        imageUrl:
                                            controller
                                                .showcasePhotos[i]
                                                .value
                                                .file
                                                ?.path ??
                                            '',
                                        size: 30.0,
                                        borderRadius: 3.0,
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        );
                  }),
                  onTap: () => controller.showAddShowcase(context),
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
                Obx(
                  () => _buildListField(
                    label: 'Add Inclusions',
                    icon: Icons.list_alt_outlined,
                    subtitle:
                        'List all items and services '
                        'included with the rental to set clear expectations.',
                    count:
                        controller.inclusions.isEmpty
                            ? null
                            : controller.inclusions.length.toString(),
                    onTap: () => controller.showAddInclusions(context),
                  ),
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
                              textController: controller.locationController,
                              required: controller.isCustomLocation.isFalse,
                              readOnly: true,
                              onTap:
                                  () => controller.showLocationPicker(context),
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
                Obx(
                  () => _buildListField(
                    label: 'Availability',
                    icon: Icons.visibility_outlined,
                    subtitle:
                        'Indicate the current availability of your product: '
                        'Available, Hidden, or Under Maintenance.',
                    value: controller.availability.value.label,
                    onTap: () => controller.showAvailability(),
                  ),
                ),
              ],
            ).withSpacing(16.0),
          ),
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

  Widget _buildCoverPhotos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: SizedBox(
              width: Get.width,
              height: 150.0,
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: DottedBorder(
                      color: LNDColors.hint,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(16),
                      strokeWidth: 2,
                      dashPattern: const [6, 6],
                      child: Obx(
                        () =>
                            controller.coverPhotos.isNotEmpty
                                ? ListView.builder(
                                  itemCount: controller.coverPhotos.length,
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(4.0),
                                  itemBuilder: (context, index) {
                                    return _buildPhotoPreview(index);
                                  },
                                )
                                : Center(
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
                                      LNDText.bold(
                                        text: 'Add Cover Photos',
                                        required: true,
                                      ),
                                    ],
                                  ),
                                ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: LNDColors.outline,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                        ),
                      ),
                      child: Row(
                        children: [
                          LNDButton.icon(
                            icon: FontAwesomeIcons.images,
                            onPressed: controller.addCoverPhotos,
                            size: 20.0,
                          ),
                          LNDButton.icon(
                            icon: FontAwesomeIcons.camera,
                            onPressed: controller.openCamera,
                            size: 20.0,
                          ),
                        ],
                      ).withSpacing(24.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          LNDText.regular(
            text:
                'Upload up to 6 high-quality photos displaying '
                'the actual product available for rent',
            fontSize: 12.0,
            color: LNDColors.hint,
            textAlign: TextAlign.center,
          ),
        ],
      ).withSpacing(8.0),
    );
  }

  Stack _buildPhotoPreview(int index) {
    final photo = controller.coverPhotos[index];
    return Stack(
      children: [
        Container(
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: LNDImage.square(imageUrl: photo.value.file?.path, size: 125.0),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          child: SizedBox(
            height: 20.0,
            width: 20.0,
            child: ClipRect(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                child: ClipOval(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: LNDButton.icon(
                      icon: FontAwesomeIcons.xmark,
                      size: 15.0,
                      color: LNDColors.black,
                      onPressed: () => controller.removeCoverPhoto(index),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 0.0,
          left: 0.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            // shadow
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: LNDColors.black.withValues(alpha: 0.1),
                  blurRadius: 4.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Obx(
              () =>
                  photo.value.progress?.isNaN ?? true
                      ? const SizedBox.shrink()
                      : photo.value.progress == 1.0
                      ? const SizedBox.shrink()
                      : LinearProgressIndicator(
                        value: photo.value.progress,
                        color: LNDColors.primary,
                      ),
            ),
          ),
        ),
        Obx(
          () =>
              (photo.value.storagePath != null ||
                      (photo.value.storagePath?.isNotEmpty ?? false))
                  ? const SizedBox.shrink()
                  : const Positioned.fill(
                    child: LNDSpinner(color: LNDColors.black),
                  ),
        ),
      ],
    );
  }

  Padding _buildListField({
    required String label,
    required IconData icon,
    required void Function() onTap,
    String? subtitle,
    String? count,
    Widget? trailing,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        title: LNDText.medium(
          text: label,
          textParts: [
            if (value?.isNotEmpty ?? false) ...[
              LNDText.bold(text: ': '),
              LNDText.bold(text: value ?? '', color: LNDColors.primary),
            ],
          ],
        ),
        leading: Icon(icon),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Trailing or count widget only
            if (trailing != null)
              trailing
            else if (count != null)
              Chip(
                label: LNDText.regular(text: count, color: LNDColors.white),
                color: const WidgetStatePropertyAll(LNDColors.primary),
                shape: const CircleBorder(
                  side: BorderSide(color: LNDColors.primary),
                ),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),

            const Icon(Icons.chevron_right_rounded, color: LNDColors.hint),
          ],
        ),
        subtitle:
            (subtitle?.isNotEmpty ?? false)
                ? LNDText.regular(
                  text: subtitle ?? '',
                  fontSize: 12.0,
                  color: LNDColors.hint,
                )
                : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController textController,
    required String text,
    required bool required,
    bool? readOnly,
    String? prefixText,
    String? suffixText,
    String? subtitle,
    String? example,
    TextInputType? keyboardType,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LNDTextField.form(
            controller: textController,
            labelText: text,
            prefixText: prefixText,
            keyboardType: keyboardType ?? TextInputType.text,
            required: required,
            prefixStyle:
                prefixText != null
                    ? LNDText.mediumStyle.copyWith(
                      color: LNDColors.black,
                      fontSize: 16.0,
                    )
                    : null,
            suffixText: suffixText,
            helperText: subtitle,
            validator: (value) => controller.validateField(value, label: text),
            readOnly: readOnly ?? false,
            onTap: onTap,
          ),
          if (example?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: LNDText.regular(
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
            ),
        ],
      ),
    );
  }

  Widget _buildRateField({
    required TextEditingController textController,
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
            controller: textController,
            labelText: text,
            borderRadius: 12.0,
            suffixText: suffixText,
            helperText: subtitle,
            required: true,
            validator: (value) => controller.validateField(value, label: text),
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
    required TextEditingController textController,
    required String text,
    required bool required,
    String? subtitle,
    String? example,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LNDTextField.textBox(
            controller: textController,
            maxLines: 4,
            labelText: text,
            borderRadius: 12.0,
            helperText: subtitle,
            validator:
                required
                    ? (value) => controller.validateField(value, label: text)
                    : null,
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
