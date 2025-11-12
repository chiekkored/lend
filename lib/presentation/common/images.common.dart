import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/image_type.enum.dart';
import 'package:shimmer/shimmer.dart';

class LNDImage extends StatelessWidget {
  final String? imageUrl;
  final double? size;
  final double borderRadius;
  final double height;
  final double width;
  final ImageType imageType;
  static const String _fallbackUser = 'assets/svg/default_avatar.svg';
  static const String _fallbackAsset = 'assets/svg/image.svg';

  const LNDImage._({
    required this.imageUrl,
    this.size,
    this.borderRadius = 12.0,
    this.height = 50.0,
    this.width = 50.0,
    this.imageType = ImageType.asset,
  });

  factory LNDImage.circle({
    required String? imageUrl,
    double size = 50.0,
    ImageType imageType = ImageType.asset,
  }) {
    return LNDImage._(
      imageUrl: imageUrl,
      size: size,
      borderRadius: size / 2,
      imageType: imageType,
    );
  }

  factory LNDImage.square({
    required String? imageUrl,
    double size = 50.0,
    double borderRadius = 12.0,
    ImageType imageType = ImageType.asset,
  }) {
    return LNDImage._(
      imageUrl: imageUrl,
      size: size,
      borderRadius: borderRadius,
      imageType: imageType,
    );
  }

  factory LNDImage.custom({
    required String? imageUrl,
    required double height,
    required double width,
    double borderRadius = 12.0,
  }) {
    return LNDImage._(
      imageUrl: imageUrl,
      height: height,
      width: width,
      borderRadius: borderRadius,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? height,
      width: size ?? width,
      child: _loadImage(imageUrl),
    );
  }

  Widget _loadImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildFallbackImage();
    } else if (Uri.tryParse(imageUrl)?.hasScheme ?? false) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        cacheKey: imageUrl,
        placeholder:
            (context, s) => ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Shimmer.fromColors(
                baseColor: LNDColors.outline,
                highlightColor: LNDColors.white,
                child: const ColoredBox(color: LNDColors.outline),
              ),
            ),
        imageBuilder: (_, imageProvider) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Image(image: imageProvider, fit: BoxFit.cover),
          );
        },
        errorWidget: (_, __, ___) => _buildFallbackImage(),
      );
    } else if (File(imageUrl).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.file(
          File((imageUrl)),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallbackImage(),
        ),
      );
    } else {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      // child: Image.asset(_fallbackAsset, fit: BoxFit.cover),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        color: LNDColors.white,
        child: SvgPicture.asset(
          fit: BoxFit.scaleDown,
          imageType == ImageType.user ? _fallbackUser : _fallbackAsset,
        ),
      ),
    );
  }
}
