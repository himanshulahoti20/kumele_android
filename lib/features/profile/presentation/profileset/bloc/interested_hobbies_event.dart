sealed class InterestedHobbiesEvent {
  const InterestedHobbiesEvent();
}

class InterestedHobbiesInit extends InterestedHobbiesEvent {
  const InterestedHobbiesInit();
}

class InterestedHobbiesInterestToggled extends InterestedHobbiesEvent {
  final String hobbyId;

  const InterestedHobbiesInterestToggled(this.hobbyId);
}

class InterestedHobbiesSave extends InterestedHobbiesEvent {
  const InterestedHobbiesSave();
}
