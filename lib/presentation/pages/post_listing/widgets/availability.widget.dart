import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/enums/availability.enum.dart';

class AvailabilityW extends GetView<PostListingController> {
  const AvailabilityW({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LNDText.bold(text: 'Availability', fontSize: 18.0),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: LNDColors.outline,
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LNDText.semibold(text: 'This item is...', fontSize: 16.0),
              ...Availability.values.map((availability) {
                return Obx(
                  () => RadioListTile<Availability>.adaptive(
                    title: LNDText.regular(text: availability.label),
                    subtitle:
                        availability.subtitle.isNotEmpty
                            ? LNDText.regular(
                              text: availability.subtitle,
                              fontSize: 12.0,
                              color: LNDColors.hint,
                            )
                            : null,
                    radioScaleFactor: 1.5,
                    dense: true,
                    value: availability,
                    groupValue: controller.availability.value,
                    onChanged: controller.onChangedAvailability,
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
