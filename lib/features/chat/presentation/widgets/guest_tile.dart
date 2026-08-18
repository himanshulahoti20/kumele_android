import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';
import 'package:kuemele/features/chat/presentation/bloc/guest_scan/guest_scan_bloc.dart';
import 'package:kuemele/features/chat/presentation/widgets/guest_checkin_confirm_sheet.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/models/scanned_guest_qr_payload.dart';
import 'package:kuemele/shared/widgets/app_avatar.dart';

class GuestTile extends StatelessWidget {
  final EventGuestEntity guest;
  final String eventId;
  final int index;

  const GuestTile({
    super.key,
    required this.guest,
    required this.eventId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: guest.checkedIn ? null : () => _confirmCheckIn(context),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 26.w),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  AppAvatar(
                    imageUrl: guest.user.avatarUrl,
                    name: guest.user.name,
                    size: 40.w,
                    showShadow: false,
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Text(
                      guest.user.firstName ?? guest.user.name,
                      style: context.textTheme.bodyLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Gap(8.w),
            Text(
              guest.checkedIn
                  ? AppLocalizations.of(context)!.checkedInLabel
                  : AppLocalizations.of(context)!.notCheckedInLabel,
              style: context.textTheme.bodyMedium.copyWith(
                color: guest.checkedIn ? Colors.green : Colors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCheckIn(BuildContext context) async {
    final bloc = context.read<GuestScanBloc>();
    final payload = ScannedGuestQrPayload(
      type: 'kumele_user',
      userId: guest.user.id,
      displayName: guest.user.name,
      avatar: guest.user.avatarUrl,
    );

    final confirmed = await AppBottomSheet.show<bool>(
      context: context,
      title: AppLocalizations.of(context)!.confirmCheckIn,
      child: GuestCheckInConfirmSheet(payload: payload),
    );
    if (confirmed != true) return;

    bloc.add(
      CheckInGuest(
        eventId: eventId,
        guestUserId: guest.user.id,
        displayName: guest.user.name,
      ),
    );
  }
}
