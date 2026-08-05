import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/app_colors.dart';

enum _RefreshState { idle, pulling, ready, refreshing }

class AppCleanRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppCleanRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  State<AppCleanRefresh> createState() => _AppCleanRefreshState();
}

class _AppCleanRefreshState extends State<AppCleanRefresh>
    with SingleTickerProviderStateMixin {
  _RefreshState _state = _RefreshState.idle;
  double _pullDistance = 0.0;
  final double _threshold = 80.0;
  final double _maxPull = 140.0;

  late AnimationController _resetController;
  bool _isAtTop = true;
  double _dragStartY = 0.0;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _animateReset(double target) {
    final animation = Tween<double>(begin: _pullDistance, end: target).animate(
      CurvedAnimation(parent: _resetController, curve: Curves.easeOutCubic),
    );

    animation.addListener(() {
      if (mounted) setState(() => _pullDistance = animation.value);
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed && target == 0.0 && mounted) {
        setState(() => _state = _RefreshState.idle);
      }
    });

    _resetController.forward(from: 0.0);
  }

  Future<void> _triggerRefresh() async {
    setState(() => _state = _RefreshState.refreshing);
    try {
      await widget.onRefresh();
    } catch (_) {}
    if (!mounted) return;
    _animateReset(0.0);
  }

  void _onPointerDown(PointerDownEvent event) {
    if (_state == _RefreshState.refreshing) return;
    _dragStartY = event.position.dy;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_state == _RefreshState.refreshing || !_isAtTop) return;

    final deltaY = event.position.dy - _dragStartY;
    if (deltaY <= 0) return;

    setState(() {
      _pullDistance = deltaY * 0.5;
      if (_pullDistance > _maxPull) _pullDistance = _maxPull;
      _state = _pullDistance >= _threshold
          ? _RefreshState.ready
          : _RefreshState.pulling;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (_state == _RefreshState.refreshing) return;

    if (_state == _RefreshState.ready) {
      _triggerRefresh();
    } else if (_state == _RefreshState.pulling) {
      _animateReset(0.0);
    }
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification ||
        notification is ScrollStartNotification) {
      _isAtTop = notification.metrics.pixels <=
          notification.metrics.minScrollExtent + 1.0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Listener(
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Transform.translate(
              offset: Offset(0, _pullDistance),
              child: widget.child,
            ),
            if (_pullDistance > 0)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _pullDistance,
                child: _buildIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    final progress = (_pullDistance / _threshold).clamp(0.0, 1.0);
    final isActive =
        _state == _RefreshState.ready || _state == _RefreshState.refreshing;

    return Opacity(
      opacity: progress,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: ColorSet.bg3Color,
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: ColorSet.bg7Color.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDot(0, isActive),
              const SizedBox(width: 6),
              _buildDot(1, isActive),
              const SizedBox(width: 6),
              _buildDot(2, isActive),
              if (isActive) ...[
                const SizedBox(width: 12),
                Text(
                  _state == _RefreshState.ready ? 'Release' : 'Refreshing',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorSet.textColor,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: isActive ? 8 : 6,
      height: isActive ? 8 : 6,
      decoration: BoxDecoration(
        color: isActive ? ColorSet.specialBlueColor : ColorSet.bg5Color,
        shape: BoxShape.circle,
      ),
    );
  }
}
