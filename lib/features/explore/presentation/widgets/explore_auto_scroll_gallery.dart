import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ExploreAutoScrollGrid extends StatefulWidget {
  const ExploreAutoScrollGrid({super.key, required this.height});

  final double height;

  @override
  State<ExploreAutoScrollGrid> createState() => _ExploreAutoScrollGridState();
}

class _ExploreAutoScrollGridState extends State<ExploreAutoScrollGrid> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (!_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
      return;
    }

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_scrollController.hasClients) return;

      if (_scrollController.offset <= 0) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.jumpTo(_scrollController.offset - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final itemWidth = responsive.pick(
      mobilePortrait: 100.0,
      tabletPortrait: 100.0,
      tabletLandscape: 300.0,
    );

    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ColorSet.bg3Color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GridView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.77,
        ),
        itemCount: ExploreConfig.galleryImagePaths.length,
        itemBuilder: (context, index) {
          return KumeleAssetWidget(
            assetPath: ExploreConfig.galleryImagePaths[index],
            width: responsive.w(itemWidth),
            height: responsive.w(180),
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}

class ExploreAutoScrollList extends StatefulWidget {
  const ExploreAutoScrollList({super.key});

  @override
  State<ExploreAutoScrollList> createState() => _ExploreAutoScrollListState();
}

class _ExploreAutoScrollListState extends State<ExploreAutoScrollList> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    if (!_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
      return;
    }

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_scrollController.hasClients) return;

      if (_scrollController.offset <= 0) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.jumpTo(_scrollController.offset - 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: ColorSet.bg3Color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: ExploreConfig.galleryImagePaths.length,
        itemBuilder: (context, index) {
          return Container(
            width: 130,
            margin: const EdgeInsets.only(right: 10),
            child: KumeleAssetWidget(
              assetPath: ExploreConfig.galleryImagePaths[index],
              width: 130,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
