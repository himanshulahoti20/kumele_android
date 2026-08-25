import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/profile/presentation/connections/domain/entities/follow_connection.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/components/app_checkbox.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ConnectionsList extends StatelessWidget {
  const ConnectionsList({
    super.key,
    required this.users,
    required this.isLoading,
    this.isSelectionMode = false,
    this.selectedIds = const {},
    this.onLongPress,
    this.onToggle,
  });

  final List<FollowConnection> users;
  final bool isLoading;
  final bool isSelectionMode;
  final Set<String> selectedIds;
  final ValueChanged<String>? onLongPress;
  final ValueChanged<String>? onToggle;

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
        separatorBuilder: (_, __) => SizedBox(height: 24.h),
        itemBuilder: (context, index) {
          final user = displayUsers[index];
          return _ConnectionTile(
            user: user,
            isSelectionMode: !isLoading && isSelectionMode,
            isSelected: selectedIds.contains(user.id),
            onLongPress: isLoading ? null : () => onLongPress?.call(user.id),
            onToggle: isLoading ? null : () => onToggle?.call(user.id),
          );
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
  const _ConnectionTile({
    required this.user,
    required this.isSelectionMode,
    required this.isSelected,
    this.onLongPress,
    this.onToggle,
  });

  final FollowConnection user;
  final bool isSelectionMode;
  final bool isSelected;
  final VoidCallback? onLongPress;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: isSelectionMode ? onToggle : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          if (isSelectionMode) ...[
            AppCheckbox(
              value: isSelected,
              onChanged: (_) => onToggle?.call(),
              size: 22,
            ),
            SizedBox(width: 12.w),
          ],
          AppAvatar(
            imageUrl: user.profilePicture,
            name: user.displayName,
            size: 44.r,
            showShadow: false,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              user.displayName,
              style: context.textTheme.bodyLarge.copyWith(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
