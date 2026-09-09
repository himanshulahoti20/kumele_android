import 'package:flutter/material.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/models/ads.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/kumele_video_player.dart';
import 'package:url_launcher/url_launcher.dart';

/// Family C "ad tap-through" popup — shown when a notification-rail ad is
/// tapped, before the destination link opens.
class AdTapThroughDialog extends StatelessWidget {
  const AdTapThroughDialog({super.key, required this.ad});

  final AdItem ad;

  @override
  Widget build(BuildContext context) {
    final cardWidth =
        (MediaQuery.sizeOf(context).width - 32).clamp(0, 420).toDouble();
    final imageWidth = cardWidth - 40;
    final imageHeight = imageWidth * 170 / 345;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorSet.bg3Color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: ad.mediaUrl?.isNotEmpty == true
                      ? (ad.mediaType.toLowerCase() == 'video'
                          ? KumeleVideoPlayer(
                              videoPath: ad.mediaUrl!,
                              isNetwork: true,
                              fit: BoxFit.cover,
                              muted: true,
                              loop: true,
                            )
                          : KumeleAssetWidget(
                              assetPath: ad.mediaUrl!,
                              fit: BoxFit.cover,
                            ))
                      : ColoredBox(color: ColorSet.tileFillColor),
                ),
              ),
              Positioned(
                top: -6,
                right: -6,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: ColorSet.bg2Color,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 15,
                      color: ColorSet.subTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            ad.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.heading3.copyWith(
              color: ColorSet.textColor,
              fontSize: 18,
            ),
          ),
          if (ad.body?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(
              ad.body!,
              style: context.textTheme.bodyMedium.copyWith(
                color: ColorSet.textColor.withValues(alpha: 0.65),
                fontSize: 14,
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppButton.primary(
              label: ad.resolvedCtaLabel(_fallbackCtaLabel),
              onPressed: () => _open(context, ad.resolvedDestinationUrl),
            ),
          ),
          if (ad.secondaryLinkUrl != null) ...[
            const SizedBox(height: 8),
            Center(
              child: GestureDetector(
                onTap: () => _open(context, ad.secondaryLinkUrl),
                child: Text(
                  ad.secondaryLinkUrl!,
                  style: context.textTheme.bodyMediumSemiBold.copyWith(
                    color: ColorSet.specialBlueColor,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _fallbackCtaLabel(String destinationType) {
    return destinationType.toLowerCase() == 'install' ? 'Install now' : 'Learn more';
  }

  Future<void> _open(BuildContext context, String? url) async {
    final uri = url == null ? null : Uri.tryParse(url);
    if (uri == null) return;
    Navigator.of(context).pop();
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
