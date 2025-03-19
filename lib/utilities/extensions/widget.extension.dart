import 'package:flutter/widgets.dart';

/// Extension to add spacing between widgets in a [Row] or [Column].
extension SpacingExtension on Widget {
  Widget withSpacing(double spacing) {
    if (this is! MultiChildRenderObjectWidget) {
      return this; // If not a Row or Column, just return the widget itself.
    }

    List<Widget> spacedChildren = [];
    List<Widget> children = (this as MultiChildRenderObjectWidget).children;

    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        if (this is Row) {
          spacedChildren.add(SizedBox(width: spacing));
        } else if (this is Column) {
          spacedChildren.add(SizedBox(height: spacing));
        }
      }
    }

    if (this is Row) {
      Row original = this as Row;
      return Row(
        mainAxisSize: original.mainAxisSize,
        mainAxisAlignment: original.mainAxisAlignment,
        crossAxisAlignment: original.crossAxisAlignment,
        textDirection: original.textDirection,
        verticalDirection: original.verticalDirection,
        textBaseline: original.textBaseline,
        children: spacedChildren,
      );
    } else if (this is Column) {
      Column original = this as Column;
      return Column(
        mainAxisSize: original.mainAxisSize,
        mainAxisAlignment: original.mainAxisAlignment,
        crossAxisAlignment: original.crossAxisAlignment,
        textDirection: original.textDirection,
        verticalDirection: original.verticalDirection,
        textBaseline: original.textBaseline,
        children: spacedChildren,
      );
    } else {
      return this;
    }
  }
}
