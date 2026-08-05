import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

class RALimiter extends StatefulWidget {
  final int min;
  final int max;
  final int initialStart;
  final int initialEnd;
  final Color? bgColor;
  final Color? valueColor;
  final Color? valueHoleColor;
  final double? circleSize;
  final double? bgRadius;
  final double? bgWidth;
  final double? bgHeight;
  final void Function(int start, int end)? onChanged;

  const RALimiter({
    super.key,
    this.min = 0,
    this.max = 100,
    this.initialStart = 18,
    this.initialEnd = 35,
    this.bgColor,
    this.circleSize,
    this.onChanged,
    this.valueColor,
    this.bgRadius,
    this.bgHeight,
    this.bgWidth,
    this.valueHoleColor,
  });

  @override
  State<RALimiter> createState() => _RALimiterState();
}

class _RALimiterState extends State<RALimiter> {
  late int _startValue;
  late int _endValue;

  bool _isDraggingStart = false;
  bool _isDraggingEnd = false;

  @override
  void initState() {
    super.initState();
    _startValue = widget.initialStart.clamp(widget.min, widget.max);
    _endValue = widget.initialEnd.clamp(_startValue, widget.max);
  }

  @override
  void didUpdateWidget(covariant RALimiter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.min != widget.min ||
        oldWidget.max != widget.max ||
        oldWidget.initialStart != widget.initialStart ||
        oldWidget.initialEnd != widget.initialEnd) {
      _startValue = widget.initialStart.clamp(widget.min, widget.max);
      _endValue = widget.initialEnd.clamp(_startValue, widget.max);
    }
  }

  @override
  Widget build(BuildContext context) {
    final metrics = _TrackMetrics.from(context, widget);
    final valueStart = metrics.startPositionFor(_startValue);
    final valueEnd = metrics.endPositionFor(_endValue);

    return GestureDetector(
      onHorizontalDragStart: (details) {
        final startHandleLeft = valueStart;
        final endHandleLeft = valueEnd - metrics.handleInset;
        final handleWidth = metrics.handleWidth;

        if (details.localPosition.dx >= startHandleLeft &&
            details.localPosition.dx <= startHandleLeft + handleWidth) {
          _isDraggingStart = true;
        } else if (details.localPosition.dx >= endHandleLeft &&
            details.localPosition.dx <= endHandleLeft + handleWidth) {
          _isDraggingEnd = true;
        }
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          if (_isDraggingStart) {
            final nextPosition = (valueStart + details.primaryDelta!)
                .clamp(0.0, valueEnd - metrics.minHandleGap);
            _startValue = metrics.valueFromStartPosition(nextPosition);
          } else if (_isDraggingEnd) {
            final nextPosition = (valueEnd + details.primaryDelta!)
                .clamp(valueStart + metrics.minHandleGap, metrics.trackWidth);
            _endValue = metrics.valueFromEndPosition(nextPosition);
          }
          _notifyChanged();
        });
      },
      onHorizontalDragEnd: (_) {
        _isDraggingStart = false;
        _isDraggingEnd = false;
      },
      child: Container(
        height: metrics.tileHeight,
        width: metrics.totalWidth,
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: metrics.handleInset,
              bottom: metrics.barBottom,
              child: Container(
                height: metrics.bgHeight,
                width: metrics.trackWidth,
                decoration: BoxDecoration(
                  color: widget.bgColor ?? ColorSet.createAgeLimitBgFillColor,
                  borderRadius: BorderRadius.circular(
                    widget.bgRadius ?? size(3.36),
                  ),
                ),
              ),
            ),
            Positioned(
              left: valueStart + metrics.handleInset,
              bottom: metrics.barBottom,
              child: Container(
                height: metrics.bgHeight,
                width: valueEnd - valueStart,
                decoration: BoxDecoration(
                  color: widget.valueColor ?? ColorSet.revertBgColor,
                  borderRadius: BorderRadius.circular(
                    widget.bgRadius ?? size(3.36),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: valueStart,
              child:
                  _buildValueWidget(context, _startValue, metrics.circleSize),
            ),
            Positioned(
              bottom: 0,
              left: valueEnd - metrics.handleInset,
              child: _buildValueWidget(context, _endValue, metrics.circleSize),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueWidget(BuildContext context, int value, double circleSize) {
    return SizedBox(
      height: circleSize * 2.7,
      child: Column(
        children: [
          Container(
            height: circleSize * 1.5,
            width: circleSize * 1.5,
            decoration: BoxDecoration(
              color: widget.valueColor ?? ColorSet.revertBgColor,
              borderRadius: BorderRadius.circular(circleSize),
            ),
            child: Center(
              child: Text(
                '$value',
                style: context.textTheme.bodyMedium
                    .copyWith(fontSize: 12.7, color: ColorSet.bgColor),
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: circleSize,
            width: circleSize,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(circleSize),
            ),
            child: Center(
              child: Container(
                height: circleSize * 0.4,
                width: circleSize * 0.4,
                decoration: BoxDecoration(
                  color: ColorSet.revbg3Color,
                  borderRadius: BorderRadius.circular(circleSize * 0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _notifyChanged() {
    _startValue = _startValue.clamp(widget.min, _endValue);
    _endValue = _endValue.clamp(_startValue, widget.max);
    widget.onChanged?.call(_startValue, _endValue);
  }
}

class _TrackMetrics {
  _TrackMetrics({
    required this.circleSize,
    required this.trackWidth,
    required this.handleInset,
    required this.handleWidth,
    required this.minHandleGap,
    required this.bgHeight,
    required this.min,
    required this.max,
  });

  final double circleSize;
  final double trackWidth;
  final double handleInset;
  final double handleWidth;
  final double minHandleGap;
  final double bgHeight;
  final int min;
  final int max;

  double get tileHeight => circleSize * 2.7;
  double get totalWidth => trackWidth + (handleInset * 2);
  double get barBottom => (circleSize / 2) - (bgHeight / 2);
  double get startTravel => trackWidth - minHandleGap;

  factory _TrackMetrics.from(BuildContext context, RALimiter widget) {
    final circleSize = widget.circleSize ?? size(20);
    final handleInset = ((circleSize * 1.5) / 2) - (circleSize / 2);
    final handleWidth = circleSize * 1.5;
    final minHandleGap = handleInset + handleWidth;
    final screenWidth = FinalSize.width(context);
    final trackWidth = (widget.bgWidth ?? screenWidth) - (handleInset * 2);

    return _TrackMetrics(
      circleSize: circleSize,
      trackWidth: trackWidth,
      handleInset: handleInset,
      handleWidth: handleWidth,
      minHandleGap: minHandleGap,
      bgHeight: widget.bgHeight ?? size(6.7),
      min: widget.min,
      max: widget.max,
    );
  }

  double startPositionFor(int value) {
    if (max == min || startTravel <= 0) return 0;
    final fraction = (value - min) / (max - min);
    return fraction * startTravel;
  }

  double endPositionFor(int value) {
    if (max == min || trackWidth <= 0) return trackWidth;
    final fraction = (value - min) / (max - min);
    return fraction * trackWidth;
  }

  int valueFromStartPosition(double position) {
    if (startTravel <= 0) return min;
    final fraction = (position / startTravel).clamp(0.0, 1.0);
    return _valueFromFraction(fraction);
  }

  int valueFromEndPosition(double position) {
    if (trackWidth <= 0) return max;
    final fraction = (position / trackWidth).clamp(0.0, 1.0);
    return _valueFromFraction(fraction);
  }

  int _valueFromFraction(double fraction) {
    return (min + fraction * (max - min)).round().clamp(min, max);
  }
}
