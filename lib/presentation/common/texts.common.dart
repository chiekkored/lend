import 'package:flutter/material.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool isSelectable;
  final TextAlign? textAlign;
  final bool required;
  final List<LNDText>? textParts;
  final TextDecoration? textDecoration;
  final VoidCallback? onTap;

  const LNDText._(
    this.text,
    this.style,
    this.isSelectable,
    this.textAlign,
    this.required,
    this.textParts,
    this.textDecoration,
    this.onTap,
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
    List<LNDText>? textParts,
    TextDecoration? textDecoration,
    VoidCallback? onTap,
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
      textParts,
      textDecoration,
      onTap,
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
    List<LNDText>? textParts,
    TextDecoration? textDecoration,
    VoidCallback? onTap,
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
      textParts,
      textDecoration,
      onTap,
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
    List<LNDText>? textParts,
    TextDecoration? textDecoration,
    VoidCallback? onTap,
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
      textParts,
      textDecoration,
      onTap,
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
    List<LNDText>? textParts,
    TextDecoration? textDecoration,
    VoidCallback? onTap,
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
      textParts,
      textDecoration,
      onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [
      TextSpan(text: text, style: style.copyWith(decoration: textDecoration)),
      if (required)
        TextSpan(text: '*', style: style.copyWith(color: LNDColors.black)),
      if (textParts != null)
        ...textParts!.map(
          (e) => TextSpan(
            text: e.text,
            style: e.style.copyWith(decoration: textDecoration),
          ),
        ),
    ];

    Widget textWidget =
        isSelectable
            ? SelectableText.rich(
              TextSpan(children: spans),
              textAlign: textAlign,
            )
            : Text.rich(
              TextSpan(children: spans),
              textAlign: textAlign,
              softWrap: true,
            );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: textWidget)
        : textWidget;
  }
}
