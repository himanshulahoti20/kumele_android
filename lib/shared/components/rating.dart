import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/icons.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/app_svg_image.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

import 'size.dart';

class RARating extends StatefulWidget {
  final double initialRating;
  final double minRating;
  final Axis direction;
  final bool allowHalfRating;
  final double itemSize;
  final int itemCount;
  final EdgeInsets itemPadding;
  final Function(int, bool, bool) itemBuilder;
  final void Function(double) onRatingUpdate;

  const RARating({
    super.key,
    required this.initialRating,
    required this.minRating,
    this.direction = Axis.horizontal,
    this.allowHalfRating = false,
    this.itemSize = 40.0,
    required this.itemCount,
    this.itemPadding = const EdgeInsets.all(4.0),
    required this.itemBuilder,
    required this.onRatingUpdate,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RARatingState createState() => _RARatingState();
}

class _RARatingState extends State<RARating> {
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return widget.direction == Axis.horizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: _buildRatingItems(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildRatingItems(),
          );
  }

  List<Widget> _buildRatingItems() {
    List<Widget> ratingItems = [];
    for (int i = 0; i < widget.itemCount; i++) {
      double filledThreshold = i + 0.5;

      bool isHalf = widget.allowHalfRating && filledThreshold == rating;
      bool isFilled = filledThreshold < rating;

      ratingItems.add(
        GestureDetector(
          onTap: () {
            double newRating = filledThreshold;
            setState(() {
              rating = newRating;
              widget.onRatingUpdate(rating);
            });
          },
          child: Container(
            padding: i == 0 ? EdgeInsets.zero : widget.itemPadding,
            child: widget.itemBuilder(i + 1, isHalf, isFilled),
          ),
        ),
      );
    }
    return ratingItems;
  }
}

enum RatingType {
  communication,
  respect,
  professional,
  atmosphere,
  value;

  String get icon => switch (this) {
        communication => SVGAsset.icon_communication,
        respect => SVGAsset.icon_respect,
        professional => SVGAsset.icon_professional,
        atmosphere => SVGAsset.icon_atmosphere,
        value => SVGAsset.icon_value,
      };

  String get label => switch (this) {
        communication => 'Communication',
        respect => 'Respect',
        professional => 'Professionalism',
        atmosphere => 'Atmosphere',
        value => 'Value for money',
      };
}

class RARatingSummary extends StatelessWidget {
  final Map<RatingType, double> ratingSummaryData;
  final bool showValue;
  final void Function(RatingType type, double star)? onChanged;

  const RARatingSummary({
    super.key,
    required this.ratingSummaryData,
    this.showValue = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    SizedBox h10 = SizedBox(height: size(10));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRatingRow(context, RatingType.communication),
        h10,
        _buildRatingRow(context, RatingType.respect),
        h10,
        _buildRatingRow(context, RatingType.professional),
        h10,
        _buildRatingRow(context, RatingType.atmosphere),
        h10,
        _buildRatingRow(context, RatingType.value),
      ],
    );
  }

  Widget _buildRatingRow(BuildContext context, RatingType type) {
    double value = 0;
    if (ratingSummaryData.containsKey(type)) {
      value = ratingSummaryData[type] ?? 0;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      spacing: 10,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: AppSvgImage(assetName: type.icon, color: ColorSet.textColor),
        ),
        Flexible(
          child: Text(
            type.label,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmallSemiBold,
          ),
        ),
        RatingBar(
          value: value,
          itemSize: 14,
          onChanged: (star) => onChanged?.call(type, star),
        ),
        if (showValue)
          Text(
            '($value)',
            style: context.textTheme.bodySmallSemiBold,
          ),
      ],
    );
  }
}

class RatingBar extends StatelessWidget {
  const RatingBar({
    super.key,
    required this.value,
    this.itemSize = 40,
    this.onChanged,
  });

  final double value;
  final double itemSize;
  final void Function(double star)? onChanged;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: value,
      itemCount: 5,
      itemSize: itemSize,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => onChanged?.call(index + 1),
        child: Image.asset(IconSet.starIcon, color: ColorSet.textColor),
      ),
    );
  }
}
