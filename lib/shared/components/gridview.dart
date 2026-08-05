import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/size.dart';

class RAGridView extends StatelessWidget {
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final double? mainAxisHeight;
  final int itemCount;
  final Widget Function(int index) itemBuilder;

  const RAGridView({
    super.key,
    required this.crossAxisCount,
    required this.crossAxisSpacing,
    required this.mainAxisSpacing,
    required this.itemCount,
    required this.itemBuilder,
    this.mainAxisHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (crossAxisCount - 1) * sizeW(crossAxisSpacing)) / crossAxisCount;

        return Wrap(
          spacing: sizeW(crossAxisSpacing),
          runSpacing: size(mainAxisSpacing),
          children: List.generate(
            itemCount,
            (index) {
              return SizedBox(
                width: itemWidth,
                height: mainAxisHeight ?? itemWidth,
                child: itemBuilder(index),
              );
            },
          ),
        );
      },
    );
  }
}
