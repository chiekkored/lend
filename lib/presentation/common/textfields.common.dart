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

  // static InputDecoration inputDecoration({
  //   required double borderRadius,
  //   required String? labelText,
  // }) {
  //   return InputDecoration(
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(borderRadius),
  //       borderSide: const BorderSide(color: LNDColors.black),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(borderRadius),
  //       borderSide: const BorderSide(color: LNDColors.primary),
  //     ),
  //     labelText: labelText,
  //     hintStyle: LNDText.mediumStyle.copyWith(color: LNDColors.outline),
  //     border: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(borderRadius),
  //     ),
  //   );
  // }

  static InputDecoration inputDecoration({
    String? hintText,
    String? labelText,
    String? errorText,
    double? borderRadius,
    IconData? prefixIcon,
    Color? prefixIconColor,
    double? prefixIconSize,
    Widget? prefixWidget,
    Widget? suffixWidget,
    String? prefixText,
    TextStyle? prefixStyle,
    String? suffixText,
    IconData? suffixIcon,
    void Function()? onTapSuffix,
    Color? suffixIconColor,
    double? suffixIconSize,
    String? helperText,
    bool? required,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: LNDText.mediumStyle.copyWith(color: LNDColors.hint),
      label:
          hintText == null
              ? LNDText.medium(
                text: labelText ?? '',
                textParts: [
                  if (required ?? false)
                    LNDText.medium(text: '*', color: LNDColors.danger),
                ],
              )
              : null,
      helper:
          helperText == null
              ? null
              : LNDText.regular(
                text: helperText,
                fontSize: 12.0,
                color: LNDColors.hint,
              ),
      errorText: errorText,
      errorStyle: LNDText.mediumStyle.copyWith(
        color: LNDColors.danger,
        overflow: TextOverflow.visible,
      ),
      fillColor: LNDColors.outline,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        borderSide: const BorderSide(color: LNDColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
        borderSide: const BorderSide(color: LNDColors.primary),
      ),
      prefixText: prefixText,
      prefixStyle:
          prefixStyle ??
          LNDText.mediumStyle.copyWith(color: LNDColors.black, fontSize: 12.0),
      prefix: prefixWidget,
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
      suffixIconConstraints: const BoxConstraints(maxHeight: double.infinity),
      suffixText: suffixText,
      suffixStyle: LNDText.mediumStyle.copyWith(
        color: LNDColors.black,
        fontSize: 12.0,
      ),
      suffix: suffixWidget,
      suffixIcon:
          suffixIcon != null
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
              : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 16.0),
      ),
    );
  }

  factory LNDTextField.textBox({
    required TextEditingController? controller,
    String? hintText,
    String? labelText,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.multiline,
    TextInputAction textInputAction = TextInputAction.newline,
    double borderRadius = 32.0,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? prefixIconSize,
    double? suffixIconSize,
    Color? prefixIconColor,
    Color? suffixIconColor,
    Widget? prefixWidget,
    Widget? suffixWidget,
    String? prefixText,
    TextStyle? prefixStyle,
    String? suffixText,
    void Function()? onTapSuffix,
    void Function(String)? onChanged,
    bool autofocus = false,
    void Function(String)? onFieldSubmitted,
    VoidCallback? onTap,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    String? Function(String?)? validator,
    int maxLines = 3,
    String? helperText,
    bool? required,
  }) {
    return LNDTextField._(
      controller,
      false,
      keyboardType,
      textInputAction,
      onChanged,
      inputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        borderRadius: borderRadius,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        prefixIconSize: prefixIconSize,
        suffixWidget: suffixWidget,
        prefixWidget: prefixWidget,
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        onTapSuffix: onTapSuffix,
        suffixIconColor: suffixIconColor,
        suffixIconSize: suffixIconSize,
        helperText: helperText,
        required: required,
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
    String? labelText,
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
    Widget? prefixWidget,
    Widget? suffixWidget,
    String? prefixText,
    TextStyle? prefixStyle,
    String? suffixText,
    void Function()? onTapSuffix,
    void Function(String)? onChanged,
    bool autofocus = false,
    void Function(String)? onFieldSubmitted,
    VoidCallback? onTap,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? helperText,
    bool? required,
  }) {
    return LNDTextField._(
      controller,
      obscureText,
      keyboardType,
      textInputAction,
      onChanged,
      inputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        borderRadius: borderRadius,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        prefixIconSize: prefixIconSize,
        prefixWidget: prefixWidget,
        suffixWidget: suffixWidget,
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        onTapSuffix: onTapSuffix,
        suffixIconColor: suffixIconColor,
        suffixIconSize: suffixIconSize,
        helperText: helperText,
        required: required,
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

  factory LNDTextField.form({
    required TextEditingController? controller,
    String? hintText,
    String? labelText,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    double borderRadius = 12.0,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? prefixIconSize,
    double? suffixIconSize,
    Color? prefixIconColor,
    Color? suffixIconColor,
    Widget? prefixWidget,
    Widget? suffixWidget,
    String? prefixText,
    TextStyle? prefixStyle,
    String? suffixText,
    void Function()? onTapSuffix,
    void Function(String)? onChanged,
    bool autofocus = false,
    void Function(String)? onFieldSubmitted,
    VoidCallback? onTap,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.sentences,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? helperText,
    bool? required,
  }) {
    return LNDTextField._(
      controller,
      obscureText,
      keyboardType,
      textInputAction,
      onChanged,
      inputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        borderRadius: borderRadius,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        prefixIconSize: prefixIconSize,
        prefixWidget: prefixWidget,
        suffixWidget: suffixWidget,
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        onTapSuffix: onTapSuffix,
        suffixIconColor: suffixIconColor,
        suffixIconSize: suffixIconSize,
        helperText: helperText,
        required: required,
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

  factory LNDTextField.money({
    required TextEditingController? controller,
    String? hintText,
    String? labelText,
    String? errorText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.number,
    TextInputAction textInputAction = TextInputAction.next,
    double borderRadius = 32.0,
    IconData? prefixIcon,
    IconData? suffixIcon,
    double? prefixIconSize,
    double? suffixIconSize,
    Color? prefixIconColor,
    Color? suffixIconColor,
    Widget? prefixWidget,
    Widget? suffixWidget,
    String? prefixText = '₱',
    TextStyle? prefixStyle,
    String? suffixText,
    void Function()? onTapSuffix,
    void Function(String)? onChanged,
    bool autofocus = false,
    void Function(String)? onFieldSubmitted,
    VoidCallback? onTap,
    bool readOnly = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? helperText,
    bool? required,
  }) {
    return LNDTextField._(
      controller,
      obscureText,
      keyboardType,
      textInputAction,
      onChanged,
      inputDecoration(
        hintText: hintText,
        labelText: labelText,
        errorText: errorText,
        borderRadius: borderRadius,
        prefixIcon: prefixIcon,
        prefixIconColor: prefixIconColor,
        prefixIconSize: prefixIconSize,
        prefixWidget: prefixWidget,
        suffixWidget: suffixWidget,
        prefixText: prefixText,
        prefixStyle: LNDText.mediumStyle.copyWith(
          color: LNDColors.black,
          fontSize: 16.0,
        ),
        suffixText: suffixText,
        suffixIcon: suffixIcon,
        onTapSuffix: onTapSuffix,
        suffixIconColor: suffixIconColor,
        suffixIconSize: suffixIconSize,
        helperText: helperText,
        required: required,
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

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: LNDText.regularStyle.copyWith(
        color: readOnly && onTap == null ? LNDColors.gray : LNDColors.black,
      ),
      minLines: 1,
      maxLines: maxLines,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: decoration,
      autofocus: autofocus,
      onFieldSubmitted: onFieldSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      validator: validator,
      inputFormatters: [
        if (maxLines == 1) FilteringTextInputFormatter.singleLineFormatter,
        if (keyboardType == TextInputType.number) _NumberFormatter(),
      ],
    );
  }
}

class _NumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Allow only digits, no decimal point
    final String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // If the new text is empty, return an empty value
    if (newText.isEmpty) {
      return const TextEditingValue();
    }

    // Remove leading zeros, but allow a single 0
    String sanitizedText = newText;
    if (sanitizedText.startsWith('0') && sanitizedText.length > 1) {
      sanitizedText = sanitizedText.replaceFirst(RegExp(r'^0+'), '');
      // If all digits were zeros, keep one zero
      if (sanitizedText.isEmpty) {
        sanitizedText = '0';
      }
    }

    // Limit to 9 digits
    String limitedText = sanitizedText;
    if (limitedText.length > 9) {
      limitedText = limitedText.substring(0, 9);
    }

    // Add commas to the number for formatting
    final formattedNumber = limitedText.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );

    return TextEditingValue(
      text: formattedNumber,
      selection: TextSelection.collapsed(offset: formattedNumber.length),
    );
  }
}
