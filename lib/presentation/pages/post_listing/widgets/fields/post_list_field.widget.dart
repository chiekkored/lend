import 'package:flutter/material.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class PostListFieldW extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onTap;
  final String? subtitle;
  final String? count;
  final Widget? trailing;
  final String? value;
  const PostListFieldW({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.count,
    this.trailing,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: ListTile(
        visualDensity: VisualDensity.comfortable,
        contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
        title: LNDText.medium(
          text: label,
          textParts: [
            if (value?.isNotEmpty ?? false) ...[
              LNDText.bold(text: ': '),
              LNDText.bold(text: value ?? '', color: LNDColors.primary),
            ],
          ],
        ),
        leading: Icon(icon),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Trailing or count widget only
            if (trailing != null)
              trailing ?? const SizedBox.shrink()
            else if (count != null)
              Chip(
                label: LNDText.regular(
                  text: count ?? '',
                  color: LNDColors.white,
                ),
                color: const WidgetStatePropertyAll(LNDColors.primary),
                shape: const CircleBorder(
                  side: BorderSide(color: LNDColors.primary),
                ),
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
              ),

            const Icon(Icons.chevron_right_rounded, color: LNDColors.hint),
          ],
        ),
        subtitle:
            (subtitle?.isNotEmpty ?? false)
                ? LNDText.regular(
                  text: subtitle ?? '',
                  fontSize: 12.0,
                  color: LNDColors.hint,
                  overflow: TextOverflow.visible,
                )
                : null,
        onTap: onTap,
      ),
    );
  }
}
