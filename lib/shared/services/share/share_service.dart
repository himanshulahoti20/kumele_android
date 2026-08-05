import 'package:flutter/material.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static const String kumeleWebsiteUrl = 'https://kumele.com/';

  Future<void> shareText({
    required String text,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  Future<void> shareLink({
    required String url,
    String? message,
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    final text =
        message != null && message.isNotEmpty ? '$message\n\n$url' : url;

    await SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  Future<void> shareReferral({
    required String referralCode,
    required String referralLink,
    Rect? sharePositionOrigin,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        text: AppStrings.referralShareMessage(
          referralCode: referralCode,
          referralLink: referralLink,
        ),
        subject: AppStrings.referralShareSubject,
        sharePositionOrigin: sharePositionOrigin,
      ),
    );
  }

  Rect? shareOriginFor(BuildContext context) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;

    return box.localToGlobal(Offset.zero) & box.size;
  }
}
