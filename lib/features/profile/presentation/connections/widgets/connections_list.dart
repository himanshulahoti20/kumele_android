import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connection.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ConnectionsList extends StatelessWidget {
  const ConnectionsList({
    super.key,
    required this.users,
    required this.isLoading,
  });

  final List<FollowConnection> users;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final displayUsers = isLoading ? _placeholderUsers() : users;

    if (!isLoading && users.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 48.h),
          child: Text(
            AppLocalizations.of(context)!.noResults,
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.profileSubTextColor,
            ),
          ),
        ),
      );
    }

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: displayUsers.length,
        separatorBuilder: (_, __) => SizedBox(height: 20.h),
        itemBuilder: (context, index) {
          final user = displayUsers[index];
          return _ConnectionTile(user: user);
        },
      ),
    );
  }

  List<FollowConnection> _placeholderUsers() {
    return List.generate(
      6,
      (index) => FollowConnection(
        id: 'placeholder-$index',
        displayName: 'User name',
        username: 'username',
      ),
    );
  }
}

class _ConnectionTile extends StatelessWidget {
  const _ConnectionTile({required this.user});

  final FollowConnection user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppAvatar(
          imageUrl: user.profilePicture,
          name: user.displayName,
          size: 60.r,
          showShadow: false,
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName,
                style: context.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
              if (user.subtitle != null) ...[
                SizedBox(height: 4.h),
                Text(
                  user.subtitle!,
                  style: context.textTheme.bodyMedium.copyWith(
                    color: ColorSet.profileSubTextColor.withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
