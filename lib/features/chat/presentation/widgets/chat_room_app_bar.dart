import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/chat/domain/entities/chat_room_entity.dart';
import 'package:kuemele/features/chat/presentation/cubit/chat_room_header_cubit.dart';
import 'package:kuemele/features/chat/presentation/widgets/chat_guest_avatar_stack.dart';
import 'package:kuemele/features/explore/domain/entities/explore_event_detail.dart';
import 'package:kuemele/gen/assets.gen.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/navigation/app_routes.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/theme/app_image.dart';
import 'package:kuemele/shared/widgets/kumele_asset_widget.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatRoomAppBar extends StatelessWidget {
  final ChatRoomEntity? chat;

  const ChatRoomAppBar({super.key, this.chat});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomHeaderCubit, ChatRoomHeaderState>(
      builder: (context, headerState) {
        final eventTitle = headerState.title?.trim().isNotEmpty == true
            ? headerState.title!
            : (chat?.eventName ?? AppLocalizations.of(context)!.eventChat);
        final guestCount = headerState.guests.isNotEmpty
            ? headerState.guests.length
            : (headerState.eventDetail?.attendeeCount ?? 0);
        final guestsHeading = guestCount == 1
            ? '1 ${AppLocalizations.of(context)!.guest}'
            : '$guestCount ${AppLocalizations.of(context)!.guests}';

        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 14, 25, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MobileHeader(
                  label: eventTitle,
                  actions: [_buildQr(context, headerState.eventDetail)],
                ),
                const Gap(8),
                Text(
                  guestsHeading,
                  style: context.textTheme.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorSet.textColor,
                  ),
                ),
                const Gap(8),
                ChatGuestAvatarStack(
                  guests: headerState.guests,
                  guestCount: guestCount,
                  avatarSize: 30.w,
                ),
                const Gap(10),
                _EventInfoRow(
                  iconPath: SVGAsset.icon_ticket,
                  label: AppLocalizations.of(context)!.priceLabel,
                  value: _priceText(context, headerState.eventDetail),
                ),
                const Gap(4),
                _EventInfoRow(
                  iconPath: SVGAsset.icon_location,
                  label: AppLocalizations.of(context)!.eventAddressLabel,
                  value: _addressText(headerState.eventDetail),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _priceText(BuildContext context, ExploreEventDetail? detail) {
    if (detail == null) return '—';
    final parsed = double.tryParse(detail.price) ?? 0;
    if (!detail.isPaid || parsed <= 0)
      return AppLocalizations.of(context)!.free;
    return '${AppLocalizations.of(context)!.cashOnEntry} ${detail.price} ${detail.currency}';
  }

  String _addressText(ExploreEventDetail? detail) {
    if (detail == null) return '—';
    final loc = detail.locationDetails;
    final parts = [
      loc.country,
      loc.address ?? loc.displayAddress,
      loc.city,
    ]
        .whereType<String>()
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return detail.displayLocation;
    return parts.join(', ');
  }

  Widget _buildQr(BuildContext context, ExploreEventDetail? eventDetail) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.scanQr, extra: eventDetail),
      child: KumeleAssetWidget(
        assetPath: Assets.qr.path,
        color: ColorSet.revbg3Color,
        width: 35,
        height: 35,
      ),
    );
  }
}

class _EventInfoRow extends StatelessWidget {
  const _EventInfoRow({
    required this.iconPath,
    required this.label,
    required this.value,
  });

  final String iconPath;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KumeleAssetWidget(
          assetPath: iconPath,
          color: ColorSet.revbg3Color,
          width: 20,
          height: 20,
        ),
        const Gap(10),
        Expanded(
          child: Text(
            '$label : $value',
            style: context.textTheme.bodyMedium.copyWith(
              color: ColorSet.subTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
