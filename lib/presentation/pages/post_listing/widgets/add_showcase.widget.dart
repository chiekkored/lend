import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/presentation/pages/photo_view/photo_view.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class AddShowcasePage extends GetView<PostListingController> {
  static const String routeName = '/add-showcase';
  const AddShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LNDColors.white,
        surfaceTintColor: LNDColors.white,
        title: LNDText.bold(text: 'Add Showcase', fontSize: 18.0),
        leading: LNDButton.back(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CupertinoContextMenu.builder(
              actions: [
                CupertinoContextMenuAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  isDefaultAction: true,
                  trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
                  child: const Text('Copy'),
                ),
              ],
              builder: (context, animationController) {
                return LNDButton.icon(
                  icon: Icons.add_photo_alternate_rounded,
                  size: 25.0,
                  onPressed: controller.addShowcasePhotos,
                );
              },
            ),
          ),
        ],
      ),
      body: ColoredBox(
        color: LNDColors.white,
        child: Obx(
          () => MasonryGridView.count(
            padding: const EdgeInsets.all(24.0),
            crossAxisCount: 2,
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
            itemCount: controller.showcasePhotos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                key: UniqueKey(),
                onTap:
                    () => LNDNavigate.toPhotoViewPage(
                      args: PhotoViewArguments(
                        images:
                            controller.showcasePhotos
                                .map((e) => e.value.file?.path ?? '')
                                .toList(),
                        intialIndex: index,
                      ),
                    ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      _AspectRatioImage(
                        imagePath:
                            controller.showcasePhotos[index].value.file?.path ??
                            '',
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
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: LNDButton.icon(
                                    icon: FontAwesomeIcons.xmark,
                                    size: 15.0,
                                    color: LNDColors.black,
                                    onPressed:
                                        () => controller.removeShowcasePhoto(
                                          index,
                                        ),
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
                                controller
                                            .showcasePhotos[index]
                                            .value
                                            .progress
                                            ?.isNaN ??
                                        true
                                    ? const SizedBox.shrink()
                                    : controller
                                            .showcasePhotos[index]
                                            .value
                                            .progress ==
                                        1.0
                                    ? const SizedBox.shrink()
                                    : LinearProgressIndicator(
                                      value:
                                          controller
                                              .showcasePhotos[index]
                                              .value
                                              .progress,
                                      color: LNDColors.primary,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AspectRatioImage extends StatefulWidget {
  final String imagePath;
  const _AspectRatioImage({required this.imagePath});

  @override
  State<_AspectRatioImage> createState() => _AspectRatioImageState();
}

class _AspectRatioImageState extends State<_AspectRatioImage> {
  late final Image _image;
  bool _isLoading = true;
  double _aspectRatio = 1.0;

  @override
  void initState() {
    super.initState();
    _image = Image.file(File(widget.imagePath));
    _image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((info, _) {
            if (mounted) {
              setState(() {
                _aspectRatio = info.image.width / info.image.height;
                _isLoading = false;
              });
            }
          }),
        );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const AspectRatio(
          aspectRatio: 1.0,
          child: Center(child: CircularProgressIndicator.adaptive()),
        )
        : AspectRatio(aspectRatio: _aspectRatio, child: _image);
  }
}
