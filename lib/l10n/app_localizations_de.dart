// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Speichern';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get submit => 'Senden';

  @override
  String get close => 'Schließen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get done => 'Fertig';

  @override
  String get retry => 'Wiederholen';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get selfCheck => 'Selbstprüfung';

  @override
  String get success => 'Erfolg';

  @override
  String get error => 'Fehler';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get somethingWentWrong =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get comment => 'Kommentar';

  @override
  String get addYourComment => 'Füge deinen Kommentar hinzu...';

  @override
  String get publishComment => 'Kommentar veröffentlichen';

  @override
  String get posted => 'Gepostet!';

  @override
  String get requiredField => 'Dieses Feld ist erforderlich';

  @override
  String get invalidEmail => 'Bitte gib eine gültige E-Mail-Adresse ein';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get noData => 'Keine Daten verfügbar';

  @override
  String get noChats => 'Keine Chats';

  @override
  String get noChatsDescription =>
      'Du hast momentan keine Chats. Starte eine Unterhaltung oder schau später wieder vorbei.';

  @override
  String get noGuests => 'Keine Gäste';

  @override
  String get noGuestsDescription =>
      'Für dieses Event sind noch keine Gäste eingecheckt oder registriert.';

  @override
  String get chat => 'Chat';

  @override
  String get spirituality => 'Spiritualität';

  @override
  String get hostedBy => 'Veranstaltet von';

  @override
  String get rateEvent => 'Event bewerten';

  @override
  String get reportEvent => 'Event melden';

  @override
  String get guestScan => 'Gast-Scan';

  @override
  String get scanQrCode => 'QR-Code scannen';

  @override
  String get alignQrInFrame => 'Richte den QR-Code des Gastes im Rahmen aus';

  @override
  String get guestNotFound => 'Gast in diesem Event nicht gefunden';

  @override
  String get invalidQrCode => 'Ungültiger QR-Code';

  @override
  String get confirmCheckIn => 'Check-in bestätigen';

  @override
  String get confirmGuestCheckInDescription =>
      'Diesen Gast für das Event einchecken?';

  @override
  String checkedInSuccess(String name) {
    return '$name erfolgreich eingecheckt!';
  }

  @override
  String get checkedInLabel => 'Eingecheckt';

  @override
  String get notCheckedInLabel => 'Nicht eingecheckt';

  @override
  String get confirmedLabel => 'Bestätigt';

  @override
  String get followHost => 'Gastgeber folgen';

  @override
  String get followHostConfirmMessage => 'Möchtest du dem Gastgeber folgen?';

  @override
  String get followHostConfirmButton => 'Gastgeber folgen';

  @override
  String get followHostSuccessMessage => 'Du folgst diesem Gastgeber jetzt.';

  @override
  String get no => 'Nein';

  @override
  String get unfollowConfirmTitle => 'Möchtest du wirklich nicht mehr folgen?';

  @override
  String get unfollowConfirmButton => 'Entfolgen';

  @override
  String get selectAllLabel => 'Alle auswählen';

  @override
  String get removeLabel => 'Entfernen';

  @override
  String daysLeftToRate(int days) {
    return 'Noch -- Tage zum Bewerten &\nÜberprüfen';
  }

  @override
  String scannedList(int count) {
    return 'Gescannte Liste: --';
  }

  @override
  String get chatToday => 'Today';

  @override
  String get chatYesterday => 'Yesterday';

  @override
  String get eventCanceled => 'Event abgesagt';

  @override
  String get noMessages => 'Keine Nachrichten';

  @override
  String get noMessagesDescription => 'Hier gibt es noch keine Nachrichten.';

  @override
  String get joinChatFailed => 'Beitreten des Chatraums fehlgeschlagen';

  @override
  String get joinChatSuccess => 'Erfolgreich dem Chatraum beigetreten';

  @override
  String get loadMessagesFailed => 'Laden der Chat-Nachrichten fehlgeschlagen';

  @override
  String get sendMessageFailed => 'Senden der Nachricht fehlgeschlagen';

  @override
  String get chatNotAvailable => 'Chat ist nicht verfügbar';

  @override
  String get chatAccessDenied => 'Du hast keinen Zugriff auf diesen Chat';

  @override
  String get chatClosed => 'Dieser Chat ist geschlossen';

  @override
  String get typeAMessage => 'Schreibe eine Nachricht';

  @override
  String get reply => 'Antworten';

  @override
  String get unknownUser => 'Unbekannt';

  @override
  String get activeEvent => 'Aktives Event';

  @override
  String get active => 'Aktiv';

  @override
  String get eventChat => 'Event-Chat';

  @override
  String get guests => 'Gäste';

  @override
  String get guest => 'Gast';

  @override
  String get priceLabel => 'Preis';

  @override
  String get eventAddressLabel => 'Event-Adresse';

  @override
  String get cashOnEntry => 'Barzahlung am Eingang';

  @override
  String get free => 'Kostenlos';

  @override
  String get profileTitle => 'Profil';

  @override
  String get myEvents => 'Meine Events';

  @override
  String get createdEvents => 'Erstellte Events';

  @override
  String get joinedEvents => 'Teilgenommene Events';

  @override
  String get noEventsCreatedYet => 'Du hast noch keine Events erstellt.';

  @override
  String get noEventsJoinedYet => 'Du hast noch an keinen Events teilgenommen.';

  @override
  String get blogsTitle => 'Blogs';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get interestedHobbies => 'Interessante Hobbys';

  @override
  String get editHobbies => 'Hobbys bearbeiten';

  @override
  String get showMore => 'Mehr anzeigen';

  @override
  String get showLess => 'Weniger anzeigen';

  @override
  String get myQrCode => 'Mein QR-Code';

  @override
  String get following => 'Folge ich';

  @override
  String get followers => 'Follower';

  @override
  String get goldStatus => 'Gold-Status';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get languages => 'Sprachen';

  @override
  String get languagesLoadFailed => 'Fehler beim Laden der Sprachen.';

  @override
  String get connectionsLoadFailed =>
      'Fehler beim Laden der Follower und gefolgten Personen.';

  @override
  String get unfollowFailedMessage =>
      'Nicht alle Auswahlen konnten entfernt werden. Bitte versuche es erneut.';

  @override
  String get cardPaymentsSubscriptions => 'Kartenzahlungen, Abos & Treuhand';

  @override
  String get security => 'Sicherheit';

  @override
  String get contact => 'Kontakt';

  @override
  String get faq => 'FAQ';

  @override
  String get contactPageSubtitle => 'Sag uns, wie wir helfen können.';

  @override
  String get contactSubjectLabel => 'Betreff';

  @override
  String get contactSubjectHint => 'Kurze Zusammenfassung deines Problems';

  @override
  String get contactDescriptionLabel => 'Beschreibung';

  @override
  String get contactDescriptionHint => 'Beschreibe dein Problem im Detail';

  @override
  String get contactCategoryLabel => 'Kategorie';

  @override
  String get contactPriorityLabel => 'Priorität';

  @override
  String get contactAttachmentLabel => 'Anhang (optional)';

  @override
  String get contactAttachmentHint => 'Lade einen Screenshot hoch';

  @override
  String get contactSubmitLabel => 'Senden';

  @override
  String get contactSuccessMessage => 'Deine Nachricht wurde gesendet.';

  @override
  String get contactSubmitFailed =>
      'Fehler beim Senden der Nachricht. Bitte versuche es erneut.';

  @override
  String get contactDescriptionTooShort =>
      'Bitte gib mindestens 20 Zeichen ein, damit der Support angemessen helfen kann.';

  @override
  String get contactSubjectRequired => 'Bitte gib einen Betreff ein.';

  @override
  String get contactDescriptionRequired => 'Bitte gib eine Beschreibung ein.';

  @override
  String get contactAttachmentPickFailed => 'Fehler bei der Bildauswahl.';

  @override
  String get guidelines => 'Richtlinien';

  @override
  String get referAFriend => 'Einen Freund empfehlen';

  @override
  String get referralCodeUnavailable =>
      'Dein Empfehlungscode ist momentan nicht verfügbar. Bitte versuche es später noch einmal.';

  @override
  String get referralShareSubject => 'Mach mit bei Kumele';

  @override
  String referralShareMessage(String referralCode, String referralLink) {
    return 'Mach mit bei Kumele — triff lokale Hobbyfreunde mit gleichen Interessen!\n\nNutze meinen Empfehlungscode: $referralCode\n\nHier registrieren: $referralLink';
  }

  @override
  String get termsAndConditions => 'Allgemeine Geschäftsbedingungen';

  @override
  String get nightMode => 'Nachtmodus';

  @override
  String get adPrivacyChoices => 'Anzeigen-Datenschutzeinstellungen';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get deleteAccountConfirmTitle =>
      'Bist du sicher? Diese Aktion kann\nnicht rückgängig gemacht werden. Bitte\nPasswort erneut eingeben.';

  @override
  String get deleteAccountPasswordHint => 'Aktuelles Passwort eingeben';

  @override
  String get deleteAccountPageSubtitle =>
      'Diese Aktion ist dauerhaft. Gib dein Passwort ein und sag uns, warum du gehst.';

  @override
  String get deleteAccountPasswordLabel => 'Passwort';

  @override
  String get deleteAccountReasonLabel => 'Grund';

  @override
  String get deleteAccountReasonHint => 'Sag uns, warum du gehst';

  @override
  String get deleteAccountConfirmationLabel =>
      'Ich verstehe, dass diese Aktion dauerhaft ist und nicht rückgängig gemacht werden kann';

  @override
  String get deleteAccountSubmitLabel => 'Konto löschen';

  @override
  String get deleteAccountSuccessMessage => 'Konto erfolgreich gelöscht.';

  @override
  String get deleteAccountSubmitFailed =>
      'Fehler beim Löschen des Kontos. Bitte versuche es erneut.';

  @override
  String get deleteAccountPasswordRequired => 'Bitte gib dein Passwort ein.';

  @override
  String get deleteAccountReasonRequired =>
      'Bitte teile uns mit, warum du gehst.';

  @override
  String get deleteAccountConfirmationRequired =>
      'Bitte bestätige, dass du verstanden hast, dass diese Aktion dauerhaft ist.';

  @override
  String get signOutConfirmTitle =>
      'Bist du sicher, dass du dich\nabmelden möchtest?';

  @override
  String get signOutSuccessMessage => 'Erfolgreich abgemeldet.';

  @override
  String get forgotPasswordPageTitle => 'Passwort vergessen';

  @override
  String get forgotPasswordSubtitle =>
      'Gib deine E-Mail-Adresse ein und wir senden dir einen Reset-Token.';

  @override
  String get forgotPasswordEmailLabel => 'E-Mail';

  @override
  String get forgotPasswordHint => 'E-Mail eingeben';

  @override
  String get forgotPasswordSubmitLabel => 'Reset-E-Mail senden';

  @override
  String get forgotPasswordSuccessMessage =>
      'Wenn diese E-Mail existiert, wurde ein Reset-Link gesendet.';

  @override
  String get resetPasswordPageTitle => 'Passwort zurücksetzen';

  @override
  String get resetPasswordSubtitle =>
      'Gib den an deine E-Mail gesendeten Code ein und wähle ein neues Passwort.';

  @override
  String get resetPasswordTokenLabel => 'Bestätigungscode';

  @override
  String get resetPasswordTokenHint => 'Code eingeben';

  @override
  String get resetPasswordNewPasswordLabel => 'Neues Passwort';

  @override
  String get resetPasswordNewPasswordHint => 'Neues Passwort eingeben';

  @override
  String get resetPasswordConfirmPasswordLabel => 'Passwort bestätigen';

  @override
  String get resetPasswordConfirmPasswordHint =>
      'Neues Passwort erneut eingeben';

  @override
  String get resetPasswordSubmitLabel => 'Passwort zurücksetzen';

  @override
  String get resetPasswordSuccessMessage =>
      'Passwort erfolgreich zurückgesetzt';

  @override
  String get passwordMinLengthError =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get passwordsDoNotMatchError => 'Passwörter stimmen nicht überein';

  @override
  String get emailVerificationPageTitle => 'Überprüfe deine E-Mail';

  @override
  String get emailVerificationSubtitle =>
      'Wir haben einen 6-stelligen Bestätigungscode an deine E-Mail gesendet. Gib ihn unten ein, um fortzufahren.';

  @override
  String get emailVerificationVerifyLabel => 'E-Mail verifizieren';

  @override
  String get emailVerificationResendLabel => 'Code erneut senden';

  @override
  String get emailVerificationResendInLabel => 'Code erneut senden in';

  @override
  String get emailVerificationSentMessage =>
      'Bestätigungscode an deine E-Mail gesendet.';

  @override
  String get emailVerificationFailedMessage =>
      'Ungültiger Bestätigungscode. Bitte versuche es erneut.';

  @override
  String get emailVerificationSendFailedMessage =>
      'Fehler beim Senden des Bestätigungscodes. Bitte versuche es erneut.';

  @override
  String get emailVerificationSuccessMessage =>
      'E-Mail erfolgreich verifiziert!';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get changePasswordCurrentLabel => 'Aktuelles Passwort';

  @override
  String get changePasswordCurrentHint => 'Aktuelles Passwort eingeben';

  @override
  String get changePasswordNewLabel => 'Neues Passwort';

  @override
  String get changePasswordNewHint => 'Neues Passwort eingeben';

  @override
  String get changePasswordConfirmLabel => 'Neues Passwort bestätigen';

  @override
  String get changePasswordConfirmHint => 'Neues Passwort erneut eingeben';

  @override
  String get changePasswordSubmitLabel => 'Passwort aktualisieren';

  @override
  String get changePasswordSuccessMessage =>
      'Passwort erfolgreich aktualisiert. Bitte melde dich mit deinem neuen Passwort an.';

  @override
  String get changePasswordSubmitFailed =>
      'Fehler beim Aktualisieren des Passworts. Bitte versuche es erneut.';

  @override
  String get changePasswordCurrentRequired =>
      'Bitte gib dein aktuelles Passwort ein.';

  @override
  String get registerPasskey => 'Passkey registrieren';

  @override
  String get twoFactorAuth => 'Zwei-Faktor-Authentifizierung';

  @override
  String get twoFactorSetupTitle => 'Einrichtung der Authentifizierungs-App';

  @override
  String get twoFactorSetupStep1 =>
      '1. Öffne eine Authentifizierungs-App auf deinem Mobilgerät';

  @override
  String get twoFactorSetupStep1Hint =>
      'Wenn du keine hast, lade eine der empfohlenen Apps herunter und installiere sie:';

  @override
  String get twoFactorSetupStep2Lead => '2. Scanne diesen Barcode mit deiner ';

  @override
  String get twoFactorSetupStep2Bold => 'Authentifizierungs-App';

  @override
  String get twoFactorSetupCantScan =>
      'Scannen nicht möglich? Verwende stattdessen diesen Code';

  @override
  String get twoFactorSetupStep3Lead =>
      '3. Gib den sechsstelligen Code aus der ';

  @override
  String get twoFactorSetupStep3Bold => 'Authentifizierungs-App';

  @override
  String get twoFactorVerificationHint => 'Bestätigungscode hier eingeben';

  @override
  String get twoFactorSetupLoadFailed =>
      'Fehler beim Laden des 2FA-Setups. Bitte versuche es erneut.';

  @override
  String get twoFactorEnableFailed =>
      'Fehler bei der Aktivierung der 2FA. Bitte überprüfe deinen Code und versuche es erneut.';

  @override
  String get twoFactorEnableSuccess =>
      'Zwei-Faktor-Authentifizierung erfolgreich aktiviert.';

  @override
  String get twoFactorManualCodeCopied =>
      'Einrichtungscode in die Zwischenablage kopiert';

  @override
  String get setup => 'Einrichten';

  @override
  String get twoFactorDisableTitle =>
      'Zwei-Faktor-Authentifizierung deaktivieren';

  @override
  String get twoFactorDisableSubtitle =>
      'Bist du sicher, dass du die Zwei-Faktor-Authentifizierung deaktivieren möchtest?';

  @override
  String get twoFactorDisableDescription =>
      'Dein Konto wird dann nur noch durch dein Passwort geschützt. Wir empfehlen, 2FA für bessere Sicherheit aktiviert zu lassen.';

  @override
  String get twoFactorDisableConfirm => 'Zwei-Faktor deaktivieren';

  @override
  String get twoFactorDisableCodeLead =>
      'Gib den sechsstelligen Code aus deiner ';

  @override
  String get twoFactorDisableSuccess =>
      'Zwei-Faktor-Authentifizierung erfolgreich deaktiviert.';

  @override
  String get twoFactorDisableFailed =>
      'Fehler beim Deaktivieren der 2FA. Bitte überprüfe deinen Code und versuche es erneut.';

  @override
  String get twoFactorLoginTitle => 'Zwei-Faktor-Authentifizierung';

  @override
  String get twoFactorLoginSubtitle =>
      'Gib den Code aus deiner Authentifizierungs-App ein, um fortzufahren';

  @override
  String get twoFactorLoginDescription =>
      'Dein Konto ist durch die Zwei-Faktor-Authentifizierung geschützt.';

  @override
  String get twoFactorLoginCodeLead =>
      'Gib den sechsstelligen Code aus deiner ';

  @override
  String get twoFactorLoginCodeBold => 'Authentifizierungs-App';

  @override
  String get twoFactorLoginVerify => 'Verifizieren';

  @override
  String get twoFactorLoginFailed =>
      'Ungültiger Bestätigungscode. Bitte versuche es erneut.';

  @override
  String get passkeyRegisterSuccess => 'Passkey erfolgreich registriert';

  @override
  String get onboardingPageTitle => 'Richte dein Profil ein';

  @override
  String get onboardingPageSubtitle =>
      'Füge ein Foto hinzu und erzähle der Community von dir.';

  @override
  String get onboardingAvatarHint => 'Tippen, um ein Foto hinzuzufügen';

  @override
  String get onboardingImagePickerTitle => 'Profilbild hinzufügen';

  @override
  String get onboardingImagePickerSubtitle =>
      'Wähle Galerie oder Kamera für dein Profilbild';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Kamera';

  @override
  String get onboardingUsernameLabel => 'Benutzername';

  @override
  String get onboardingUsernameHint => 'Wähle einen Benutzernamen (optional)';

  @override
  String get onboardingUsernameHelper =>
      'Benutzernamen können nur alle 3 Monate geändert werden';

  @override
  String get onboardingUsernameChecking => 'Benutzername wird überprüft...';

  @override
  String get onboardingUsernameAvailable => 'Benutzername ist verfügbar';

  @override
  String get onboardingUsernameTaken => 'Benutzername ist bereits vergeben';

  @override
  String get onboardingPhoneLabel => 'Telefonnummer';

  @override
  String get onboardingPhoneHint => 'Gib deine Telefonnummer ein (optional)';

  @override
  String get onboardingAboutLabel => 'Über mich';

  @override
  String get onboardingAboutHint =>
      'Erzähle uns von deinen Interessen, Hobbys und was du gerne tust';

  @override
  String get onboardingSuccessMessage => 'Profil erfolgreich gespeichert.';

  @override
  String get onboardingImageRequired => 'Bitte füge ein Profilfoto hinzu.';

  @override
  String get onboardingPhoneRequired => 'Bitte gib deine Telefonnummer ein.';

  @override
  String get onboardingPhoneInvalid =>
      'Bitte gib eine gültige Telefonnummer ein.';

  @override
  String get onboardingAboutTooShort =>
      'Über mich muss mindestens 200 Zeichen lang sein.';

  @override
  String get onboardingAboutTooLong =>
      'Über mich darf 500 Zeichen nicht überschreiten.';

  @override
  String get onboardingImagePlatformUnsupported =>
      'Bilder-Upload ist nur auf Android verfügbar.';

  @override
  String get onboardingImagePickFailed => 'Fehler bei der Bildauswahl.';

  @override
  String get onboardingSubmitFailed =>
      'Fehler beim Speichern des Profils. Bitte versuche es erneut.';

  @override
  String get editProfileTitle => 'Profil bearbeiten';

  @override
  String get editProfileFirstNameLabel => 'Vorname';

  @override
  String get editProfileFirstNameHint => 'Gib deinen Vornamen ein';

  @override
  String get editProfileLastNameLabel => 'Nachname';

  @override
  String get editProfileLastNameHint => 'Gib deinen Nachnamen ein';

  @override
  String get editProfileAboutLabel => 'Über mich';

  @override
  String get editProfileAboutHint =>
      'Erzähle uns von deinen Interessen, Hobbys und was du gerne tust';

  @override
  String get editProfilePhoneLabel => 'Telefonnummer';

  @override
  String get editProfilePhoneHint => 'Gib deine Telefonnummer ein';

  @override
  String get editProfileUpdateLabel => 'Aktualisieren';

  @override
  String get editProfileSuccessMessage => 'Profil erfolgreich aktualisiert.';

  @override
  String get editProfileSubmitFailed =>
      'Fehler beim Aktualisieren des Profils. Bitte versuche es erneut.';

  @override
  String get editProfileFirstNameRequired => 'Bitte gib deinen Vornamen ein.';

  @override
  String get editProfileAboutTooLong =>
      'Über mich darf 500 Zeichen nicht überschreiten.';

  @override
  String get editProfilePhoneInvalid =>
      'Bitte gib eine gültige Telefonnummer ein.';

  @override
  String get editProfileUserMissing =>
      'Profil konnte nicht aktualisiert werden. Benutzer nicht gefunden.';

  @override
  String get pickEventLocation => 'Event-Ort auswählen';

  @override
  String get selectedLocation => 'Ausgewählter Ort';

  @override
  String get fetchingAddress => 'Adresse wird abgerufen…';

  @override
  String get moveMapToPickLocation =>
      'Bewege die Karte, um einen Ort auszuwählen';

  @override
  String get confirmLocation => 'Ort bestätigen';

  @override
  String get searching => 'Suchen…';

  @override
  String get unknownLocation => 'Unbekannter Ort';

  @override
  String get couldNotFetchAddress => 'Adresse konnte nicht abgerufen werden';

  @override
  String get locationServicesDisabled => 'Ortungsdienste sind deaktiviert.';

  @override
  String get locationPermissionDenied => 'Standortberechtigung verweigert.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Standortberechtigung dauerhaft verweigert.';

  @override
  String get pickEventLocationPlaceholder => 'Event-Ort auswählen';

  @override
  String get tapToOpenMapPlaceholder =>
      'Tippen, um die Karte zu öffnen und eine Markierung zu setzen';

  @override
  String get limitedInvites => 'Begrenzte Einladungen';

  @override
  String get howItWorks => 'Wie es funktioniert:';

  @override
  String get login => 'Anmelden';

  @override
  String get signup => 'Registrieren';

  @override
  String get inviteFriendsAndFamily => 'Lade deine Freunde und Familie ein';

  @override
  String get eventCodeCopied => 'Event-Code in die Zwischenablage kopiert!';

  @override
  String get copyTo => 'Kopieren in';

  @override
  String get clipboard => 'Zwischenablage';

  @override
  String get eventIdLabel => 'Event-ID: ';

  @override
  String get locationLabel => 'Ort: ';

  @override
  String get scanQr => 'QR scannen';

  @override
  String get hostQr => 'Gastgeber-QR';

  @override
  String get demoHostName => 'Ankit Maheswari';

  @override
  String get demoLocation => 'Bahawalpur, Punjab Pakistan';

  @override
  String get signIn => 'Einloggen';

  @override
  String get signInEmailHint => 'E-Mail eingeben | Benutzername';

  @override
  String get signInPasswordHint => 'Passwort eingeben';

  @override
  String get signInRememberMeLabel => 'Angemeldet bleiben';

  @override
  String get signInForgotPasswordLabel => 'Passwort vergessen?';

  @override
  String get signInCaptchaLabel => 'Ich bin kein Roboter';

  @override
  String get signInNotAMemberPrefix => 'Noch kein Mitglied? ';

  @override
  String get signInNoAccountPrefix => 'Noch kein Konto? ';

  @override
  String get signInPasskeyDividerLabel => 'Oder mit Passkey anmelden';

  @override
  String get signInPasskeyDescription =>
      'Wir empfehlen allen Nutzern den Passkey, sofern dein Gerät ihn unterstützt – für mehr Sicherheit und eine angenehme Nutzererfahrung.';

  @override
  String get signInLanguageChoiceLabel => 'Sprache';

  @override
  String get signInFillFieldsError => 'Bitte fülle alle Pflichtfelder aus';

  @override
  String get signInCaptchaRequiredError =>
      'Bitte bestätige, dass du kein Roboter bist';

  @override
  String get signInSuccessMessage => 'Erfolgreich angemeldet';

  @override
  String get signInWithGoogleLabel => 'Mit Google anmelden';

  @override
  String get alreadyHaveAccount => 'Hast du bereits ein Konto? ';

  @override
  String get signupFirstNameLabel => 'Vorname';

  @override
  String get signupFirstNameHint => 'Vorname eingeben';

  @override
  String get signupLastNameLabel => 'Nachname';

  @override
  String get signupLastNameHint => 'Nachname eingeben';

  @override
  String get signupEmailHint => 'E-Mail eingeben';

  @override
  String get signupPasswordHint => 'Passwort eingeben';

  @override
  String get signupConfirmPasswordHint => 'Passwort bestätigen';

  @override
  String get signupReferralCodeLabel => 'Empfehlungscode';

  @override
  String get signupBetaCodeLabel => 'Beta-Code';

  @override
  String get signupCodeHint => ' z. B. DF4R435';

  @override
  String get passkeySignInTitle => 'Mit deinem Kumele-Passkey einloggen';

  @override
  String get earnMedals => 'Medaillen verdienen';

  @override
  String get bronzeStatus => 'Bronze-Status';

  @override
  String get silverStatus => 'Silber-Status';

  @override
  String get goldStatusMedal => 'Gold-Status';

  @override
  String get bronzeStatusDescription =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 2 Events erstellt oder an mindestens 2 Events lückenlos teilgenommen. Der Benutzer erhält 2% Rabatt auf einen In-App-Kauf nach Wahl.';

  @override
  String get silverStatusDescription =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 3 Events erstellt oder an mindestens 3 Events lückenlos teilgenommen. Der Benutzer erhält 4% Rabatt auf einen In-App-Kauf nach Wahl.';

  @override
  String get goldStatusMedalDescription =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 4 Events erstellt oder an mindestens 4 Events lückenlos teilgenommen. Der Benutzer erhält 8% Rabatt auf einen In-App-Kauf nach Wahl.';

  @override
  String get filterTitle => 'Filtern';

  @override
  String get currentLocation => 'Aktueller Standort';

  @override
  String get change => 'Ändern';

  @override
  String get distanceRangeLabel => 'Entfernungsbereich (in Kilometern)';

  @override
  String get ageRangeLabel => 'Altersgruppe';

  @override
  String get paidEvent => 'Kostenpflichtiges Event';

  @override
  String get stateHint => 'Bundesland/Kanton';

  @override
  String get postalZipCodeHint => 'Postleitzahl';

  @override
  String get countryHint => 'Land';

  @override
  String get openPhantomWallet => 'Phantom Wallet öffnen';

  @override
  String get nftDescriptionLabel => 'Beschreibung';

  @override
  String get nftDetailsLabel => 'NFT-Details';

  @override
  String get guestCountValidForEventOnly =>
      'Anzahl der Gäste gilt nur für dieses Event';

  @override
  String get tokenIdLabel => 'Token-ID';

  @override
  String get tokenStandardLabel => 'Token-Standard';

  @override
  String get blockchainLabel => 'Blockchain';

  @override
  String get creatorLabel => 'Ersteller';

  @override
  String get addCommentsHint => 'Kommentare hinzufügen';

  @override
  String get reportEventPageTitle => 'Event melden';

  @override
  String get ratingPageTitle => 'Bewertung';

  @override
  String get send => 'Senden';

  @override
  String get blogLikePostSemanticLabel => 'Beitrag liken';

  @override
  String get blogLikesLabel => 'Gefällt mir';

  @override
  String get blogShareLabel => 'Teilen';

  @override
  String get replyDialogTitlePrefix => 'Antwort an';

  @override
  String get replyDialogHint => 'Schreibe deine Antwort...';

  @override
  String get blogEmptyStateTitle => 'Keine Blogs gefunden';

  @override
  String get blogEmptyStateDescription =>
      'Versuche es mit einem anderen Kategoriefilter.';

  @override
  String get blogCategoryAll => 'Alle';

  @override
  String get blogCategoryFood => 'Essen';

  @override
  String get blogCategoryTravel => 'Reisen';

  @override
  String get blogCategorySports => 'Sport';

  @override
  String get blogCategoryMusic => 'Musik';

  @override
  String get blogPlaceholderTitle =>
      'Platzhalter-Titel für Ladeeffekt des Blogbeitrags';

  @override
  String get blogPlaceholderExcerpt =>
      'Platzhalter-Auszug für das Laden des Grundgerüsts.';

  @override
  String get blogPlaceholderAuthorName => 'Lade Autor';

  @override
  String get blogPlaceholderCategoryName => 'Kategorie';

  @override
  String get blogPostShareSampleTitle =>
      'Singleton of Glen Ord 38-jährig und das Singleton-Sortiment.';

  @override
  String get blogPostShareCategoryLabel => 'Spiritualität';

  @override
  String get blogPostShareAuthorLabel => ' Autor:';

  @override
  String get blogPostSharePublishDateLabel => ' Veröffentlichungsdatum:';

  @override
  String get blogPostShareHowItWorksTitle => 'Wie es funktioniert';

  @override
  String get blogPostShareStep1 => '1. URL überprüfen, um den Blog zu öffnen';

  @override
  String get blogPostShareStep2 =>
      '2. Oder angemeldet nach dem Blog suchen, um ihn zu liken';

  @override
  String get blogPostShareInviteTitle =>
      'Lade deine Freunde \n und Familie ein';

  @override
  String get blogPostCommentsTitle => 'Kommentare';

  @override
  String get blogPostPreviousLabel => 'Zurück';

  @override
  String get blogRepliesCountLabel => 'Antworten';

  @override
  String get blogReplyPlaceholderText =>
      'Mach dich bereit für einen Abend voller Lachen';

  @override
  String get blogSearchHint => 'Suchen';

  @override
  String get createEventNameLabel => 'Eventname';

  @override
  String get createEventTitleHint => 'Titel hinzufügen';

  @override
  String get createEventSubtitleLabel => 'Untertitel';

  @override
  String get createEventSubtitleHint => 'Untertitel hinzufügen';

  @override
  String get createEventDescriptionMaxLabel => 'Max';

  @override
  String get createEventDescriptionLabel => 'Beschreibung';

  @override
  String get createEventDescriptionHint => 'Mehr über das Event';

  @override
  String get createEventDateLabel => 'Datum';

  @override
  String get createEventStartTimeLabel => 'Event-Startzeit';

  @override
  String get createEventStartTimePlaceholder => 'Startzeit';

  @override
  String get createEventEndTimeLabel => 'Event-Endzeit';

  @override
  String get createEventEndTimePlaceholder => 'Endzeit';

  @override
  String get createEventCheckAvailabilityLabel => 'Verfügbarkeit prüfen';

  @override
  String get createEventAvailabilityDisclaimer =>
      'Um dies zu nutzen, füge bitte deine Adresse und die Anzahl der Gäste hinzu. Haftungsausschluss: Wir können 100% Übereinstimmungen nicht garantieren, da bestimmte Faktoren außerhalb unserer Kontrolle liegen.';

  @override
  String get createEventStartsInLabel => 'Event beginnt in';

  @override
  String get createEventDecreaseTimeSemanticLabel => 'Zeit verringern';

  @override
  String get createEventIncreaseTimeSemanticLabel => 'Zeit erhöhen';

  @override
  String get createEventStreetLabel => 'Straße';

  @override
  String get createEventStreetHint => 'Straße eingeben';

  @override
  String get createEventHomeNumberLabel => 'Hausnummer';

  @override
  String get createEventHomeNumberHint => 'Hausnummer eingeben';

  @override
  String get createEventDistrictLabel => 'Bezirk';

  @override
  String get createEventDistrictHint => 'Bezirk eingeben';

  @override
  String get createEventPostalCodeLabel => 'Postleitzahl';

  @override
  String get createEventPostalCodeHint => 'Postleitzahl eingeben';

  @override
  String get createEventStateLabel => 'Bundesland';

  @override
  String get createEventStateHint => 'Bundesland eingeben';

  @override
  String get createEventUploadImageTitle => 'Bild hochladen';

  @override
  String get createEventUploadImageSubtitle =>
      'Wähle eine Quelle für dein Eventbild';

  @override
  String get createEventCategoryPlaceholder => 'Kategorie';

  @override
  String get createEventCategoryLabel => 'Eventkategorie';

  @override
  String get createEventImageLabel => 'Eventbild';

  @override
  String get createEventImageSizeHint => '(Empfohlene Größe 400 x 400px)';

  @override
  String get createEventStripeConnectedLabel => 'Stripe verbunden';

  @override
  String get createEventPreviewSubmitLabel => 'Event erstellen';

  @override
  String get createEventPreviewGuestsSuffix => 'Gäste';

  @override
  String get createEventPreviewAlreadyStarted =>
      'Das Event hat bereits begonnen';

  @override
  String createEventPreviewStartsInDays(Object days) {
    return 'Beginnt in $days Tagen';
  }

  @override
  String get createEventPreviewStartsTomorrow => 'Beginnt morgen';

  @override
  String createEventPreviewStartsInHour(Object hours) {
    return 'Beginnt in $hours Stunde';
  }

  @override
  String createEventPreviewStartsInHours(Object hours) {
    return 'Beginnt in $hours Stunden';
  }

  @override
  String createEventPreviewStartsInMinute(Object minutes) {
    return 'Beginnt in $minutes Minute';
  }

  @override
  String createEventPreviewStartsInMinutes(Object minutes) {
    return 'Beginnt in $minutes Minuten';
  }

  @override
  String get createEventPreviewStartingNow => 'Beginnt jetzt';

  @override
  String get createEventPreviewDefaultCategory => 'Spiritualität';

  @override
  String get createEventPreviewDefaultHostName => 'Ich';

  @override
  String createEventPreviewExpectedLabel(Object label) {
    return 'Erwartet $label';
  }

  @override
  String createEventPreviewPricingLabel(Object label) {
    return 'Preis $label';
  }

  @override
  String get discoverNoMatchesMessage =>
      'Derzeit keine weiteren Übereinstimmungen, bis dahin';

  @override
  String get discoverGuestsSuffix => 'Gäste';

  @override
  String get discoverGoToChatLabel => 'Zum Chat';

  @override
  String get discoverLocationLabel => 'Standort:';

  @override
  String get discoverStartsInLabel => 'Beginnt in';

  @override
  String get discoverHoursSuffix => 'Std.';

  @override
  String get discoverShareLabel => 'Teilen';

  @override
  String get discoverHostLabel => 'Gastgeber';

  @override
  String get discoverHostMedalGoldLabel => 'Gold';

  @override
  String get discoverFollowersSuffix => ' Follower';

  @override
  String get discoverOverallRatingsSuffix => 'Gesamtbewertungen';

  @override
  String get exploreSwipeCardToday => 'Heute';

  @override
  String get exploreSearchHint => 'Hobby-Veranstaltungen suchen';

  @override
  String get exploreSwipeCardStartInPrefix => 'Beginnt in';

  @override
  String get exploreSwipeCardHostLabel => 'Gastgeber';

  @override
  String get exploreSwipeCardFollowersSuffix => 'Follower';

  @override
  String get exploreSwipeCardOverallRatingsLabel => 'Gesamtbewertungen';

  @override
  String get exploreCategoryVanLife => 'Van-Life';

  @override
  String get exploreCategoryPetLove => 'Tierliebe';

  @override
  String get exploreCategorySpirituality => 'Spiritualität';

  @override
  String get exploreCategoryBoardGames => 'Brettspiele';

  @override
  String get exploreDiscountDeclineMessage => 'Ablehnen';

  @override
  String get openLabel => 'Öffnen';

  @override
  String get exploreDiscountNoOfferTitle => 'Kein Angebot verfügbar';

  @override
  String get exploreDiscountCheckBackLaterMessage =>
      'Bitte schau später wieder vorbei.';

  @override
  String get exploreDiscountNoAdDetailsMessage =>
      'Es wurden keine Anzeigendetails angegeben.';

  @override
  String get exploreDiscountOfferFallback => 'Angebot';

  @override
  String get exploreLoadEventsFailed => 'Events konnten nicht geladen werden.';

  @override
  String get exploreInterestedLabel => 'Interessiert';

  @override
  String get exploreEventDetailLoadFailed =>
      'Eventdetails konnten nicht geladen werden.';

  @override
  String get birthdayNotificationTitle => 'Alles Gute zum Geburtstag!';

  @override
  String get birthdayNotificationMessage =>
      '„Happy Birthday! Ich hoffe, alle deine Geburtstagswünsche und Träume werden wahr.“';

  @override
  String get birthdayNotificationSignature => 'Kumele-Team';

  @override
  String get commentsTitle => 'Kommentare';

  @override
  String get previousLabel => 'Zurück';

  @override
  String get blogCommentRepliesCount => '3 Antworten';

  @override
  String get blogCommentReplayAction => 'Antworten';

  @override
  String get welcomeNotificationTitle => 'Willkommen bei Kumele';

  @override
  String get welcomeNotificationDate => '23. November 2022';

  @override
  String get welcomeNotificationBody =>
      'Willkommen bei Kumele! Wir freuen uns, dich an Bord zu haben. Entdecke Events in deiner Nähe, verbinde dich mit Gleichgesinnten und erlebe unvergessliche Momente.';

  @override
  String get createEventButtonLabel => 'Event erstellen';

  @override
  String get notificationsEmptyTitle => 'Keine Benachrichtigungen';

  @override
  String get notificationsEmptyDescription =>
      'Du hast derzeit keine neuen Benachrichtigungen. Schau später wieder vorbei.';

  @override
  String get exploreEmptyNoMoreMatches =>
      'Derzeit keine weiteren Übereinstimmungen,';

  @override
  String get exploreEmptyUntilThen => 'bis dahin';

  @override
  String get exploreEmptyCreateEventPromptSubtitle =>
      'Sei großartig und erstelle ein Event';

  @override
  String get exploreEmptyReadBlogPromptSubtitle =>
      'Hier sind einige Blogs, die dir gefallen könnten';

  @override
  String get exploreEmptyReadBlogButtonLabel => 'Blog lesen';

  @override
  String get exploreEmptyInviteFriendsPromptSubtitle =>
      'Sei großartig und lade deine Freunde ein';

  @override
  String get exploreEmptyInviteFriendsButtonLabel => 'Freunde einladen';

  @override
  String get exploreMatchedEventsSectionTitle => 'Übereinstimmendes Event';

  @override
  String get exploreCreatedEventsSectionTitle => 'Erstelltes Event';

  @override
  String get exploreHostFallbackName => 'Ich';

  @override
  String get addPaypalEmailOrMobileHint => 'E-Mail oder Mobilnummer';

  @override
  String get orDividerLabel => 'Oder';

  @override
  String get eventAdsLabel => 'Event-Anzeigen';

  @override
  String get paymentThankYouTitle => 'Danke!';

  @override
  String get paymentCompleteMessage => 'Deine Zahlung ist abgeschlossen.';

  @override
  String get viewPaymentLabel => 'Zahlung ansehen';

  @override
  String get statusLabel => 'Status';

  @override
  String get completedStatusLabel => 'Abgeschlossen';

  @override
  String get orderCodeLabel => 'Bestellcode';

  @override
  String get dateTimeLabel => 'Datum & Uhrzeit';

  @override
  String get exchangeRateLabel => 'Wechselkurs';

  @override
  String get totalLabel => 'Gesamt';

  @override
  String get paymentProcessedByLabel => 'Zahlung verarbeitet von';

  @override
  String get sendPaymentTitle => 'Zahlung senden';

  @override
  String get sendPaymentInstructions =>
      'Sende BTC an die folgende Adresse, um eine Zahlung durchzuführen';

  @override
  String get payWithWalletLabel => 'Mit Wallet bezahlen';

  @override
  String get amountLabel => 'Betrag';

  @override
  String get copyLabel => 'Kopieren';

  @override
  String get btcAddressLabel => 'BTC-Adresse';

  @override
  String get payWithCoinbaseLabel => 'Mit Coinbase bezahlen';

  @override
  String get selectCryptocurrencyLabel => 'Oder wähle eine Kryptowährung';

  @override
  String get showMoreLabel => 'Mehr anzeigen';

  @override
  String get noSubscriptionTierAvailable =>
      'Noch kein Abonnement-Tarif verfügbar.';

  @override
  String get signInBeforeSubscription =>
      'Bitte melde dich an, bevor du ein Abonnement startest.';

  @override
  String get subscriptionActivatedMessage => 'Abonnement aktiviert';

  @override
  String purchaseFailedMessage(Object error) {
    return 'Kauf fehlgeschlagen: $error';
  }

  @override
  String get subscriptionCheckoutSessionFailed =>
      'Die Checkout-Sitzung für das Abonnement konnte nicht erstellt werden.';

  @override
  String get subscribeLabel => 'Abonnieren';

  @override
  String get paymentCompleteShort => 'Zahlung abgeschlossen';

  @override
  String get checkoutStartedMessage => 'Checkout gestartet';

  @override
  String get subscriptionCreatedMessage => 'Abonnement erstellt';

  @override
  String get signInToManageSubscription =>
      'Bitte melde dich an, um ein Abonnement zu verwalten.';

  @override
  String get unableToCancelSubscription =>
      'Das Abonnement kann derzeit nicht gekündigt werden.';

  @override
  String get subscriptionCancellationRequested =>
      'Kündigung des Abonnements angefordert';

  @override
  String get unableToResumeSubscription =>
      'Das Abonnement kann derzeit nicht wieder aktiviert werden.';

  @override
  String get subscriptionResumedMessage => 'Abonnement wieder aktiviert';

  @override
  String get cryptoPaymentsComingSoon =>
      'Krypto-Zahlungen werden noch in den Live-Checkout-Flow integriert.';

  @override
  String get paymentLabel => 'Zahlung';

  @override
  String get amountToPayLabel => 'Zu zahlender Betrag';

  @override
  String get selectSubscriptionLabel => 'Abonnement auswählen';

  @override
  String get monthlyLabel => 'Monatlich';

  @override
  String get yearlyLabel => 'Jährlich';

  @override
  String tierPlanBillingSummary(Object cycle, Object tierName) {
    return '$tierName Plan • $cycle Abrechnung';
  }

  @override
  String get subscriptionPlansTitle => 'Abonnement-Pläne';

  @override
  String get noSubscriptionTiersAvailable =>
      'Derzeit sind keine Abonnement-Tarife verfügbar.';

  @override
  String get popularBadgeLabel => 'Beliebt';

  @override
  String get priceUnavailableLabel => 'Preis nicht verfügbar';

  @override
  String get currentSubscriptionTitle => 'Aktuelles Abonnement';

  @override
  String get signInCheckSubscriptionStatus =>
      'Melde dich an, um den Status deines aktiven Abonnements zu prüfen.';

  @override
  String get noActiveSubscriptionFound =>
      'Noch kein aktives Abonnement gefunden.';

  @override
  String get planLabel => 'Plan';

  @override
  String get unknownLabel => 'Unbekannt';

  @override
  String get renewsEndsLabel => 'Verlängert / endet';

  @override
  String get cancellationLabel => 'Kündigung';

  @override
  String get scheduledForPeriodEndLabel => 'Für Periodenende geplant';

  @override
  String get resumeSubscriptionLabel => 'Abonnement wieder aktivieren';

  @override
  String get cancelAtPeriodEndLabel => 'Am Periodenende kündigen';

  @override
  String get recentPaymentsTitle => 'Letzte Zahlungen';

  @override
  String get paymentHistoryAfterSignIn =>
      'Der Zahlungsverlauf ist nach der Anmeldung verfügbar.';

  @override
  String get noPaymentHistoryFound => 'Noch kein Zahlungsverlauf gefunden.';

  @override
  String paymentIdFallback(Object id) {
    return 'Zahlung $id';
  }

  @override
  String get providerUnknownLabel => 'Anbieter unbekannt';

  @override
  String get refreshDetailsLabel => 'Details aktualisieren';

  @override
  String get cryptoPaymentOptionsLabel => 'Krypto-Zahlungsoptionen';

  @override
  String get signInToSubscribeLabel => 'Anmelden zum Abonnieren';

  @override
  String get continueToCheckoutLabel => 'Weiter zum Checkout';

  @override
  String get enterDiscountCodeHint => 'Rabattcode eingeben';

  @override
  String get addDiscountCodeFirstMessage =>
      'Füge zuerst einen Rabattcode hinzu.';

  @override
  String get discountCodeValidatedAtCheckoutMessage =>
      'Der Rabattcode wird beim Start des Checkouts validiert.';

  @override
  String get applyLabel => 'Anwenden';

  @override
  String get authBannerSubscriptionMessage =>
      'Du kannst die Abonnement-Pläne jetzt einsehen, musst dich aber vor Checkout, Kündigung oder Zahlungsverlauf anmelden.';

  @override
  String get actionNotAllowedTitle => 'Aktion nicht erlaubt';

  @override
  String get removeCardTitle => 'Karte entfernen';

  @override
  String get connectEscrowAccountLabel => 'Verbinde dein Treuhandkonto';

  @override
  String get subscriptionsTitle => 'Abonnements';

  @override
  String get buyNowLabel => 'Jetzt kaufen';

  @override
  String get deactivateLabel => 'Deaktivieren';

  @override
  String get activateLabel => 'Aktivieren';

  @override
  String get confirmCardDeletionTitle => 'Kartenlöschung bestätigen';

  @override
  String get eventDetailsTitle => 'Eventdetails';

  @override
  String get eventNotFoundTitle => 'Event nicht gefunden';

  @override
  String get eventNotFoundDescription =>
      'Die angeforderten Eventdetails konnten nicht gefunden werden.';

  @override
  String get eventLocationLabel => 'Standort';

  @override
  String get capacityAvailabilityLabel => 'Kapazität & Verfügbarkeit';

  @override
  String capacityAvailabilitySummary(
      Object attendeeCount, Object capacity, Object spotsRemaining) {
    return '$attendeeCount / $capacity Teilnehmer ($spotsRemaining Plätze frei)';
  }

  @override
  String get turnOnSoundNotificationLabel => 'Ton-Benachrichtigung aktivieren';

  @override
  String get emailNotificationsLabel => 'E-Mail-Benachrichtigungen';

  @override
  String get medalBronzeTitle => 'Bronze-Status';

  @override
  String get medalBronzeDescription =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 2 Events erstellt oder an mindestens 2 Events ohne Ausfall teilgenommen. Der Benutzer erhält 2% Rabatt auf einen In-App-Kauf seiner Wahl.';

  @override
  String get medalSilverTitle => 'Silber-Status';

  @override
  String get medalSilverDescription =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 3 Events erstellt oder an mindestens 3 Events ohne Ausfall teilgenommen. Der Benutzer erhält 4% Rabatt auf einen In-App-Kauf seiner Wahl.';

  @override
  String get medalGoldTitle => 'Gold-Status';

  @override
  String get medalGoldDescription =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 4 Events erstellt oder an mindestens 4 Events ohne Ausfall teilgenommen. Der Benutzer erhält 8% Rabatt auf einen In-App-Kauf seiner Wahl.';

  @override
  String get connectTvLabel => 'TV verbinden';

  @override
  String get tvConnectedSuccessMessage => 'TV erfolgreich verbunden.';

  @override
  String get couldNotConnectTvMessage =>
      'Dieser TV konnte nicht verbunden werden.';

  @override
  String get blogCommentAuthorYou => 'Du';

  @override
  String get blogCommentJustNow => 'Gerade eben';

  @override
  String get discoverGoldBadgeLabel => 'Gold';

  @override
  String get paymentDialogTitle => 'Zahlung';

  @override
  String get paymentAmountToPayLabel => 'Zu zahlender Betrag';

  @override
  String get paymentSelectSubscriptionLabel => 'Abonnement auswählen';

  @override
  String get paymentPlanBulletSuffix => 'Plan •';

  @override
  String get paymentBillingSuffix => 'Abrechnung';

  @override
  String get paymentYearlyLabel => 'Jährlich';

  @override
  String get paymentMonthlyLabel => 'Monatlich';

  @override
  String get paymentDiscountCodeHint => 'Rabattcode eingeben';

  @override
  String get paymentDiscountCodeEmptyMessage =>
      'Füge zuerst einen Rabattcode hinzu.';

  @override
  String get paymentDiscountCodeValidationMessage =>
      'Der Rabattcode wird beim Start des Checkouts validiert.';

  @override
  String get paymentApplyLabel => 'Anwenden';

  @override
  String get paymentAuthBannerMessage =>
      'Du kannst die Abonnement-Pläne jetzt einsehen, musst dich aber vor Checkout, Kündigung oder Zahlungsverlauf anmelden.';

  @override
  String get paymentSubscriptionPlansTitle => 'Abonnement-Pläne';

  @override
  String get paymentNoTiersMessage =>
      'Derzeit sind keine Abonnement-Tarife verfügbar.';

  @override
  String get paymentPopularBadgeLabel => 'Beliebt';

  @override
  String get paymentPriceUnavailableLabel => 'Preis nicht verfügbar';

  @override
  String get paymentCurrentSubscriptionTitle => 'Aktuelles Abonnement';

  @override
  String get paymentSignInToCheckStatusMessage =>
      'Melde dich an, um den Status deines aktiven Abonnements zu prüfen.';

  @override
  String get paymentNoActiveSubscriptionMessage =>
      'Noch kein aktives Abonnement gefunden.';

  @override
  String get paymentStatusLabel => 'Status';

  @override
  String get paymentPlanLabel => 'Plan';

  @override
  String get paymentUnknownPlanLabel => 'Unbekannt';

  @override
  String get paymentRenewsEndsLabel => 'Verlängert / endet';

  @override
  String get paymentCancellationLabel => 'Kündigung';

  @override
  String get paymentScheduledForPeriodEndLabel => 'Für Periodenende geplant';

  @override
  String get paymentResumeSubscriptionLabel => 'Abonnement wieder aktivieren';

  @override
  String get paymentCancelAtPeriodEndLabel => 'Am Periodenende kündigen';

  @override
  String get paymentRecentPaymentsTitle => 'Letzte Zahlungen';

  @override
  String get paymentHistoryAfterSignInMessage =>
      'Der Zahlungsverlauf ist nach der Anmeldung verfügbar.';

  @override
  String get paymentNoHistoryMessage => 'Noch kein Zahlungsverlauf gefunden.';

  @override
  String paymentFallbackDescription(String id) {
    return 'Zahlung $id';
  }

  @override
  String get paymentProviderUnknownLabel => 'Anbieter unbekannt';

  @override
  String get paymentRefreshDetailsLabel => 'Details aktualisieren';

  @override
  String get paymentCryptoOptionsLabel => 'Krypto-Zahlungsoptionen';

  @override
  String get paymentSignInToSubscribeLabel => 'Anmelden zum Abonnieren';

  @override
  String get paymentContinueToCheckoutLabel => 'Weiter zum Checkout';

  @override
  String get interestMovies => 'Filme';

  @override
  String get interestPubsAndBars => 'Kneipen & Bars';

  @override
  String get interestLiveShow => 'Live-Show';

  @override
  String get interestClubbing => 'Clubbing';

  @override
  String get interestFestival => 'Festival';

  @override
  String get interestOutdoors => 'Draußen';

  @override
  String get interestVolunteer => 'Ehrenamt';

  @override
  String get interestDiy => 'DIY';

  @override
  String get interestActivism => 'Aktivismus';

  @override
  String get interestPetLove => 'Tierliebe';

  @override
  String get interestVideoGames => 'Videospiele';

  @override
  String get interestFamilyActivities => 'Familienaktivitäten';

  @override
  String get interestTech => 'Technik';

  @override
  String get interestCostume => 'Kostüm';

  @override
  String get interestFoodie => 'Foodie';

  @override
  String get interestCamping => 'Camping';

  @override
  String get medalBronzeSubtitle =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 2 Events erstellt oder an mindestens 2 Events ohne Ausfall teilgenommen. Der Benutzer erhält 2% Rabatt auf einen In-App-Kauf seiner Wahl.';

  @override
  String get medalSilverSubtitle =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 3 Events erstellt oder an mindestens 3 Events ohne Ausfall teilgenommen. Der Benutzer erhält 4% Rabatt auf einen In-App-Kauf seiner Wahl.';

  @override
  String get medalGoldSubtitle =>
      'Der Benutzer hat in den letzten 30 Tagen mindestens 4 Events erstellt oder an mindestens 4 Events ohne Ausfall teilgenommen. Der Benutzer erhält 8% Rabatt auf einen In-App-Kauf seiner Wahl.';

  @override
  String get removeCardActionNotAllowedTitle => 'Aktion nicht erlaubt';

  @override
  String get removeCardConnectEscrowLabel => 'Verbinde dein Treuhandkonto';

  @override
  String get removeCardSubscriptionsLabel => 'Abonnements';

  @override
  String get removeCardConfirmDeletionTitle => 'Kartenlöschung bestätigen';

  @override
  String get myEventDetailsLabel => 'Eventdetails';

  @override
  String get connectTvTitle => 'TV verbinden';

  @override
  String get advertDialogTitle => 'Werbung';

  @override
  String get advertEventStarts48hrs => 'Event beginnt in 48 Std.';

  @override
  String get advertEventStarts7days => 'Event beginnt in 7 Tagen';

  @override
  String get userAroundTitle => 'Benutzer in der Nähe';

  @override
  String get userAroundMessage =>
      'Derzeit wurden potenzielle Übereinstimmungen gefunden, die deinen Kriterien entsprechen';

  @override
  String get guestInviteTitle => 'Gästeinvitation';

  @override
  String get inviteFriendsToKumeleTitle => 'Lade deine Freunde zu Kumele ein';

  @override
  String get inviteReferralCodeLabel => 'Empfehlungscode';

  @override
  String get congratulationsTitle => 'Glückwunsch';

  @override
  String get congratsNewStatusBronze => 'Neuer Status: Bronze';

  @override
  String get congratsDiscountCode => 'Rabattcode: KEMELE20';

  @override
  String get congratsBronzeDescription =>
      'Du hast in den letzten 30 Tagen mindestens 3 Events erstellt oder an mindestens 3 Events ohne Ausfall teilgenommen. Der Benutzer erhält 4% Rabatt auf einen In-App-Kauf seiner Wahl.';

  @override
  String get passkeyIntroDescription =>
      'Passkeys sind einfach einzurichten und ermöglichen dir die sichere Anmeldung bei deinem Kumele-Konto mit den Sicherheitsfunktionen deiner Geräte wie Touch ID und Face ID. Passkeys sind wesentlich sicherer und einfacher zu verwenden als alle aktuellen 2-Faktor-Authentifizierungsmethoden.';

  @override
  String get passkeyTitle => 'Passkey';

  @override
  String get signInUsingPasskeyLabel => 'Mit Passkey anmelden';

  @override
  String get signupPasskeyEmailHint => 'Gib deine E-Mail ein';

  @override
  String get eventStartInLabel => 'Beginnt in';

  @override
  String get cancelEventTitle => 'Event absagen';

  @override
  String get setTimeTitle => 'Zeit festlegen';

  @override
  String get guestPricesTitle => 'Gästepreise';

  @override
  String get guestPricesUnavailableMessage =>
      'Gästepreise sind derzeit nicht verfügbar.';

  @override
  String get rewardRingsTitle => 'Belohnungsringe';

  @override
  String get moneyEarnedTitle => 'Verdientes Geld';

  @override
  String get tryAgainLabel => 'Erneut versuchen';

  @override
  String get locationServicesOffTitle => 'Standortdienste deaktiviert';

  @override
  String get locationAccessRequiredTitle => 'Standortzugriff erforderlich';

  @override
  String get locationServicesOffMessage =>
      'Bitte aktiviere die Standortdienste auf deinem Gerät, um Events in deiner Nähe zu entdecken.';

  @override
  String get locationPermissionPermanentlyDeniedMessage =>
      'Die Standortberechtigung wurde dauerhaft verweigert. Bitte aktiviere sie in den App-Einstellungen.';

  @override
  String get locationAccessNeededMessage =>
      'Der Standortzugriff ist erforderlich, um Events in deiner Nähe anzuzeigen.';

  @override
  String get joinEventConfirmTitle => 'Diesem Event beitreten?';

  @override
  String get joinLabel => 'Beitreten';

  @override
  String get kumeleTermsOfUseLabel => 'Kumele-Nutzungsbedingungen';

  @override
  String get eventCancelledDialogTitle => 'Event abgesagt';

  @override
  String get eventCancelledDialogMessage =>
      'Der Gastgeber hat das Event leider abgesagt. Wir entschuldigen uns für die Unannehmlichkeiten. Bei Vorauszahlungen wende dich bitte sofort an PayPal, um eine Erstattung zu erhalten.';

  @override
  String get premiumPurchaseIncludeLabel => 'Premium-In-App-Kauf beinhaltet:';

  @override
  String get premiumLocationChange => 'Standortwechsel';

  @override
  String get premiumHouseParty => 'Hausparty (max. 10 Gäste)';

  @override
  String get premiumNoAds => 'Keine Werbung';

  @override
  String get premium7DaysAdvertising => '7 Tage Vorab-Werbung für das Event';

  @override
  String get signupDateOfBirthLabel => 'Geburtsdatum';

  @override
  String get signupGenderLabel => 'Geschlecht';

  @override
  String get signUpButtonLabel => 'Registrieren';

  @override
  String myEventJoinedLabel(String date) {
    return 'Beigetreten $date';
  }

  @override
  String get myEventOrganizedByLabel => 'Organisiert von';

  @override
  String get myEventDateTimeLabel => 'Datum & Uhrzeit';

  @override
  String get myEventLocationLabel => 'Standort';

  @override
  String get myEventCapacityAvailabilityLabel => 'Kapazität & Verfügbarkeit';

  @override
  String get myEventAboutEventLabel => 'Über das Event';

  @override
  String get eventRulesTitle => 'Eventregeln & Infos';

  @override
  String eventRuleAgeLabel(String minAge, String maxAge) {
    return 'Alter: $minAge - $maxAge';
  }

  @override
  String get eventRuleNoAgeLimitLabel => 'Keine Begrenzung';

  @override
  String eventRuleGenderLabel(String gender) {
    return 'Geschlecht: $gender';
  }

  @override
  String eventRuleLanguageLabel(String language) {
    return 'Sprache: $language';
  }

  @override
  String get eventRuleRequiresApprovalLabel =>
      'Erfordert Genehmigung des Gastgebers';

  @override
  String get exploreMatchedEventLabel => 'Übereinstimmendes Event';

  @override
  String get exploreCreatedEventLabel => 'Erstelltes Event';

  @override
  String get exploreJoinNowLabel => 'Jetzt beitreten';

  @override
  String get exploreSwipeNoMoreMatchesLine1 =>
      'Derzeit keine weiteren Übereinstimmungen,';

  @override
  String get exploreSwipeNoMoreMatchesLine2 => 'bis dahin';

  @override
  String get exploreSwipeCreateEventCta =>
      'Sei großartig und erstelle ein Event';

  @override
  String get exploreSwipeBlogsSuggestion =>
      'Hier sind einige Blogs, die dir gefallen könnten';

  @override
  String get exploreSwipeInviteFriendsCta =>
      'Sei großartig und lade deine Freunde ein';

  @override
  String get exploreNotificationsTitle => 'Benachrichtigungen';

  @override
  String get exploreTabletHeaderTitle => 'Entdecken';

  @override
  String get createEventTitle => 'Event erstellen';

  @override
  String get previewEventLabel => 'Eventvorschau';

  @override
  String get createEventAgeRangeLabel => 'Altersspanne';

  @override
  String get createEventNumberOfGuestsLabel => 'Anzahl der Gäste';

  @override
  String get createEventRsvpGuestPaymentLabel => 'RSVP-Gästezahlung';

  @override
  String get createEventFreeEventLabel => 'Kostenloses Event';

  @override
  String get createEventCardPaymentLabel => 'Kartenzahlung';

  @override
  String get createEventCashOnEntryLabel => 'Barzahlung am Eingang';

  @override
  String get reportEventTitle => 'Event melden';

  @override
  String get reportEventChooseReasonLabel => 'Wähle einen Grund';

  @override
  String get ratingsTitle => 'Bewertungen';

  @override
  String get rateEventTitle => 'Event bewerten';

  @override
  String get attendeeRatingsLabel => 'Teilnehmerbewertungen (70%)';

  @override
  String get blogNoCommentsMessage =>
      'Noch keine Kommentare. Sei der Erste, der kommentiert!';

  @override
  String get nftPreviewTitle => 'NFT-Vorschau';

  @override
  String get nftClosePreviewLabel => 'Vorschau schließen';

  @override
  String get walletSignatureRequiredTitle => 'Wallet-Signatur erforderlich';

  @override
  String get dismissLabel => 'Schließen';

  @override
  String get soundNotificationTurnOnLabel => 'Ton-Benachrichtigung aktivieren';

  @override
  String get soundNotificationLabel => 'Ton-Benachrichtigung';

  @override
  String get turnOn2faLabel => '2-Faktor-Authentifizierung aktivieren';

  @override
  String get chooseInterestsTitle => 'Interessen auswählen';

  @override
  String chooseUpToInterestsLabel(String count) {
    return 'Wähle bis zu $count Interessen:';
  }

  @override
  String get earnMedalsAndRewardsTitle => 'Medaillen und Belohnungen verdienen';

  @override
  String otherEventsFromHostLabel(String hostName) {
    return 'Weitere Events von $hostName';
  }

  @override
  String get hobbyMeetupTagline => 'Hobby-Treffen';

  @override
  String get splashTagline =>
      'Wir spielen. Wir überwinden. Wir vereinen. Wir leben.';

  @override
  String get skipLabel => 'Überspringen';

  @override
  String get guestTileGroupMeditationLabel => 'Gruppenmeditation';

  @override
  String get guestTileHostedByLabel => 'Veranstaltet von Anki Maheshwari';

  @override
  String get guestTileLocationLabel => 'Bahawalpur, Punjab PK';

  @override
  String get filterMockLocationLabel =>
      'Vereinigtes Königreich, 39495, Kentucky';

  @override
  String get historyTitle => 'Verlauf';

  @override
  String get historyStatisticsTitle => 'Verlauf & Statistiken';

  @override
  String get blogDetailsTitle => 'Blogdetails';

  @override
  String get addCardTitle => 'Karte hinzufügen';

  @override
  String get addCardStripeMessage =>
      'Kartendaten werden sicher von Stripe erfasst.';

  @override
  String get addCardSubmitLabel => 'Karte hinzufügen';

  @override
  String get noNotificationsTitle => 'Keine Benachrichtigungen';

  @override
  String get noNotificationsDescription =>
      'Du hast derzeit keine neuen Benachrichtigungen. Schau später wieder vorbei.';

  @override
  String get reportReasonRacist => 'Rassistisch';

  @override
  String get reportReasonScam => 'Betrug';

  @override
  String get reportReasonOther => 'Sonstiges';

  @override
  String get reportReasonPhysicalAssault => 'Körperlicher Übergriff';

  @override
  String get rateAppTitle => 'Bitte bewerte deine letzte Veranstaltung';

  @override
  String get rateAppStoriesTitle => 'Bewerte diese App';

  @override
  String get rateAppThankYouTitle => 'Danke!';

  @override
  String get rateAppFeedbackTitle => 'Wie können wir es besser machen?';

  @override
  String get rateAppCommentHint => 'Kommentar hinzufügen';

  @override
  String get rateAppSendButton => 'Senden';

  @override
  String get chooseUsernameTitle => 'Wähle deinen Benutzernamen';

  @override
  String get chooseUsernameDescription =>
      'Benutzernamen können nur alle 3 Monate geändert werden.';

  @override
  String get chooseUsernameHint => 'Gib deinen Benutzernamen ein';

  @override
  String get chooseUsernameSkip => 'Überspringen';

  @override
  String get guestInviteTotalGuests => 'Gäste insgesamt';

  @override
  String get guestInviteFreeRange => '1–5 kostenlos';

  @override
  String get guestInviteDialogOr => ' oder ';

  @override
  String get signupLegalAdultCheckbox => 'Ich bin volljährig (18/21+)';

  @override
  String get signupSubscribeCheckbox => 'Newsletter abonnieren';

  @override
  String get signupTermsCheckboxPrefix =>
      'Durch die Erstellung eines Kontos stimmst du zu ';

  @override
  String get signupTermsCheckboxLink => 'Allgemeine Geschäftsbedingungen';

  @override
  String get signupCaptchaCheckbox => 'Ich bin kein Roboter';

  @override
  String get signupErrorFirstNameRequired => 'Bitte gib deinen Vornamen ein';

  @override
  String get signupErrorEmailRequired => 'Bitte gib deine E-Mail-Adresse ein';

  @override
  String get signupErrorEmailInvalid =>
      'Bitte gib eine gültige E-Mail-Adresse ein';

  @override
  String get signupErrorPasswordRequired => 'Bitte Passwort eingeben';

  @override
  String get signupErrorPasswordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get signupErrorConfirmPasswordRequired => 'Bitte Passwort bestätigen';

  @override
  String get signupErrorPasswordMismatch => 'Passwörter stimmen nicht überein';

  @override
  String get signupErrorLegalAgeRequired =>
      'Du musst bestätigen, dass du volljährig bist';

  @override
  String get signupErrorTermsRequired =>
      'Du musst die Allgemeinen Geschäftsbedingungen akzeptieren';

  @override
  String get signupErrorCaptchaRequired =>
      'Bitte bestätige, dass du kein Roboter bist';

  @override
  String get permissionGuestInviteTitle => 'Gästeinvitation';

  @override
  String get permissionEventCanceledTitle => 'Veranstaltung abgesagt';

  @override
  String get permissionFollowHostTitle => 'Gastgeber folgen';

  @override
  String get permissionFollowHostConfirm => 'Folgen';

  @override
  String get permissionUsernameHint => 'Benutzernamen eingeben';

  @override
  String get exploreSwipeCreateEventButton => 'Veranstaltung erstellen';

  @override
  String get exploreSwipeReadBlogButton => 'Blog lesen';

  @override
  String get exploreSwipeInviteFriendsButton => 'Freunde einladen';

  @override
  String get twoFactorGoogleAuthenticator => 'Google\nAuthenticator';

  @override
  String get twoFactorAuthy => 'Authy';

  @override
  String get twoFactorDuo => 'Duo';

  @override
  String get twoFactorMicrosoftAuthenticator => 'Microsoft\nAuthenticator';

  @override
  String get paymentPayPalLabel => 'PayPal';

  @override
  String get paymentMasterCardLabel => 'Mastercard';

  @override
  String paymentCardExpiresLabel(String date) {
    return 'Läuft ab $date';
  }

  @override
  String get paymentCoinbaseCommerceLabel => ' Coinbase Commerce';

  @override
  String get paymentEthereumLabel => 'Ethereum';

  @override
  String get paymentDogecoinLabel => 'Dogecoin';

  @override
  String get paymentUsdCoinLabel => 'USD Coin';

  @override
  String paymentTransactionIdLabel(String id) {
    return '$id';
  }

  @override
  String paymentTransactionDateLabel(String date) {
    return '$date';
  }

  @override
  String paymentTransactionAmountLabel(String amount) {
    return '$amount';
  }

  @override
  String get socialMediaYouTube => 'YouTube';

  @override
  String get socialMediaFacebook => 'Facebook';

  @override
  String get socialMediaInstagram => 'Instagram';

  @override
  String get socialMediaPinterest => 'Pinterest';

  @override
  String get socialMediaTwitter => 'Twitter';

  @override
  String get termsSection1Title => '1. Kontoberechtigung';

  @override
  String get termsSection2Title => '2. Zulässige Nutzung';

  @override
  String get termsSection3Title => '3. Veranstaltungen und Community-Inhalte';

  @override
  String get termsSection4Title => '4. Zahlungen und Abonnements';

  @override
  String get termsSection5Title => '5. Datenschutz und Kommunikation';

  @override
  String get termsSection6Title => '6. Kündigung';

  @override
  String get termsSection7Title => '7. Änderungen dieser Bedingungen';

  @override
  String get nftClaimingButton => 'Wird eingelöst…';

  @override
  String get nftBuyingButton => 'Wird gekauft…';

  @override
  String get nftClaimButton => 'Einlösen';

  @override
  String get nftBuyButton => 'Kaufen';

  @override
  String get languageUpdateFailed =>
      'Sprache konnte nicht aktualisiert werden.';

  @override
  String get eventDetailNotFound =>
      'Die angeforderten Veranstaltungsdetails konnten nicht gefunden werden.';

  @override
  String myEventAttendeesLabel(int count, int capacity, int remaining) {
    return '$count / $capacity Teilnehmer ($remaining Plätze frei)';
  }

  @override
  String get shareEventDialogOr => ' oder ';

  @override
  String aboutHostPrefix(String hostName) {
    return 'Über $hostName: ';
  }

  @override
  String get pleaseCompleteAllFields => 'Bitte fülle alle Felder aus';

  @override
  String get ratingSubmittedSuccess => 'Bewertung erfolgreich gesendet';

  @override
  String get ratingSubmitFailed => 'Bewertung konnte nicht gesendet werden';

  @override
  String get reportSubmittedSuccess => 'Meldung erfolgreich gesendet';

  @override
  String get reportSubmitFailed => 'Meldung konnte nicht gesendet werden';

  @override
  String get markAllAsRead => 'Alle als gelesen markieren';

  @override
  String get paymentAddNewCardLabel => 'Neue Karte hinzufügen';

  @override
  String get paymentPayNowLabel => 'Jetzt bezahlen';

  @override
  String get paymentPayWithLabel => 'Bezahlen mit';

  @override
  String get useCurrentLocation => 'Aktuellen Standort verwenden';

  @override
  String get orEnterAnAddress => 'ODER ADRESSE EINGEBEN';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get saveLocation => 'Standort speichern';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get changeInterestsTitle => 'Interessen ändern';

  @override
  String get houseNumberLabel => 'Nummer';

  @override
  String get districtCityLabel => 'Bezirk / Stadt';

  @override
  String get permissionNotificationPrimerTitle =>
      '„Kumele“ möchte dir Push-Benachrichtigungen senden';

  @override
  String get permissionNotificationPrimerMessage =>
      'Benachrichtigungen können Hinweise, Töne und Symbol-Badges enthalten. Diese können in den Einstellungen konfiguriert werden.';

  @override
  String get permissionPhotosPrimerTitle =>
      '„Kumele“ möchte auf deine Fotos zugreifen';

  @override
  String get permissionPhotosPrimerMessage =>
      'Erlaube „Kumele“ den Zugriff auf deine Fotos, um Bilder oder Videos zu senden';

  @override
  String get permissionLocationPrimerTitle =>
      '„Kumele“ erlauben, auf deinen Standort zuzugreifen?';

  @override
  String get permissionLocationPrimerMessage =>
      'Erlaube „Kumele“ den Zugriff auf deinen Standort, um Events in deiner Nähe zu zeigen';

  @override
  String get permissionDontAllow => 'Nicht erlauben';

  @override
  String get permissionAllow => 'Erlauben';

  @override
  String get permissionSelectPhotos => 'Fotos auswählen …';

  @override
  String get permissionAllowAllPhotos => 'Zugriff auf alle Fotos erlauben';

  @override
  String get permissionAllowWhileUsingApp => 'Beim Verwenden der App erlauben';

  @override
  String get permissionAllowOnce => 'Einmal erlauben';

  @override
  String get myEventPlaceholderTitle => 'Titel des Hobby-Events';

  @override
  String get myEventPlaceholderTime => '12:00-13:00';

  @override
  String get myEventPlaceholderStartTime => 'Beginnt in 2 T';

  @override
  String get myEventPlaceholderLocation => 'Stadtzentrum, Berlin';

  @override
  String get welcomeToKumeleMessage => 'Willkommen bei Kumele!';

  @override
  String get selectDateTimeFirstError =>
      'Bitte wähle zuerst Datum und Uhrzeit aus.';

  @override
  String get accountCreatedSuccessMessage => 'Konto erfolgreich erstellt!';

  @override
  String signupFailedPrefix(String error) {
    return 'Registrierung fehlgeschlagen: $error';
  }

  @override
  String get nftClaimedMessage => 'NFT beansprucht.';

  @override
  String get nftClaimFailedError =>
      'Dieses NFT konnte nicht beansprucht werden.';

  @override
  String get nftPurchasedMessage => 'NFT gekauft.';

  @override
  String get nftPurchaseFailedError =>
      'Dieses NFT konnte nicht gekauft werden.';

  @override
  String get loadBlogPostFailedError =>
      'Blogbeitrag konnte nicht geladen werden.';

  @override
  String get paypalAccountConnectedMessage => 'PayPal-Konto verbunden.';

  @override
  String get restoringPurchasesMessage =>
      'Käufe werden wiederhergestellt – das kann einen Moment dauern.';

  @override
  String get cardSetupUnavailableError =>
      'Kartenkonfiguration ist nicht verfügbar.';

  @override
  String get cardAddedSuccessMessage => 'Karte erfolgreich hinzugefügt.';

  @override
  String get addCardFailedError => 'Karte konnte nicht hinzugefügt werden.';

  @override
  String get copiedMessage => 'Kopiert';

  @override
  String get eventCreatedPendingPaymentMessage =>
      'Event erstellt. Schließe die Zahlung ab, um es zu aktivieren.';

  @override
  String get eventCreatedSuccessMessage => 'Event erfolgreich erstellt.';
}
