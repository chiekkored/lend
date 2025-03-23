import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewArguments {
  final List<String> images;
  final int intialIndex;
  PhotoViewArguments({required this.images, required this.intialIndex});
}

class PhotoViewPage extends StatelessWidget {
  static const routeName = '/photo_view';
  PhotoViewPage({super.key});

  final args = Get.arguments as PhotoViewArguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: LNDButton.close(color: Colors.white),
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              args.images[index],
              cacheKey: args.images[index],
            ),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2,
            heroAttributes: PhotoViewHeroAttributes(tag: args.images[index]),
            errorBuilder:
                (context, error, stackTrace) => Center(
                  child: LNDText.regular(text: 'Failed to load image'),
                ),
          );
        },
        itemCount: args.images.length,
        loadingBuilder:
            (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator.adaptive(
                  value:
                      event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                              (event.expectedTotalBytes ?? 0),
                ),
              ),
            ),
        pageController: PageController(initialPage: args.intialIndex),
      ),
    );
  }
}
