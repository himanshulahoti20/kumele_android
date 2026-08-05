import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuemele/core/app_strings.dart';
import 'package:kuemele/features/explore/domain/entities/event_guest_entity.dart';
import 'package:kuemele/features/explore/domain/repositories/explore_repository.dart';

import 'package:kuemele/shared/services/api_service/api_exception.dart';

part 'guest_scan_event.dart';
part 'guest_scan_state.dart';

class GuestScanBloc extends Bloc<GuestScanEvent, GuestScanState> {
  final ExploreRepository _exploreRepository;

  GuestScanBloc({required ExploreRepository exploreRepository})
      : _exploreRepository = exploreRepository,
        super(const GuestScanState()) {
    on<LoadGuests>(_onLoadGuests);
    on<CheckInGuest>(_onCheckInGuest);
  }

  Future<void> _onLoadGuests(
      LoadGuests event, Emitter<GuestScanState> emit) async {
    emit(state.copyWith(status: GuestScanStatus.loading));
    try {
      final guests = await _exploreRepository.getEventGuests(event.eventId);
      emit(state.copyWith(
        status: GuestScanStatus.success,
        guests: guests,
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        status: GuestScanStatus.error,
        errorMessage: e.error ?? AppStrings.somethingWentWrong,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: GuestScanStatus.error,
        errorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }

  Future<void> _onCheckInGuest(
      CheckInGuest event, Emitter<GuestScanState> emit) async {
    emit(state.copyWith(
      checkInStatus: GuestCheckInStatus.loading,
      clearCheckInMessages: true,
    ));

    try {
      await _exploreRepository.hostCheckInGuest(
        eventId: event.eventId,
        guestUserId: event.guestUserId,
      );

      final guests = await _exploreRepository.getEventGuests(event.eventId);

      emit(state.copyWith(
        guests: guests,
        status: GuestScanStatus.success,
        checkInStatus: GuestCheckInStatus.idle,
        checkInSuccessMessage: AppStrings.checkedInSuccess(event.displayName),
      ));
    } on ApiException catch (e) {
      emit(state.copyWith(
        checkInStatus: GuestCheckInStatus.idle,
        checkInErrorMessage: e.error ?? AppStrings.somethingWentWrong,
      ));
    } catch (e) {
      emit(state.copyWith(
        checkInStatus: GuestCheckInStatus.idle,
        checkInErrorMessage: AppStrings.somethingWentWrong,
      ));
    }
  }
}
