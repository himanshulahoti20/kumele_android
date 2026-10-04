import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/core/responsive/responsive.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/l10n/app_localizations.dart';
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
    final isPhone = context.responsive.isPhone;
    final card = Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isPhone ? ColorSet.tileFillColor : ColorSet.bgColor,
        borderRadius: BorderRadius.circular(isPhone ? 12.r : 20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppAvatar(
                      imageUrl: profilePicture,
                      name: fullName,
                      size: 64,
                      previewOnTap: true,
                    ),
                    Gap(10.w),
                    // iOS iPad puts the bio in this column, under the
                    // name/QR row; iPhone puts it full-width below.
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(child: _buildNameColumn(context)),
                              if (qrData != null && qrData!.isNotEmpty) ...[
                                Gap(10.w),
                                AppQrCode(
                                  data: qrData!,
                                  size: 42,
                                  onTap: () => _showQrBottomSheet(context),
                                ),
                              ],
                            ],
                          ),
                          if (!isPhone && aboutMe.isNotEmpty) ...[
                            Gap(16.h),
                            _ExpandableAboutMe(text: aboutMe),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (isPhone && aboutMe.isNotEmpty) ...[
                  Gap(8.h),
                  _ExpandableAboutMe(text: aboutMe),
                ],
                if (!isPhone) Gap(24.h),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.r),
            child: _buildStatsRow(context, isPhone),
          ),
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
          top: -9.r,
          right: -9.r,
          child: _EditPencilButton(
            onTap: onEditTap,
            iconSize: 28.r,
            padding: EdgeInsets.zero,
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
            fontSize: 19.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Gap(4.h),
        GestureDetector(
          onTap: onHobbiesTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w),
            decoration: BoxDecoration(
              color: ColorSet.darkBlueColor,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              AppLocalizations.of(context)!.editHobbies,
              style: context.textTheme.labelSmall
                  .copyWith(color: Colors.white, fontSize: 14.sp),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isPhone) {
    final line = isPhone ? 1.0 : 0.83;
    // iOS: phone "authTextColor" (white / black dark), iPad "statsLineColor".
    final lineColor = ColorSet.isDarkMode
        ? (isPhone ? Colors.black : Colors.white)
        : (isPhone ? Colors.white : const Color(0xFFEBEBEB));
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: lineColor, width: line),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.r)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < profileStats.length; i++) ...[
              if (i > 0)
                Container(
                  width: line,
                  color: lineColor,
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
      fontSize: 14.sp,
    );
  }

  TextStyle _toggleStyle(BuildContext context) {
    return context.textTheme.labelSmall.copyWith(
      color: ColorSet.specialBlueColor,
      fontSize: 13.sp,
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
          padding: EdgeInsets.all(10.r),
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
                  fontSize: 14.sp,
                  height: 1.2,
                ),
              ),
              Gap(2.h),
              Text(
                stat.value,
                style: context.textTheme.titleMediumBold.copyWith(
                  color: ColorSet.specialBlueColor,
                  fontSize: 15.sp,
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
