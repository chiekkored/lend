import 'package:flutter/material.dart';

mixin LNDScrollMixin {
  final ScrollController scrollController = ScrollController();

  /// Scroll to the top of the page
  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
