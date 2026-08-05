import 'package:flutter/material.dart';
import 'package:kuemele/core/theme/app_radius.dart';
import 'package:kuemele/features/profile/presentation/profile_config.dart';
import 'package:kuemele/features/profile/presentation/profileset/presentation/widgets/profile_setting_tile.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_divider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef ProfileSettingTapCallback = void Function(ProfileSettingItem item);

class ProfileSettingsSection extends StatelessWidget {
  const ProfileSettingsSection({
    super.key,
    required this.items,
    required this.onItemTap,
    this.trailingBuilder,
  });

  final List<ProfileSettingItem> items;
  final ProfileSettingTapCallback onItemTap;
  final Widget? Function(ProfileSettingItem item)? trailingBuilder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorSet.tileFillColor,
        borderRadius: BorderRadius.circular(AppRadius.md.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              AppDivider.horizontal(
                color: ColorSet.bg3Color,
              ),
            ProfileSettingTile(
              title: items[i].title,
              iconPath: items[i].iconPath,
              showTrailingArrow: items[i].showTrailingArrow,
              trailing: trailingBuilder?.call(items[i]),
              onTap: () => onItemTap(items[i]),
            ),
          ],
        ],
      ),
    );
  }
}
