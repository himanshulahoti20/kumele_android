sealed class ProfilePageEvent {
  const ProfilePageEvent();
}

class ProfilePageInit extends ProfilePageEvent {
  const ProfilePageInit();
}

class ProfilePageRefresh extends ProfilePageEvent {
  const ProfilePageRefresh();
}

class ProfilePageThemeToggled extends ProfilePageEvent {
  const ProfilePageThemeToggled();
}

class ProfilePagePasskeyRegisterRequested extends ProfilePageEvent {
  const ProfilePagePasskeyRegisterRequested();
}

class ProfilePageFeedbackCleared extends ProfilePageEvent {
  const ProfilePageFeedbackCleared();
}
