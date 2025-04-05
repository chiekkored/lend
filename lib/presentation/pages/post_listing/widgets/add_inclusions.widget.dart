import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/buttons.common.dart';
import 'package:lend/presentation/common/textfields.common.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/presentation/controllers/post_listing/post_listing.controller.dart';
import 'package:lend/utilities/constants/colors.constant.dart';
import 'package:lend/utilities/extensions/widget.extension.dart';

class AddInclusions extends GetView<PostListingController> {
  const AddInclusions({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: LNDColors.white,
        appBar: AppBar(
          leading: LNDButton.close(),
          title: LNDText.bold(text: 'Add Inclusions', fontSize: 18.0),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.inclusions.length,
                    itemBuilder: (_, index) {
                      final inclusion = controller.inclusions[index];
                      return ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.check_circle_rounded,
                          color: LNDColors.success,
                        ),
                        title: LNDText.regular(text: inclusion),
                        trailing: LNDButton.icon(
                          icon: Icons.delete,
                          color: LNDColors.danger,
                          size: 25.0,
                          onPressed: () => controller.removeInclusion(index),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 8.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LNDText.regular(
                      text:
                          'Inclusions should be clear and specific. List all '
                          'items, accessories, or services provided with the '
                          'rental to avoid misunderstandings.',
                      color: LNDColors.hint,
                      fontSize: 12.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: LNDTextField.form(
                            controller: controller.inclusionController,
                            autofocus: true,
                            textInputAction: TextInputAction.continueAction,
                            onFieldSubmitted: (_) => controller.addInclusion(),
                          ),
                        ),
                        LNDButton.primary(
                          text: 'Add',
                          enabled: true,
                          onPressed: controller.addInclusion,
                        ),
                      ],
                    ).withSpacing(16.0),
                  ],
                ).withSpacing(8.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
