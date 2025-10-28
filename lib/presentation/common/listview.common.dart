import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lend/presentation/common/texts.common.dart';
import 'package:lend/utilities/constants/colors.constant.dart';

class LNDListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T item, int index) itemBuilder;
  final Future<void> Function()? onRefresh;
  final Widget? emptyWidget;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final bool primary;
  final ScrollPhysics? physics;
  final String emptyString;

  const LNDListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.onRefresh,
    this.emptyWidget,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.shrinkWrap = false,
    this.primary = false,
    this.physics,
    this.emptyString = 'No data available',
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh ?? () async {},
      child:
          items.isEmpty
              ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: Get.height * 0.6,
                    child: Center(
                      child:
                          emptyWidget ??
                          LNDText.regular(
                            text: emptyString,
                            color: LNDColors.hint,
                          ),
                    ),
                  ),
                ],
              )
              : ListView.builder(
                padding: padding,
                shrinkWrap: shrinkWrap,
                primary: primary,
                physics: physics ?? const AlwaysScrollableScrollPhysics(),
                scrollDirection: scrollDirection,
                itemCount: items.length,
                itemBuilder: (_, index) {
                  final item = items[index];
                  return itemBuilder(item, index);
                },
              ),
    );
  }
}
