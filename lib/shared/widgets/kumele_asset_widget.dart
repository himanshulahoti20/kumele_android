import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// A reusable widget for handling any type of asset (SVG, PNG, JPEG, etc.)
/// with proper error handling and customization options
class KumeleAssetWidget extends StatelessWidget {
  /// The asset path (can be local asset or network URL)
  final String assetPath;

  /// Width of the asset
  final double? width;

  /// Height of the asset
  final double? height;

  /// BoxFit for the asset
  final BoxFit fit;

  /// Color to apply to SVG assets (tinting)
  final Color? color;

  /// Placeholder widget to show while loading or on error
  final Widget? placeholder;

  /// Error widget to show when asset fails to load
  final Widget? errorWidget;

  /// Border radius for the asset
  final BorderRadius? borderRadius;

  /// Whether to use cached network images (for network assets)
  final bool useCache;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Custom blend mode for color application
  final BlendMode colorBlendMode;

  const KumeleAssetWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.useCache = true,
    this.semanticLabel,
    this.colorBlendMode = BlendMode.srcIn,
  });

  /// Factory constructor for square assets
  factory KumeleAssetWidget.square({
    required String assetPath,
    required double size,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Widget? placeholder,
    Widget? errorWidget,
    BorderRadius? borderRadius,
    bool useCache = true,
    String? semanticLabel,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) {
    return KumeleAssetWidget(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: fit,
      color: color,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: borderRadius,
      useCache: useCache,
      semanticLabel: semanticLabel,
      colorBlendMode: colorBlendMode,
    );
  }

  /// Factory constructor for circular assets
  factory KumeleAssetWidget.circular({
    required String assetPath,
    required double size,
    BoxFit fit = BoxFit.cover,
    Color? color,
    Widget? placeholder,
    Widget? errorWidget,
    bool useCache = true,
    String? semanticLabel,
    BlendMode colorBlendMode = BlendMode.srcIn,
  }) {
    return KumeleAssetWidget(
      assetPath: assetPath,
      width: size,
      height: size,
      fit: fit,
      color: color,
      placeholder: placeholder,
      errorWidget: errorWidget,
      borderRadius: BorderRadius.circular(size / 2),
      useCache: useCache,
      semanticLabel: semanticLabel,
      colorBlendMode: colorBlendMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = _buildAssetWidget(context);

    if (borderRadius != null) {
      child = ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }

  Widget _buildAssetWidget(BuildContext context) {
    if (assetPath.isEmpty) {
      return _buildErrorWidget(context);
    }

    // Check if it's a base64 asset
    if (_isBase64Asset(assetPath)) {
      return _buildBase64ImageWidget(context);
    }

    // Check if it's raw SVG string code
    if (_isRawSvgAsset(assetPath)) {
      return _buildRawSvgWidget(context);
    }

    // Check if it's an SVG asset
    if (_isSvgAsset(assetPath)) {
      return _buildSvgWidget(context);
    }

    // Check if it's a network asset
    if (_isNetworkAsset(assetPath)) {
      return _buildNetworkImageWidget(context);
    }

    // Check if it's a local file path
    if (_isFileAsset(assetPath)) {
      return _buildFileImageWidget(context);
    }

    // Check if it's an asset path
    if (_isLocalAsset(assetPath)) {
      return _buildLocalImageWidget(context);
    }

    // Fallback to text/emoji widget
    return _buildEmojiOrTextWidget(context);
  }

  Widget _buildSvgWidget(BuildContext context) {
    if (_isNetworkAsset(assetPath)) {
      return _buildNetworkSvgWithErrorHandling(context);
    }

    return SvgPicture.asset(
      assetPath,
      width: _scaledWidth(context, width),
      height: _scaledHeight(context, height),
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color!, colorBlendMode) : null,
      placeholderBuilder: (context) => _buildPlaceholder(context),
      errorBuilder: (context, error, stackTrace) =>
          _buildErrorWidget(context),
      semanticsLabel: semanticLabel,
    );
  }

  Widget _buildNetworkSvgWithErrorHandling(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.network(
        assetPath,
        fit: fit,
        colorFilter:
            color != null ? ColorFilter.mode(color!, colorBlendMode) : null,
        placeholderBuilder: (context) => _buildPlaceholder(context),
        // Without this, a transient network failure (timeout, connection
        // abort, 404, etc.) throws unhandled instead of falling back —
        // matching the errorBuilder every other branch here already has.
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context),
        semanticsLabel: semanticLabel,
      ),
    );
  }

  Widget _buildNetworkImageWidget(BuildContext context) {
    return Image.network(
      assetPath,
      width: _scaledWidth(context, width),
      height: _scaledHeight(context, height),
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder(context);
      },
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
    );
  }

  Widget _buildLocalImageWidget(BuildContext context) {
    return Image.asset(
      assetPath,
      width: _scaledWidth(context, width),
      height: _scaledHeight(context, height),
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    if (placeholder != null) return placeholder!;

    return Skeletonizer(
      enabled: true,
      child: Container(
        width: _scaledWidth(context, width),
        height: _scaledHeight(context, height),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius:
              borderRadius ?? BorderRadius.circular(_scaledRadius(context, 4)),
        ),
        child:
            (width != null && height != null && (width! > 24 || height! > 24))
                ? Icon(
                    Icons.image_outlined,
                    size: _scaledSp(
                      context,
                      (width! < height! ? width! * 0.4 : height! * 0.4)
                          .clamp(16, 48),
                    ),
                    color: Colors.grey.shade400,
                  )
                : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    if (errorWidget != null) return errorWidget!;

    return Container(
      width: _scaledWidth(context, width),
      height: _scaledHeight(context, height),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: borderRadius,
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Icon(
        Icons.broken_image_outlined,
        size: (width != null && height != null)
            ? _scaledSp(
                context, width! < height! ? width! * 0.4 : height! * 0.4)
            : _scaledSp(context, 24),
        color: Colors.red.shade400,
      ),
    );
  }

  double? _scaledWidth(BuildContext context, double? value) {
    if (value == null || !value.isFinite) return value;
    return context.responsiveOrNull?.w(value) ?? value.w;
  }

  double? _scaledHeight(BuildContext context, double? value) {
    if (value == null || !value.isFinite) return value;
    return context.responsiveOrNull?.h(value) ?? value.h;
  }

  double _scaledSp(BuildContext context, double value) {
    final scaled = context.responsiveOrNull?.sp(value) ?? value.sp;
    return scaled.isFinite ? scaled : value;
  }

  double _scaledRadius(BuildContext context, double value) {
    return context.responsiveOrNull?.w(value) ?? value.r;
  }

  Widget _buildFileImageWidget(BuildContext context) {
    final cleanPath = assetPath.replaceFirst('file://', '');
    return Image.file(
      File(cleanPath),
      width: _scaledWidth(context, width),
      height: _scaledHeight(context, height),
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) => _buildErrorWidget(context),
    );
  }

  bool _isFileAsset(String path) {
    if (path.isEmpty) return false;
    return !path.startsWith('assets/') &&
        (path.startsWith('/') ||
            path.startsWith('file://') ||
            File(path).existsSync());
  }

  bool _isSvgAsset(String path) {
    return path.toLowerCase().endsWith('.svg');
  }

  bool _isNetworkAsset(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  Widget _buildBase64ImageWidget(BuildContext context) {
    final base64String = assetPath.substring(assetPath.indexOf(',') + 1);
    try {
      final bytes = base64Decode(base64String);
      return Image.memory(
        bytes,
        width: _scaledWidth(context, width),
        height: _scaledHeight(context, height),
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) =>
            _buildErrorWidget(context),
      );
    } catch (_) {
      return _buildErrorWidget(context);
    }
  }

  bool _isBase64Asset(String path) {
    return path.startsWith('data:image/');
  }

  bool _isRawSvgAsset(String path) {
    final trimmed = path.trim();
    return trimmed.startsWith('<svg') || trimmed.contains('<svg');
  }

  Widget _buildRawSvgWidget(BuildContext context) {
    return SvgPicture.string(
      assetPath.trim(),
      width: _scaledWidth(context, width),
      height: _scaledHeight(context, height),
      fit: fit,
      colorFilter:
          color != null ? ColorFilter.mode(color!, colorBlendMode) : null,
      errorBuilder: (context, error, stackTrace) =>
          _buildErrorWidget(context),
      semanticsLabel: semanticLabel,
    );
  }

  bool _isLocalAsset(String path) {
    return path.startsWith('assets/') || path.startsWith('packages/');
  }

  Widget _buildEmojiOrTextWidget(BuildContext context) {
    final targetSize = height ?? width ?? 24.0;
    return FittedBox(
      fit: fit,
      child: Text(
        assetPath,
        style: TextStyle(
          fontSize: targetSize,
          height: 1.0,
        ),
      ),
    );
  }
}
