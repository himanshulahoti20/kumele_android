import 'package:kuemele/features/profile/presentation/profileset/domain/entities/hobby_interest.dart';

enum InterestedHobbiesStatus {
  initial,
  loading,
  loaded,
  saving,
  success,
  failure,
}

class InterestedHobbiesState {
  final List<HobbyInterest> interests;
  final List<String> selectedIds;
  final List<String> categoryNames;
  final InterestedHobbiesStatus status;
  final String? errorMessage;
  final String? successMessage;

  const InterestedHobbiesState({
    this.interests = const [],
    this.selectedIds = const [],
    this.categoryNames = const [],
    this.status = InterestedHobbiesStatus.initial,
    this.errorMessage,
    this.successMessage,
  });

  int get selectedCount => selectedIds.length;

  bool isSelected(String hobbyId) => selectedIds.contains(hobbyId);

  bool get isFetching =>
      status == InterestedHobbiesStatus.initial ||
      status == InterestedHobbiesStatus.loading;

  InterestedHobbiesState copyWith({
    List<HobbyInterest>? interests,
    List<String>? selectedIds,
    List<String>? categoryNames,
    InterestedHobbiesStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return InterestedHobbiesState(
      interests: interests ?? this.interests,
      selectedIds: selectedIds ?? this.selectedIds,
      categoryNames: categoryNames ?? this.categoryNames,
      status: status ?? this.status,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}
