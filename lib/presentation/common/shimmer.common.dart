import 'package:flutter/widgets.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:shimmer/shimmer.dart';

class LNDShimmer extends StatelessWidget {
  final Widget child;
  const LNDShimmer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: LNDColors.outline,
      highlightColor: LNDColors.white,
      child: child,
    );
  }
}

class LNDShimmerBox extends StatelessWidget {
  final double height;
  final double width;
  final Widget? child;
  const LNDShimmerBox({
    required this.height,
    required this.width,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: LNDColors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: child,
    );
  }
}

class LNDShimmerCircle extends StatelessWidget {
  final double size;
  final Widget? child;

  const LNDShimmerCircle({required this.size, this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return LNDShimmer(
      child: Container(
        height: size,
        width: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: LNDColors.white,
        ),
        child: child,
      ),
    );
  }
}
