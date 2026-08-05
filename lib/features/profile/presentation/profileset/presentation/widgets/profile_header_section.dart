import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:kuemele/shared/widgets/app_qr_code.dart';

class ProfileHeaderSection extends StatelessWidget {
  const ProfileHeaderSection({
    super.key,
    required this.fullName,
    required this.aboutMe,
    required this.profilePicture,
    required this.qrData,
    required this.profileStats,
    required this.onEditTap,
    required this.onHobbiesTap,
    required this.onStatTap,
  });

  final String fullName;
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
    return Container(
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
                      onEditTap: onEditTap,
                      editIconAsset: ProfileConfig.editIcon,
                    ),
                    Gap(11.w),
                    Expanded(
                      child: Column(
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
                            label: AppStrings.editHobbies,
                            onPressed: onHobbiesTap,
                            backgroundColor: ColorSet.darkBlueColor,
                          ),
                        ],
                      ),
                    ),
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
  }

  Widget _buildStatsRow(BuildContext context) {
    return Container(
      height: 75.h,
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
              _isExpanded ? AppStrings.showLess : AppStrings.showMore,
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
