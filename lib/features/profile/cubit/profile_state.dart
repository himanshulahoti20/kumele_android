enum ProfileStatus {
  init,
  loading,
  loaded,
  error,
}

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.init,
    this.count = 0,
    this.error,
  });

  final ProfileStatus status;
  final int count;
  final String? error;

  static const init = ProfileState();

  static const loading = ProfileState(status: ProfileStatus.loading);

  static ProfileState loaded(int count) =>
      ProfileState(status: ProfileStatus.loaded, count: count);

  static ProfileState errorMessage(String error) =>
      ProfileState(status: ProfileStatus.error, error: error);
}
