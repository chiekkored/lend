import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class PostRateFieldW extends GetWidget<PostListingController> {
  final TextEditingController textController;
  final String text;
  final String? suffixText;
  final String? subtitle;
  final String? example;
  const PostRateFieldW({
    required this.textController,
    required this.text,
    this.suffixText,
    this.subtitle,
    this.example,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
