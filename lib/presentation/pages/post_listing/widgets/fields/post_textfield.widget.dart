import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class PostTextFieldW extends GetWidget<PostListingController> {
  final TextEditingController textController;
  final String text;
  final bool required;
  final bool? readOnly;
  final String? prefixText;
  final String? suffixText;
  final String? subtitle;
  final String? example;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final int? maxLength;
  final TextCapitalization? textCapitalization;

  const PostTextFieldW({
    super.key,
    required this.textController,
    required this.text,
    required this.required,
    this.readOnly,
    this.prefixText,
    this.suffixText,
    this.subtitle,
    this.example,
    this.keyboardType,
    this.onTap,
    this.maxLength,
    this.textCapitalization,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LNDTextField.form(
            controller: textController,
            labelText: text,
            prefixText: prefixText,
            maxLength: maxLength ?? 100,
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
            textCapitalization:
                textCapitalization ?? TextCapitalization.sentences,
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
}
