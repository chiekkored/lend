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
  });

  factory LNDButton.primary({
    required String text,
    required bool enabled,
    required VoidCallback? onPressed,
    Color textColor = LNDColors.white,
    bool isLoading = false,
    bool hasPadding = true,
  }) {
    return LNDButton._(
      text: text,
      enabled: enabled,
      onPressed: onPressed,
      color: LNDColors.primary,
      textColor: textColor,
      isLoading: isLoading,
      hasPadding: hasPadding,
    );
  }

  factory LNDButton.secondary({
    required String text,
    required VoidCallback? onPressed,
    required bool enabled,
    Color textColor = LNDColors.black,
    bool isLoading = false,
    bool hasPadding = true,
  }) {
    return LNDButton._(
      text: text,
      enabled: enabled,
      onPressed: onPressed,
      color: LNDColors.hint,
      textColor: textColor,
      isLoading: isLoading,
      hasPadding: hasPadding,
    );
  }

  factory LNDButton.custom({
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
    );
  }

  factory LNDButton.icon({
    required IconData icon,
    required VoidCallback? onPressed,
    bool? enabled,
    Color? color,
    bool isLoading = false,
    bool hasPadding = true,
    double size = 50,
  }) {
    return LNDButton._(
      text: '',
      enabled: true,
      onPressed: onPressed,
      color: color ?? LNDColors.black,
      isLoading: isLoading,
      hasPadding: hasPadding,
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
  }) {
    return LNDButton._(
      text: '',
      enabled: true,
      onPressed: onPressed,
      color: color ?? LNDColors.black,
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
    double size = 40,
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
      icon: Icons.chevron_left_rounded,
      iconSize: size,
    );
  }

  factory LNDButton.close({
    bool? enabled,
    Color? color,
    bool isLoading = false,
    bool hasPadding = true,
    double size = 30,
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
        color: child != null ? color : null,
        child:
            isLoading
                ? const LNDSpinner()
                : isButtonIcon
                ? child ??
                    Icon(
                      icon,
                      size: iconSize,
                      color: enabled ? color : LNDColors.black,
                    )
                : LNDText.medium(
                  text: text,
                  color: enabled ? color : LNDColors.disabled,
                  fontSize: iconSize,
                ),
      );
    } else {
      return OutlinedButton(
        onPressed: isFuncEnabled,
        style:
            style ??
            OutlinedButton.styleFrom(
              side: BorderSide.none,
              backgroundColor: enabled ? color : color.withValues(alpha: 0.5),
              shape:
                  shape ??
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
            ),
        child:
            hasPadding
                ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Center(child: childContent),
                )
                : Center(child: childContent),
      );
    }
  }
}
