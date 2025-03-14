import 'package:flutter/material.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool isSelectable;
  final TextAlign? textAlign;
  final bool required;

  const LNDText._(
    this.text,
    this.style,
    this.isSelectable,
    this.textAlign,
    this.required,
  );

  static TextStyle get regularStyle => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        fontStyle: FontStyle.normal,
        color: LNDColors.black,
        overflow: TextOverflow.ellipsis,
      );

  static TextStyle get mediumStyle => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontStyle: FontStyle.normal,
        color: LNDColors.black,
        overflow: TextOverflow.ellipsis,
      );

  static TextStyle get semiboldStyle => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontStyle: FontStyle.normal,
        color: LNDColors.black,
        overflow: TextOverflow.ellipsis,
      );

  static TextStyle get boldStyle => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        fontStyle: FontStyle.normal,
        color: LNDColors.black,
        overflow: TextOverflow.ellipsis,
      );

  factory LNDText.regular({
    required String text,
    Color color = LNDColors.black,
    double fontSize = 14,
    FontStyle fontStyle = FontStyle.normal,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool isSelectable = false,
    TextAlign? textAlign,
    bool required = false,
  }) {
    return LNDText._(
      text,
      regularStyle.copyWith(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
        overflow: overflow,
      ),
      isSelectable,
      textAlign,
      required,
    );
  }

  factory LNDText.medium({
    required String text,
    Color color = LNDColors.black,
    double fontSize = 14,
    FontStyle fontStyle = FontStyle.normal,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool isSelectable = false,
    TextAlign? textAlign,
    bool required = false,
  }) {
    return LNDText._(
      text,
      mediumStyle.copyWith(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
        overflow: overflow,
      ),
      isSelectable,
      textAlign,
      required,
    );
  }

  factory LNDText.semibold({
    required String text,
    Color color = LNDColors.black,
    double fontSize = 14,
    FontStyle fontStyle = FontStyle.normal,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool isSelectable = false,
    TextAlign? textAlign,
    bool required = false,
  }) {
    return LNDText._(
      text,
      semiboldStyle.copyWith(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
        overflow: overflow,
      ),
      isSelectable,
      textAlign,
      required,
    );
  }

  factory LNDText.bold({
    required String text,
    Color color = LNDColors.black,
    double fontSize = 14,
    FontStyle fontStyle = FontStyle.normal,
    TextOverflow overflow = TextOverflow.ellipsis,
    bool isSelectable = false,
    TextAlign? textAlign,
    bool required = false,
  }) {
    return LNDText._(
      text,
      boldStyle.copyWith(
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
        overflow: overflow,
      ),
      isSelectable,
      textAlign,
      required,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isSelectable
        ? SelectableText.rich(
            TextSpan(
              text: text,
              children: [
                if (required)
                  TextSpan(
                    text: '*',
                    style: style.copyWith(color: LNDColors.black),
                  ),
              ],
            ),
            style: style,
            textAlign: textAlign,
          )
        : Text.rich(
            TextSpan(
              text: text,
              children: [
                if (required)
                  TextSpan(
                    text: '*',
                    style: style.copyWith(color: LNDColors.black),
                  ),
              ],
            ),
            style: style,
            textAlign: textAlign,
          );
  }
}
