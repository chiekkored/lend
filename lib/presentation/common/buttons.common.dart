import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/spinner.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final Color textColor;
  final VoidCallback? onPressed;
  final Color color;
  final bool isLoading;
  final OutlinedBorder? shape;
  final bool hasPadding;
  final bool isButtonText;
  final bool isButtonIcon;
  final IconData? icon;
  final double iconSize;
  final ButtonStyle? style;
  final Widget? child;
  final bool isBold;
  final double? borderRadius;
  final EdgeInsets? padding;

  const LNDButton._({
    required this.text,
    required this.onPressed,
    required this.enabled,
    required this.color,
    this.textColor = LNDColors.white,
    this.isLoading = false,
    this.shape,
    this.hasPadding = true,
    this.isButtonText = false,
    this.isButtonIcon = false,
    this.iconSize = 50.0,
    this.icon,
    this.style,
    this.child,
    this.isBold = false,
    this.borderRadius = 32.0,
    this.padding,
  });

  factory LNDButton.primary({
    required String text,
    required bool enabled,
    required VoidCallback? onPressed,
    Color textColor = LNDColors.white,
    bool isLoading = false,
    bool hasPadding = true,
    EdgeInsets? padding,
  }) {
    return LNDButton._(
      text: text,
      enabled: enabled,
      onPressed: onPressed,
      color: LNDColors.primary,
      textColor: textColor,
      isLoading: isLoading,
      hasPadding: hasPadding,
      padding: padding,
    );
  }

  factory LNDButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    required bool enabled,
    Color? color,
    Color textColor = LNDColors.black,
    bool isLoading = false,
    bool hasPadding = true,
    EdgeInsets? padding,
  }) {
    return LNDButton._(
      text: text,
      enabled: enabled,
      onPressed: onPressed,
      color: color ?? LNDColors.outline,
      textColor: textColor,
      isLoading: isLoading,
      hasPadding: hasPadding,
      padding: padding,
    );
  }

  factory LNDButton.shape({
    required String text,
    required VoidCallback? onPressed,
    required bool enabled,
    required Color color,
    Color textColor = LNDColors.white,
    bool isLoading = false,
    OutlinedBorder? shape,
    bool hasPadding = true,
  }) {
    return LNDButton._(
      text: text,
      enabled: enabled,
      onPressed: onPressed,
      color: color,
      isLoading: isLoading,
      textColor: textColor,
      shape: shape,
      hasPadding: hasPadding,
    );
  }

  factory LNDButton.outlined({
    required String text,
    required VoidCallback? onPressed,
    required bool enabled,
    Color textColor = LNDColors.white,
    bool isLoading = false,
    ButtonStyle? style,
    bool hasPadding = true,
    EdgeInsets? padding,
  }) {
    return LNDButton._(
      text: text,
      enabled: enabled,
      onPressed: onPressed,
      color: Colors.transparent,
      isLoading: isLoading,
      textColor: textColor,
      style: style,
      hasPadding: hasPadding,
      padding: padding,
    );
  }

  factory LNDButton.text({
    required String text,
    required VoidCallback? onPressed,
    required bool enabled,
    required Color color,
    bool isLoading = false,
    bool hasPadding = true,
    double size = 14.0,
    bool isBold = false,
  }) {
    return LNDButton._(
      text: text,
      enabled: enabled,
      onPressed: onPressed,
      color: color,
      isLoading: isLoading,
      hasPadding: hasPadding,
      isButtonText: true,
      iconSize: size,
      isBold: isBold,
    );
  }

  factory LNDButton.icon({
    required IconData icon,
    required VoidCallback? onPressed,
    bool? enabled,
    Color? color,
    bool isLoading = false,
    double size = 50,
  }) {
    return LNDButton._(
      text: '',
      enabled: true,
      onPressed: onPressed,
      color: color ?? LNDColors.black,
      isLoading: isLoading,
      isButtonText: true,
      isButtonIcon: true,
      icon: icon,
      iconSize: size,
    );
  }

  factory LNDButton.widget({
    required Widget child,
    required VoidCallback? onPressed,
    bool? enabled,
    Color? color,
    bool isLoading = false,
    bool hasPadding = true,
    double size = 50,
    double borderRadius = 32.0,
  }) {
    return LNDButton._(
      text: '',
      enabled: true,
      onPressed: onPressed,
      color: color ?? LNDColors.black,
      borderRadius: borderRadius,
      isLoading: isLoading,
      hasPadding: hasPadding,
      isButtonText: true,
      isButtonIcon: true,
      iconSize: size,
      child: child,
    );
  }

  factory LNDButton.back({
    bool? enabled,
    Color? color,
    bool isLoading = false,
    bool hasPadding = true,
    bool closeOverlays = false,
    VoidCallback? onPressed,
    double size = 40,
  }) {
    return LNDButton._(
      text: '',
      enabled: true,
      onPressed: onPressed ?? () => Get.back(closeOverlays: closeOverlays),
      color: color ?? LNDColors.black,
      isLoading: isLoading,
      hasPadding: hasPadding,
      isButtonText: true,
      isButtonIcon: true,
      icon: Icons.chevron_left_rounded,
      iconSize: size,
    );
  }

  factory LNDButton.close({
    bool? enabled,
    Color? color,
    bool isLoading = false,
    bool hasPadding = true,
    double size = 20,
  }) {
    return LNDButton._(
      text: '',
      enabled: true,
      onPressed: () => Get.back(closeOverlays: true),
      color: color ?? LNDColors.black,
      isLoading: isLoading,
      hasPadding: hasPadding,
      isButtonText: true,
      isButtonIcon: true,
      icon: Icons.close_rounded,
      iconSize: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget childContent =
        isLoading
            ? const LNDSpinner()
            : LNDText.bold(text: text, color: textColor);

    final isFuncEnabled =
        enabled
            ? isLoading
                ? null
                : onPressed
            : null;

    if (isButtonText) {
      return CupertinoButton(
        onPressed: isFuncEnabled,
        minSize: iconSize,
        padding: EdgeInsets.zero,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 32.0)),
        color: child != null ? color : null,
        child:
            isLoading
                ? const LNDSpinner()
                : isButtonIcon
                ? child ??
                    Icon(
                      icon,
                      size: iconSize,
                      color: enabled ? color : LNDColors.gray,
                    )
                : isBold
                ? LNDText.bold(
                  text: text,
                  color: enabled ? color : LNDColors.gray,
                  fontSize: iconSize,
                )
                : LNDText.medium(
                  text: text,
                  color: enabled ? color : LNDColors.gray,
                  fontSize: iconSize,
                ),
      );
    } else {
      return OutlinedButton(
        onPressed: isFuncEnabled,
        style:
            style ??
            OutlinedButton.styleFrom(
              padding: hasPadding ? padding : EdgeInsets.zero,
              side: BorderSide.none,
              backgroundColor: enabled ? color : color.withValues(alpha: 0.5),
              shape:
                  shape ??
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius ?? 32.0),
                  ),
            ),
        child:
            hasPadding
                ? Padding(
                  padding:
                      padding ?? const EdgeInsets.symmetric(vertical: 18.0),
                  child: Center(child: childContent),
                )
                : Center(child: childContent),
      );
    }
  }
}
