import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:kuemele/core/service_locator.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/chat/presentation/bloc/guest_scan/guest_scan_bloc.dart';
import 'package:kuemele/features/chat/presentation/widgets/guest_checkin_confirm_sheet.dart';
import 'package:kuemele/features/chat/presentation/widgets/guest_tile.dart';
import 'package:kuemele/l10n/app_localizations.dart';
import 'package:kuemele/shared/base/base_page.dart';
import 'package:kuemele/shared/components/app_button.dart';
import 'package:kuemele/shared/components/app_colors.dart';
import 'package:kuemele/shared/modals/bottom_sheet/app_bottom_sheet.dart';
import 'package:kuemele/shared/modals/dialog/camera_scanner_page.dart';
import 'package:kuemele/shared/models/scanned_guest_qr_payload.dart';
import 'package:kuemele/shared/widgets/app_empty_state.dart';
import 'package:kuemele/shared/widgets/mobile_header.dart';
import 'package:skeletonizer/skeletonizer.dart';

class GuestScanPage extends StatefulWidget implements BasePage {
  final String eventId;
  final bool embedded;

  const GuestScanPage({
    super.key,
    required this.eventId,
    this.embedded = false,
  });

  @override
  State<GuestScanPage> createState() => _GuestScanPageState();

  @override
  String get screenName => 'GuestScanPage';
}

class _GuestScanPageState extends State<GuestScanPage> {
  @override
  void initState() {
    super.initState();
    if (widget.eventId.isNotEmpty) {
      context.read<GuestScanBloc>().add(LoadGuests(widget.eventId));
    }
  }

  Future<void> _onScanQrPressed() async {
    final scannedValue = await AppBottomSheet.show<String>(
      context: context,
      title: AppLocalizations.of(context)!.scanQr,
      child: const CameraScannerSheet(),
    );
    if (scannedValue == null || !mounted) return;

    final payload = ScannedGuestQrPayload.tryParse(scannedValue);
    if (payload == null) {
      InjectionHelper.snackBar
          .showError(AppLocalizations.of(context)!.invalidQrCode);
      return;
    }

    final confirmed = await AppBottomSheet.show<bool>(
      context: context,
      title: AppLocalizations.of(context)!.confirmCheckIn,
      child: GuestCheckInConfirmSheet(payload: payload),
    );
    if (confirmed != true || !mounted) return;

    context.read<GuestScanBloc>().add(
          CheckInGuest(
            eventId: widget.eventId,
            guestUserId: payload.userId,
            displayName: payload.name,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GuestScanBloc, GuestScanState>(
      listenWhen: (previous, current) =>
          previous.checkInSuccessMessage != current.checkInSuccessMessage ||
          previous.checkInErrorMessage != current.checkInErrorMessage,
      listener: (context, state) {
        if (state.checkInSuccessMessage != null) {
          InjectionHelper.snackBar.showSuccess(state.checkInSuccessMessage!);
        }
        if (state.checkInErrorMessage != null) {
          InjectionHelper.snackBar.showError(state.checkInErrorMessage!);
        }
      },
      child: widget.embedded
          ? _buildContent()
          : Scaffold(
              backgroundColor: ColorSet.bg3Color,
              body: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(26.w, 16.h, 26.w, 0),
                      child: MobileHeader(
                        label: AppLocalizations.of(context)!.guestScan,
                      ),
                    ),
                    Gap(22.h),
                    Expanded(child: _buildContent()),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildContent() {
    if (widget.eventId.isEmpty) {
      return AppEmptyState(
        title: AppLocalizations.of(context)!.guestScan,
        description: AppLocalizations.of(context)!.somethingWentWrong,
      );
    }

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<GuestScanBloc, GuestScanState>(
            builder: (context, state) {
              if (state.status == GuestScanStatus.error) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: AppEmptyState(
                    title: AppLocalizations.of(context)!.error,
                    description: state.errorMessage ??
                        AppLocalizations.of(context)!.somethingWentWrong,
                  ),
                );
              }

              if (state.status == GuestScanStatus.success &&
                  state.guests.isEmpty) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 26.w),
                  child: AppEmptyState(
                    title: AppLocalizations.of(context)!.noGuests,
                    description:
                        AppLocalizations.of(context)!.noGuestsDescription,
                  ),
                );
              }

              final isLoading = state.status == GuestScanStatus.loading;
              final displayGuests = isLoading
                  ? List.generate(6, EventGuestEntity.placeholder)
                  : state.guests;

              return Skeletonizer(
                enabled: isLoading,
                child: ListView.separated(
                  itemCount: displayGuests.length,
                  separatorBuilder: (context, index) => Gap(16.h),
                  itemBuilder: (context, index) {
                    return GuestTile(
                      guest: displayGuests[index],
                      index: index,
                    );
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(26.w, 16.h, 26.w, 16.h),
          child: BlocBuilder<GuestScanBloc, GuestScanState>(
            buildWhen: (previous, current) =>
                previous.checkInStatus != current.checkInStatus,
            builder: (context, state) {
              return AppButton.primary(
                label: AppLocalizations.of(context)!.scanQrCode,
                isLoading: state.checkInStatus == GuestCheckInStatus.loading,
                onPressed: state.checkInStatus == GuestCheckInStatus.loading
                    ? null
                    : _onScanQrPressed,
              );
            },
          ),
        ),
      ],
    );
  }
}
