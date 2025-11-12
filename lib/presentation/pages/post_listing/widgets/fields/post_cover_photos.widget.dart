import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/images.common.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class PostCoverPhotosW extends GetWidget<PostListingController> {
  const PostCoverPhotosW({super.key});

  @override
  Widget build(BuildContext context) {
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
                    child: Obx(
                      () => DottedBorder(
                        color:
                            controller.showCoverPhotosError.value
                                ? LNDColors.danger
                                : LNDColors.hint,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(16),
                        strokeWidth: 2,
                        dashPattern: const [6, 6],
                        child:
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

  Widget _buildPhotoPreview(int index) {
    final photo = controller.coverPhotos[index];
    return Stack(
      children: [
        Container(
          height: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          child: LNDImage.square(imageUrl: photo.value.file?.path, size: 125.0),
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
                    child: Center(child: LNDSpinner(color: LNDColors.black)),
                  ),
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
                      onPressed: () {
                        controller.removeCoverPhoto(index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
