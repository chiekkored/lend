import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class PostSwitchFieldW extends GetWidget<PostListingController> {
  final String label;
  final IconData icon;
  final RxBool value;
  final String? subtitle;
  const PostSwitchFieldW({
    required this.label,
    required this.icon,
    required this.value,
    this.subtitle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                  text: subtitle ?? '',
                  fontSize: 12.0,
                  color: LNDColors.hint,
                  overflow: TextOverflow.visible,
                )
                : null,
        onChanged: (_) => value.toggle(),
      ),
    );
  }
}
