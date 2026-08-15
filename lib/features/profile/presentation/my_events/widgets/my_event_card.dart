import 'package:flutter/material.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/explore/presentation/explore_config.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/app_shadows.dart';
import 'package:kuemele/shared/components/event_card/widgets/category_tag.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class MyEventCard extends StatelessWidget {
  const MyEventCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.category,
    required this.time,
    required this.price,
    required this.startTime,
    this.location,
    this.onTap,
    this.bgColor,
  });

  factory MyEventCard.fromItem(
    ExploreEventItem event, {
    VoidCallback? onTap,
  }) {
    return MyEventCard(
      title: event.title,
      imagePath: event.imagePath,
      category: event.category ?? '',
      time: event.time,
      price: event.price,
      startTime: event.startTime,
      location: event.location,
      onTap: onTap,
    );
  }

  /// Skeleton stand-in shown while the real events load.
  factory MyEventCard.placeholder(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return MyEventCard(
      title: l10n.myEventPlaceholderTitle,
      imagePath: '',
      category: l10n.blogPlaceholderCategoryName,
      time: l10n.myEventPlaceholderTime,
      price: l10n.free,
      startTime: l10n.myEventPlaceholderStartTime,
      location: l10n.myEventPlaceholderLocation,
    );
  }

  final String title;
  final String imagePath;
  final String category;
  final String time;
  final String price;
  final String startTime;
  final String? location;
  final VoidCallback? onTap;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final radius = responsive.w(14);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? ColorSet.bg2Color,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: AppShadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 11, child: _buildImage(context)),
              Expanded(flex: 9, child: _buildContent(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final responsive = context.responsive;

    return Stack(
      fit: StackFit.expand,
      children: [
        if (imagePath.isNotEmpty)
          Positioned.fill(
            child: KumeleAssetWidget(
              assetPath: imagePath,
              fit: BoxFit.cover,
            ),
          )
        else
          ColoredBox(
            color: ColorSet.tileFillColor,
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: responsive.w(32),
                color: ColorSet.subTextColor,
              ),
            ),
          ),
        if (category.isNotEmpty)
          Positioned(
            top: responsive.h(8),
            right: responsive.w(8),
            child: CategoryTag(
              label: category,
              fontSize: responsive.sp(11),
            ),
          ),
        Positioned(
          left: responsive.w(8),
          bottom: responsive.h(8),
          child: _PricePill(price: price),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final responsive = context.responsive;
    final isTablet = responsive.isTablet;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.w(12),
        vertical: responsive.h(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMediumBold.copyWith(
              fontSize: responsive.sp(isTablet ? 14 : 15),
              color: ColorSet.textColor,
            ),
          ),
          _InfoRow(
            assetPath: Assets.icons.clock.path,
            label: '$time \u00b7 $startTime',
          ),
          _InfoRow(
            assetPath: Assets.icons.location.path,
            label: (location?.trim().isNotEmpty ?? false) ? location! : '--',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.assetPath,
    required this.label,
  });

  final String assetPath;
  final String label;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final isTablet = responsive.isTablet;

    return Row(
      children: [
        KumeleAssetWidget.square(
          assetPath: assetPath,
          size: isTablet ? 13 : 14,
          color: ColorSet.subTextColor,
        ),
        Gap(responsive.w(4)),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall.copyWith(
              fontSize: responsive.sp(isTablet ? 11 : 12),
              color: ColorSet.subTextColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _PricePill extends StatelessWidget {
  const _PricePill({required this.price});

  final String price;

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.w(10),
        vertical: responsive.h(4),
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(responsive.w(20)),
      ),
      child: Text(
        price,
        style: context.textTheme.labelSmallBold.copyWith(
          fontSize: responsive.sp(11),
          color: Colors.white,
        ),
      ),
    );
  }
}
