import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDTextField extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final InputDecoration decoration;
  final void Function(String)? onChanged;
  final bool autofocus;
  final void Function(String)? onFieldSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final String? Function(String?)? validator;

  const LNDTextField._(
    this.controller,
    this.obscureText,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.decoration,
    this.autofocus,
    this.onFieldSubmitted,
    this.onTap,
    this.readOnly,
    this.textCapitalization,
    this.maxLines,
    this.validator,
  );

  static InputDecoration inputDecoration({
    required double borderRadius,
    required String hintText,
  }) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: LNDColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: LNDColors.primary),
      ),
      hintText: hintText,
      hintStyle: LNDText.mediumStyle.copyWith(color: LNDColors.outline),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  factory LNDTextField.textBox({
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    double borderRadius = 32.0,
    void Function(String)? onChanged,
    bool autofocus = false,
    void Function(String)? onFieldSubmitted,
    VoidCallback? onTap,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return LNDTextField._(
      controller,
      false,
      keyboardType,
      textInputAction,
      onChanged,
      InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: LNDColors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: LNDColors.primary),
        ),
        hintText: hintText,
        hintStyle: LNDText.mediumStyle.copyWith(color: LNDColors.outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      autofocus,
      onFieldSubmitted,
      onTap,
      readOnly,
      textCapitalization,
      maxLines,
      validator,
    );
  }

  factory LNDTextField.regular({
    required TextEditingController? controller,
    String? hintText,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    double borderRadius = 32.0,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? prefixIconSize,
    double? suffixIconSize,
    Color? prefixIconColor,
    Color? suffixIconColor,
    Widget? suffixWidget,
    void Function()? onTapSuffix,
    void Function(String)? onChanged,
    bool autofocus = false,
    void Function(String)? onFieldSubmitted,
    VoidCallback? onTap,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    String? Function(String?)? validator,
  }) {
    return LNDTextField._(
      controller,
      obscureText,
      keyboardType,
      textInputAction,
      onChanged,
      InputDecoration(
        labelText: hintText,
        errorText: errorText,
        errorStyle: LNDText.mediumStyle.copyWith(
          color: LNDColors.danger,
          overflow: TextOverflow.visible,
        ),
        fillColor: LNDColors.outline,
        filled: true,
        floatingLabelStyle: LNDText.mediumStyle,
        labelStyle: LNDText.mediumStyle.copyWith(fontSize: 12.0),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: LNDColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: LNDColors.primary),
        ),
        prefixIcon:
            prefixIcon != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 26.0, right: 12.0),
                  child: Icon(
                    prefixIcon,
                    color: prefixIconColor ?? LNDColors.black,
                    size: prefixIconSize,
                  ),
                )
                : null,
        suffixIcon:
            suffixWidget ??
            (suffixIcon != null
                ? GestureDetector(
                  onTap: () {
                    onTapSuffix?.call();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 26.0, left: 12.0),
                    child: Icon(
                      suffixIcon,
                      color: suffixIconColor ?? LNDColors.black,
                      size: suffixIconSize,
                    ),
                  ),
                )
                : null),
        hintStyle: LNDText.mediumStyle.copyWith(color: LNDColors.outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      autofocus,
      onFieldSubmitted,
      onTap,
      readOnly,
      textCapitalization,
      1,
      validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: LNDText.regularStyle.copyWith(
        color: readOnly && onTap == null ? LNDColors.gray : LNDColors.black,
      ),
      maxLines: maxLines,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: decoration,
      autofocus: autofocus,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      validator: validator,
      inputFormatters: [
        if (keyboardType == TextInputType.number)
          FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }
}
