import 'package:flutter/material.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class EditRates extends StatelessWidget {
  const EditRates({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              LNDText.bold(text: 'Custom Rates', fontSize: 24.0),
              LNDButton.text(
                text: 'Apply',
                onPressed: () {},
                enabled: true,
                color: LNDColors.primary,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LNDTextField.money(
                controller: TextEditingController(),
                hintText: 'Weekly rate',
                borderRadius: 12.0,
              ),
              LNDText.regular(
                text: 'Discount: ',
                fontSize: 12.0,
                color: LNDColors.hint,
                textParts: [
                  LNDText.regular(
                    text: '-₱100',
                    color: LNDColors.success,
                    fontSize: 12.0,
                  ),
                ],
              ),
              LNDTextField.money(
                controller: TextEditingController(),
                hintText: 'Monthly rate',
                borderRadius: 12.0,
              ),
              LNDText.regular(
                text: 'Discount: ',
                fontSize: 12.0,
                color: LNDColors.hint,
                textParts: [
                  LNDText.regular(
                    text: '-₱100',
                    color: LNDColors.success,
                    fontSize: 12.0,
                  ),
                ],
              ),
              LNDTextField.money(
                controller: TextEditingController(),
                hintText: 'Annual rate',
                borderRadius: 12.0,
              ),
              LNDText.regular(
                text: 'Discount: ',
                fontSize: 12.0,
                color: LNDColors.hint,
                textParts: [
                  LNDText.regular(
                    text: '-₱100',
                    color: LNDColors.success,
                    fontSize: 12.0,
                  ),
                ],
              ),
            ],
          ).withSpacing(8.0),
        ),
      ],
    );
  }
}
