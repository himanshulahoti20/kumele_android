import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/app_qr_code.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    required this.fullName,
    required this.email,
    required this.aboutMe,
    required this.profilePicture,
    required this.qrData,
    required this.profileStats,
    required this.onEditTap,
    required this.onHobbiesTap,
    required this.onStatTap,
  });

  final String fullName;
  final String email;
  final String aboutMe;
  final String? profilePicture;
  final String? qrData;
  final List<ProfileStatItem> profileStats;
  final VoidCallback onEditTap;
  final VoidCallback onHobbiesTap;
  final void Function(ProfileStatItem stat) onStatTap;

  void _showQrBottomSheet(BuildContext context) {
    final data = qrData;
    if (data == null || data.isEmpty) return;

    AppQrCode.showBottomSheet(context: context, data: data);
  }

  @override
  Widget build(BuildContext context) {
    final card = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAvatar(
                      imageUrl: profilePicture,
                      name: fullName,
                      size: 76,
                      previewOnTap: true,
                    ),
                    Gap(11.w),
                    // iOS puts a `Spacer()` after the QR so it sits beside
                    // the name with empty space to its right, on both phone
                    // and tablet (ProfileHeaderView.swift has no idiom
                    // split). Flexible (loose) shrink-wraps this column to
                    // match — Expanded would instead push the QR to the
                    // card's right edge, straight under the edit pencil,
                    // which is what caused the two to overlap.
                    Flexible(child: _buildNameColumn(context)),
                    if (qrData != null && qrData!.isNotEmpty) ...[
                      Gap(12.w),
                      AppQrCode(
                        data: qrData!,
                        size: 70,
                        onTap: () => _showQrBottomSheet(context),
                      ),
                    ],
                  ],
                ),
                if (aboutMe.isNotEmpty) ...[
                  Gap(16.h),
                  _ExpandableAboutMe(text: aboutMe),
                ],
                Gap(20.h),
              ],
            ),
          ),
          _buildStatsRow(context),
        ],
      ),
    );

    // Matches iOS ProfileHeaderView (same file, no phone/tablet split) —
    // it keeps the pencil in the *enclosing* ZStack rather than inside the
    // card, so its 48pt button box straddles the card's corner because the
    // card itself is inset 19pt. The card here isn't inset (it has to stay
    // flush with the settings cards below), so instead the pencil overflows
    // above the card via a negative Positioned offset — Clip.none on this
    // outer Stack lets it show, since it's a sibling of the card, not a
    // child the card's own Clip.antiAlias would cut off. Same treatment on
    // phone and tablet, matching iOS using one shared view for both.
    return Stack(
      clipBehavior: Clip.none,
      children: [
        card,
        Positioned(
          top: -15.r,
          right: -5.r,
          child: _EditPencilButton(
            onTap: onEditTap,
            iconSize: 28.r,
            padding: EdgeInsets.all(2.r),
          ),
        ),
      ],
    );
  }

  Widget _buildNameColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullName,
          style: context.textTheme.bodyLargeBold.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(10.h),
        AppButton.primarySmall(
          label: AppLocalizations.of(context)!.editHobbies,
          onPressed: onHobbiesTap,
          backgroundColor: ColorSet.darkBlueColor,
          foregroundColor: ColorSet.textColor,
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Container(
      height: 84.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: ColorSet.txtFieldFillColor, width: 3.h),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < profileStats.length; i++) ...[
            if (i > 0)
              Container(
                width: 3.w,
                color: ColorSet.txtFieldFillColor,
              ),
            Expanded(
              child: _ProfileStatTile(
                stat: profileStats[i],
                onTap: () => onStatTap(profileStats[i]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EditPencilButton extends StatelessWidget {
  const _EditPencilButton({
    required this.onTap,
    this.iconSize,
    this.padding,
  });

  final VoidCallback onTap;

  /// Defaults are the phone's original 18/6; the tablet passes iOS
  /// ProfileHeaderView's 28pt icon, with the padding trimmed on top so the
  /// icon rides closer to the card's edge.
  final double? iconSize;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final size = iconSize ?? 18.w;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(6),
        child: KumeleAssetWidget(
          assetPath: ProfileConfig.editIcon,
          width: size,
          height: size,
          color: ColorSet.textColor,
        ),
      ),
    );
  }
}

class _ExpandableAboutMe extends StatefulWidget {
  const _ExpandableAboutMe({required this.text});

  final String text;

  static const int _maxCollapsedLength = 200;

  @override
  State<_ExpandableAboutMe> createState() => _ExpandableAboutMeState();
}

class _ExpandableAboutMeState extends State<_ExpandableAboutMe> {
  bool _isExpanded = false;

  TextStyle _textStyle(BuildContext context) {
    return context.textTheme.labelSmall.copyWith(
      color: ColorSet.textColor,
      fontSize: 17.sp,
    );
  }

  TextStyle _toggleStyle(BuildContext context) {
    return context.textTheme.labelSmall.copyWith(
      color: ColorSet.lightBlueColor,
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTruncatable =
        widget.text.length > _ExpandableAboutMe._maxCollapsedLength;
    final displayText = isTruncatable && !_isExpanded
        ? '${widget.text.substring(0, _ExpandableAboutMe._maxCollapsedLength).trimRight()}...'
        : widget.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(displayText, style: _textStyle(context)),
        if (isTruncatable) ...[
          Gap(6.h),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Text(
              _isExpanded
                  ? AppLocalizations.of(context)!.showLess
                  : AppLocalizations.of(context)!.showMore,
              style: _toggleStyle(context),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProfileStatTile extends StatelessWidget {
  const _ProfileStatTile({
    required this.stat,
    required this.onTap,
  });

  final ProfileStatItem stat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stat.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall.copyWith(
                  color: ColorSet.profileSubTextColor,
                  fontSize: 13.sp,
                  height: 1.2,
                ),
              ),
              Gap(6.h),
              Text(
                stat.value,
                style: context.textTheme.titleMediumBold.copyWith(
                  color: ColorSet.lightBlueColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
