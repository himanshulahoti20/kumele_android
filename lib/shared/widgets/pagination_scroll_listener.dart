import 'package:flutter/material.dart';

class PaginationScrollListener extends StatelessWidget {
  const PaginationScrollListener({
    super.key,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.child,
    this.threshold = 70,
  });

  final bool isLoadingMore;
  final VoidCallback? onLoadMore;
  final Widget child;
  final int threshold;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (isLoadingMore || onLoadMore == null) return false;

        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - threshold) {
          onLoadMore!();
        }
        return false;
      },
      child: child,
    );
  }
}
