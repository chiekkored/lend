import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/presentation/pages/post_listing/widgets/fields/post_cover_photos.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/fields/post_list_field.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/fields/post_rate_field.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/fields/post_switch_field.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/fields/post_textbox.widget.dart';
import 'package:lend/presentation/pages/post_listing/widgets/fields/post_textfield.widget.dart';
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
              onPressed: controller.next,
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
                const PostCoverPhotosW(),
                PostTextFieldW(
                  textController: controller.titleController,
                  text: 'Product Title',
                  subtitle:
                      'Provide a clear and concise title that accurately '
                      'represents your product.',
                  example: 'DJI Osmo Pocket 3',
                  required: true,
                ),
                PostTextBoxW(
                  textController: controller.descriptionController,
                  required: false,
                  text: 'Description',
                  subtitle:
                      'Describe your product in detail, highlighting key features and specifications.',
                ),
                PostTextFieldW(
                  textController: controller.categoryController,
                  required: true,
                  text: 'Category',
                  subtitle: 'Select the category that best fits your product.',
                  readOnly: true,
                  onTap: () {
                    controller.showCategories(context);
                  },
                ),
                PostRateFieldW(
                  textController: controller.dailyPriceController,
                  text: 'Daily Rate',
                ),

                PostListFieldW(
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 60.0),
                  child: Divider(),
                ),
                Obx(
                  () => PostListFieldW(
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
                    PostSwitchFieldW(
                      label: 'Use Registered Address',
                      icon: Icons.location_searching_rounded,
                      value: controller.useRegisteredAddress,
                      subtitle:
                          'Toggle to enter a custom address or use your registered '
                          'home/business address.',
                    ),
                    Obx(() {
                      return controller.useRegisteredAddress.isFalse
                          ? Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: PostTextFieldW(
                              textController: controller.locationController,
                              required: controller.useRegisteredAddress.isFalse,
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
                  () => PostListFieldW(
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
}
