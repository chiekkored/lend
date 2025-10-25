import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/pages/photo_view/photo_view.page.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/helpers/navigator.helper.dart';

class ProductShowcaseArguments {
  final List<String> showcase;
  const ProductShowcaseArguments({required this.showcase});
}

class ProductShowcasePage extends StatelessWidget {
  static const routeName = '/product_showcase';
  ProductShowcasePage({super.key});

  final args = Get.arguments as ProductShowcaseArguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LNDColors.white,
        surfaceTintColor: LNDColors.white,
        leading: LNDButton.back(),
      ),
      body: ColoredBox(
        color: LNDColors.white,
        child: MasonryGridView.count(
          padding: const EdgeInsets.all(24.0),
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          itemCount: args.showcase.length,
          itemBuilder: (context, index) {
            // final tag = '${}: all';
            return GestureDetector(
              onTap:
                  () => LNDNavigate.toPhotoViewPage(
                    args: PhotoViewArguments(
                      images: args.showcase,
                      intialIndex: index,
                    ),
                  ),
              child: Hero(
                tag: '${args.showcase[index]} $index',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _AspectRatioImage(imageUrl: args.showcase[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AspectRatioImage extends StatefulWidget {
  final String imageUrl;
  const _AspectRatioImage({required this.imageUrl});

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
    _image = Image.network(widget.imageUrl);
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
