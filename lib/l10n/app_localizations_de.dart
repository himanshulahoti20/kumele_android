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
  String get daysLeftToRate => 'Noch -- Tage zum Bewerten &\nÜberprüfen';

  @override
  String get scannedList => 'Gescannte Liste: --';

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
  String get cardPaymentsSubscriptions => 'Kartenzahlungen, Abos & Treuhand';

  @override
  String get security => 'Sicherheit';

  @override
  String get contact => 'Kontakt';

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
  String get groupMeditation => 'Gruppenmeditation';

  @override
  String get demoHostName => 'Ankit Maheswari';

  @override
  String get demoLocation => 'Bahawalpur, Punjab Pakistan';

  @override
  String get signIn => 'Einloggen';

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
  String get createEventNameLabel => 'Event Name';

  @override
  String get createEventTitleHint => 'Add a title';

  @override
  String get createEventSubtitleLabel => 'Subtitle';

  @override
  String get createEventSubtitleHint => 'Add a subtitle';

  @override
  String get createEventDescriptionMaxLabel => 'Max';

  @override
  String get createEventDescriptionLabel => 'Description';

  @override
  String get createEventDescriptionHint => 'More about the event';

  @override
  String get createEventDateLabel => 'Date';

  @override
  String get createEventStartTimeLabel => 'Event Start time';

  @override
  String get createEventStartTimePlaceholder => 'Start time';

  @override
  String get createEventEndTimeLabel => 'Event End time';

  @override
  String get createEventEndTimePlaceholder => 'End time';

  @override
  String get createEventCheckAvailabilityLabel => 'Check User Availability';

  @override
  String get createEventAvailabilityDisclaimer =>
      'To use this, please add your address and number of guest. Disclaimer: we cannot guarantee 100%\nmatches due to certain factors beyond our control.';

  @override
  String get createEventStartsInLabel => 'Event starts in';

  @override
  String get createEventDecreaseTimeSemanticLabel => 'Decrease time';

  @override
  String get createEventIncreaseTimeSemanticLabel => 'Increase time';

  @override
  String get createEventStreetLabel => 'Street';

  @override
  String get createEventStreetHint => 'Enter street';

  @override
  String get createEventHomeNumberLabel => 'Home Number';

  @override
  String get createEventHomeNumberHint => 'Enter home number';

  @override
  String get createEventDistrictLabel => 'District';

  @override
  String get createEventDistrictHint => 'Enter district';

  @override
  String get createEventPostalCodeLabel => 'Postal/zip code';

  @override
  String get createEventPostalCodeHint => 'Enter postal or zip code';

  @override
  String get createEventStateLabel => 'State';

  @override
  String get createEventStateHint => 'Enter state';

  @override
  String get createEventUploadImageTitle => 'Upload Image';

  @override
  String get createEventUploadImageSubtitle =>
      'Choose a source for your event image';

  @override
  String get createEventCategoryPlaceholder => 'Category';

  @override
  String get createEventCategoryLabel => 'Event Category';

  @override
  String get createEventImageLabel => 'Event Image';

  @override
  String get createEventImageSizeHint => '(Recommended size 400 x 400px)';

  @override
  String get createEventStripeConnectedLabel => 'Stripe Connected';

  @override
  String get createEventPreviewSubmitLabel => 'Create Event';

  @override
  String get createEventPreviewGuestsSuffix => 'guests';

  @override
  String get createEventPreviewAlreadyStarted => 'Event has already started';

  @override
  String createEventPreviewStartsInDays(Object days) {
    return 'Starts in $days days';
  }

  @override
  String get createEventPreviewStartsTomorrow => 'Starts tomorrow';

  @override
  String createEventPreviewStartsInHour(Object hours) {
    return 'Starts in $hours hour';
  }

  @override
  String createEventPreviewStartsInHours(Object hours) {
    return 'Starts in $hours hours';
  }

  @override
  String createEventPreviewStartsInMinute(Object minutes) {
    return 'Starts in $minutes minute';
  }

  @override
  String createEventPreviewStartsInMinutes(Object minutes) {
    return 'Starts in $minutes minutes';
  }

  @override
  String get createEventPreviewStartingNow => 'Starting now';

  @override
  String get createEventPreviewDefaultCategory => 'Spirituality';

  @override
  String get createEventPreviewDefaultHostName => 'Me';

  @override
  String createEventPreviewExpectedLabel(Object label) {
    return 'Expected $label';
  }

  @override
  String createEventPreviewPricingLabel(Object label) {
    return 'Pricing $label';
  }

  @override
  String get discoverNoMatchesMessage =>
      'No more matches currently, until then';

  @override
  String get discoverGuestsSuffix => 'guests';

  @override
  String get discoverLocationLabel => 'Location:';

  @override
  String get discoverMockLocationLabel => 'Indore, Madhya radesh, IN';

  @override
  String get discoverStartsInLabel => 'Starts in';

  @override
  String get discoverHoursSuffix => 'hrs';

  @override
  String get discoverShareLabel => 'Share';

  @override
  String get discoverMockEventTitle =>
      '🌟 Invitation to a Transformative Yoga Experience: Kundalini Awakening Gathering';

  @override
  String get discoverMockEventDescription =>
      'Embark on a profound journey of self-discovery and inner transformation with our exclusive Kundalini Awakening Yoga event! We invite you to join us for a harmonious gathering where ten individuals will come together to explore the ancient practice of Kundalini yoga. This';

  @override
  String get discoverHostLabel => 'Host';

  @override
  String get discoverHostMedalGoldLabel => 'Gold';

  @override
  String get discoverMockAboutHostLabel => 'About Alkesh:';

  @override
  String get discoverMockAboutHostText =>
      'Engineering Marvel with a Passion for Beats and Serenity';

  @override
  String get discoverMockHostBio =>
      'Welcome to my world of innovation and\nrhythm! I’m Alkesh, an engineer by profession\nand a connoisseur of life’s eclectic\nexperiences.';

  @override
  String get discoverFollowersSuffix => ' followers';

  @override
  String get discoverOverallRatingsSuffix => 'Overall Ratings';

  @override
  String get discoverMockCategoryLabel => '90’s Hip-Hop';

  @override
  String get discoverMockPartyTypeLabel => 'House Party';

  @override
  String get discoverMockRatingSummaryLabel => '3.6 out of 5';

  @override
  String get discoverMockGuestRatingsLabel => '6 Guest ratings';

  @override
  String get discoverMockReviewerName => 'Jakob Hoffman';

  @override
  String get discoverMockReviewDate => '⬤ 23 August 2023';

  @override
  String get discoverMockReviewText =>
      'What a display  dsn  cdn zxnc nzc njzcn nzcjcnzjncjcnzjcnzc ncnz cjkznkcnzc kcnznczn cznzxnc  czc znc zncznc z nzcxnjcc ncjcnz nc nzcnnz cc';

  @override
  String get discoverMockOtherEventsLabel => 'Other Events from Alkesh';

  @override
  String get exploreSwipeCardToday => 'Today';

  @override
  String get exploreSwipeCardStartInPrefix => 'Start in';

  @override
  String get exploreSwipeCardHostLabel => 'Host';

  @override
  String get exploreSwipeCardFollowersSuffix => 'followers';

  @override
  String get exploreSwipeCardOverallRatingsLabel => 'Overall Ratings';

  @override
  String get exploreCategoryVanLife => 'Van Life';

  @override
  String get exploreCategoryPetLove => 'Pet Love';

  @override
  String get exploreCategorySpirituality => 'Sprituality';

  @override
  String get exploreCategoryBoardGames => 'Board Games';

  @override
  String get exploreDiscountDeclineMessage => 'Decline';

  @override
  String get openLabel => 'Open';

  @override
  String get exploreDiscountNoOfferTitle => 'No offer available';

  @override
  String get exploreDiscountCheckBackLaterMessage => 'Please check back later.';

  @override
  String get exploreDiscountNoAdDetailsMessage =>
      'No ad details were provided.';

  @override
  String get exploreDiscountOfferFallback => 'Offer';

  @override
  String get exploreLoadEventsFailed => 'Failed to load events.';

  @override
  String get exploreInterestedLabel => 'Interested';

  @override
  String get exploreEventDetailLoadFailed => 'Failed to load event details.';

  @override
  String get birthdayNotificationTitle => 'Wish you a Happy Birthday!';

  @override
  String get birthdayNotificationMessage =>
      '“Happy birthday! I hope all your birthday wishes\n and dreams come true.”';

  @override
  String get birthdayNotificationSignature => 'Kuemele Team  ';

  @override
  String get commentsTitle => 'Comments';

  @override
  String get previousLabel => 'Previous';

  @override
  String get blogCommentRepliesCount => '3 Replies';

  @override
  String get blogCommentReplayAction => 'Replay';

  @override
  String get welcomeNotificationTitle => 'Welcome to Kuemele';

  @override
  String get welcomeNotificationDate => '23November, 2022';

  @override
  String get welcomeNotificationBody =>
      'Maecenas quam nunc, sagittis non condimentum at, rutrum sit amet\n eros. Fusce rutrum,lectus\n \nin blandit sagittis, mi tortor ullamcorper mi, vitae vestibulum libero quam a nisi.\n\n In eu mauris et neque sodales porta eu eget dui. Nunc eu quam sit amet justo elementum mollis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.s quis lectus maximus fermentum.';

  @override
  String get createEventButtonLabel => 'Create Event';

  @override
  String get notificationsEmptyTitle => 'No Notifications';

  @override
  String get notificationsEmptyDescription =>
      'You have no new notifications right now. Check back later.';

  @override
  String get exploreEmptyNoMoreMatches => 'No more matches currently,';

  @override
  String get exploreEmptyUntilThen => 'until then';

  @override
  String get exploreEmptyCreateEventPromptSubtitle =>
      'Be awesome and create an event';

  @override
  String get exploreEmptyReadBlogPromptSubtitle =>
      'Here are some blogs you may like';

  @override
  String get exploreEmptyReadBlogButtonLabel => 'Read Blog';

  @override
  String get exploreEmptyInviteFriendsPromptSubtitle =>
      'Be awesome and invite your friends';

  @override
  String get exploreEmptyInviteFriendsButtonLabel => 'Invite Friends';

  @override
  String get exploreMatchedEventsSectionTitle => 'Matched Event';

  @override
  String get exploreCreatedEventsSectionTitle => 'Created Event';

  @override
  String get exploreHostFallbackName => 'Me';

  @override
  String get addPaypalEmailOrMobileHint => 'Email or Mobile number';

  @override
  String get orDividerLabel => 'Or';

  @override
  String get eventAdsLabel => 'Event Ads';

  @override
  String get paymentThankYouTitle => 'Thank You!';

  @override
  String get paymentCompleteMessage => 'Your payment is complete.';

  @override
  String get viewPaymentLabel => 'View Payment';

  @override
  String get statusLabel => 'Status';

  @override
  String get completedStatusLabel => 'Completed';

  @override
  String get orderCodeLabel => 'Order code';

  @override
  String get dateTimeLabel => 'Date & Time';

  @override
  String get exchangeRateLabel => 'Exchange Rate';

  @override
  String get totalLabel => 'Total';

  @override
  String get paymentProcessedByLabel => 'Payment processed by';

  @override
  String get sendPaymentTitle => 'Send Payment';

  @override
  String get sendPaymentInstructions =>
      'To make a payment, send BTC to the address below';

  @override
  String get payWithWalletLabel => 'Pay With wallet';

  @override
  String get amountLabel => 'Amount';

  @override
  String get copyLabel => 'Copy';

  @override
  String get btcAddressLabel => 'BTC Address';

  @override
  String get payWithCoinbaseLabel => 'Pay with Coinbase';

  @override
  String get selectCryptocurrencyLabel => 'Or select a cryptocurrency';

  @override
  String get showMoreLabel => 'Show more';

  @override
  String get noSubscriptionTierAvailable =>
      'No subscription tier available yet.';

  @override
  String get signInBeforeSubscription =>
      'Please sign in before starting a subscription.';

  @override
  String get subscriptionActivatedMessage => 'Subscription activated';

  @override
  String purchaseFailedMessage(Object error) {
    return 'Purchase failed: $error';
  }

  @override
  String get subscriptionCheckoutSessionFailed =>
      'Could not create the subscription checkout session.';

  @override
  String get subscribeLabel => 'Subscribe';

  @override
  String get paymentCompleteShort => 'Payment complete';

  @override
  String get checkoutStartedMessage => 'Checkout started';

  @override
  String get subscriptionCreatedMessage => 'Subscription created';

  @override
  String get signInToManageSubscription =>
      'Please sign in to manage a subscription.';

  @override
  String get unableToCancelSubscription =>
      'Unable to cancel subscription right now.';

  @override
  String get subscriptionCancellationRequested =>
      'Subscription cancellation requested';

  @override
  String get unableToResumeSubscription =>
      'Unable to resume subscription right now.';

  @override
  String get subscriptionResumedMessage => 'Subscription resumed';

  @override
  String get cryptoPaymentsComingSoon =>
      'Crypto payments are still being wired to the live checkout flow.';

  @override
  String get paymentLabel => 'Payment';

  @override
  String get amountToPayLabel => 'Amount to pay';

  @override
  String get selectSubscriptionLabel => 'Select a subscription';

  @override
  String get monthlyLabel => 'Monthly';

  @override
  String get yearlyLabel => 'Yearly';

  @override
  String tierPlanBillingSummary(Object cycle, Object tierName) {
    return '$tierName plan • $cycle billing';
  }

  @override
  String get subscriptionPlansTitle => 'Subscription plans';

  @override
  String get noSubscriptionTiersAvailable =>
      'No subscription tiers are available right now.';

  @override
  String get popularBadgeLabel => 'Popular';

  @override
  String get priceUnavailableLabel => 'Price unavailable';

  @override
  String get currentSubscriptionTitle => 'Current subscription';

  @override
  String get signInCheckSubscriptionStatus =>
      'Sign in to check your active subscription status.';

  @override
  String get noActiveSubscriptionFound => 'No active subscription found yet.';

  @override
  String get planLabel => 'Plan';

  @override
  String get unknownLabel => 'Unknown';

  @override
  String get renewsEndsLabel => 'Renews / ends';

  @override
  String get cancellationLabel => 'Cancellation';

  @override
  String get scheduledForPeriodEndLabel => 'Scheduled for period end';

  @override
  String get resumeSubscriptionLabel => 'Resume subscription';

  @override
  String get cancelAtPeriodEndLabel => 'Cancel at period end';

  @override
  String get recentPaymentsTitle => 'Recent payments';

  @override
  String get paymentHistoryAfterSignIn =>
      'Payment history becomes available after sign in.';

  @override
  String get noPaymentHistoryFound => 'No payment history found yet.';

  @override
  String paymentIdFallback(Object id) {
    return 'Payment $id';
  }

  @override
  String get providerUnknownLabel => 'Provider unknown';

  @override
  String get refreshDetailsLabel => 'Refresh details';

  @override
  String get cryptoPaymentOptionsLabel => 'Crypto payment options';

  @override
  String get signInToSubscribeLabel => 'Sign in to subscribe';

  @override
  String get continueToCheckoutLabel => 'Continue to checkout';

  @override
  String get enterDiscountCodeHint => 'Enter discount code';

  @override
  String get addDiscountCodeFirstMessage => 'Add a discount code first.';

  @override
  String get discountCodeValidatedAtCheckoutMessage =>
      'Discount code will be validated when checkout starts.';

  @override
  String get applyLabel => 'Apply';

  @override
  String get authBannerSubscriptionMessage =>
      'You can review subscription plans now, but you need to sign in before checkout, cancellation, or payment history will work.';

  @override
  String get actionNotAllowedTitle => 'Action not allowed';

  @override
  String get removeCardTitle => 'Remove Card';

  @override
  String get connectEscrowAccountLabel => 'Connect your Escrow Account';

  @override
  String get subscriptionsTitle => 'Subscriptions';

  @override
  String get buyNowLabel => 'Buy now';

  @override
  String get deactivateLabel => 'Deactivate';

  @override
  String get activateLabel => 'Activate';

  @override
  String get confirmCardDeletionTitle => 'Confirm card deletion';

  @override
  String get eventDetailsTitle => 'Event Details';

  @override
  String get eventNotFoundTitle => 'Event Not Found';

  @override
  String get eventNotFoundDescription =>
      'The requested event details could not be found.';

  @override
  String get eventLocationLabel => 'Location';

  @override
  String get capacityAvailabilityLabel => 'Capacity & Availability';

  @override
  String capacityAvailabilitySummary(
      Object attendeeCount, Object capacity, Object spotsRemaining) {
    return '$attendeeCount / $capacity Attendees ($spotsRemaining spots left)';
  }

  @override
  String get turnOnSoundNotificationLabel => 'Turn on Sound notification';

  @override
  String get emailNotificationsLabel => 'E-Mail notifications';

  @override
  String get medalBronzeTitle => 'Bronze Status';

  @override
  String get medalBronzeDescription =>
      'User created a minimum of 2 events or user attended a minimum of 2 events without fail in the last 30 days. The user gets 2% discount of 1 in-app purchase of choice.';

  @override
  String get medalSilverTitle => 'Silver Status';

  @override
  String get medalSilverDescription =>
      'User created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of 1 in-app purchase of choice.';

  @override
  String get medalGoldTitle => 'Gold Status';

  @override
  String get medalGoldDescription =>
      'User created a minimum of 4 events or user attended a minimum of 4 events without fail in the last 30 days. The user gets 8% discount of 1 in-app purchase of choice.';

  @override
  String get connectTvLabel => 'Connect TV';

  @override
  String get tvConnectedSuccessMessage => 'TV connected successfully.';

  @override
  String get couldNotConnectTvMessage => 'Could not connect this TV.';

  @override
  String get blogCommentAuthorYou => 'You';

  @override
  String get blogCommentJustNow => 'Just now';

  @override
  String get discoverGoldBadgeLabel => 'Gold';

  @override
  String get paymentDialogTitle => 'Payment';

  @override
  String get paymentAmountToPayLabel => 'Amount to pay';

  @override
  String get paymentSelectSubscriptionLabel => 'Select a subscription';

  @override
  String get paymentPlanBulletSuffix => 'plan •';

  @override
  String get paymentBillingSuffix => 'billing';

  @override
  String get paymentYearlyLabel => 'Yearly';

  @override
  String get paymentMonthlyLabel => 'Monthly';

  @override
  String get paymentDiscountCodeHint => 'Enter discount code';

  @override
  String get paymentDiscountCodeEmptyMessage => 'Add a discount code first.';

  @override
  String get paymentDiscountCodeValidationMessage =>
      'Discount code will be validated when checkout starts.';

  @override
  String get paymentApplyLabel => 'Apply';

  @override
  String get paymentAuthBannerMessage =>
      'You can review subscription plans now, but you need to sign in before checkout, cancellation, or payment history will work.';

  @override
  String get paymentSubscriptionPlansTitle => 'Subscription plans';

  @override
  String get paymentNoTiersMessage =>
      'No subscription tiers are available right now.';

  @override
  String get paymentPopularBadgeLabel => 'Popular';

  @override
  String get paymentPriceUnavailableLabel => 'Price unavailable';

  @override
  String get paymentCurrentSubscriptionTitle => 'Current subscription';

  @override
  String get paymentSignInToCheckStatusMessage =>
      'Sign in to check your active subscription status.';

  @override
  String get paymentNoActiveSubscriptionMessage =>
      'No active subscription found yet.';

  @override
  String get paymentStatusLabel => 'Status';

  @override
  String get paymentPlanLabel => 'Plan';

  @override
  String get paymentUnknownPlanLabel => 'Unknown';

  @override
  String get paymentRenewsEndsLabel => 'Renews / ends';

  @override
  String get paymentCancellationLabel => 'Cancellation';

  @override
  String get paymentScheduledForPeriodEndLabel => 'Scheduled for period end';

  @override
  String get paymentResumeSubscriptionLabel => 'Resume subscription';

  @override
  String get paymentCancelAtPeriodEndLabel => 'Cancel at period end';

  @override
  String get paymentRecentPaymentsTitle => 'Recent payments';

  @override
  String get paymentHistoryAfterSignInMessage =>
      'Payment history becomes available after sign in.';

  @override
  String get paymentNoHistoryMessage => 'No payment history found yet.';

  @override
  String paymentFallbackDescription(String id) {
    return 'Payment $id';
  }

  @override
  String get paymentProviderUnknownLabel => 'Provider unknown';

  @override
  String get paymentRefreshDetailsLabel => 'Refresh details';

  @override
  String get paymentCryptoOptionsLabel => 'Crypto payment options';

  @override
  String get paymentSignInToSubscribeLabel => 'Sign in to subscribe';

  @override
  String get paymentContinueToCheckoutLabel => 'Continue to checkout';

  @override
  String get interestMovies => 'Movies';

  @override
  String get interestPubsAndBars => 'Pubs & Bars';

  @override
  String get interestLiveShow => 'Live show';

  @override
  String get interestClubbing => 'Clubbing';

  @override
  String get interestFestival => 'Festival';

  @override
  String get interestOutdoors => 'Outdoors';

  @override
  String get interestVolunteer => 'Volunteer';

  @override
  String get interestDiy => 'DIY';

  @override
  String get interestActivism => 'Activism';

  @override
  String get interestPetLove => 'Pet love';

  @override
  String get interestVideoGames => 'Video Games';

  @override
  String get interestFamilyActivities => 'Family activities';

  @override
  String get interestTech => 'Tech';

  @override
  String get interestCostume => 'Costume';

  @override
  String get interestFoodie => 'Foodie';

  @override
  String get interestCamping => 'Camping';

  @override
  String get medalBronzeSubtitle =>
      'User created a minimum of 2 events or user attended a minimum of 2 events without fail in the last 30 days. The user gets 2% discount of 1 in-app purchase of choice.';

  @override
  String get medalSilverSubtitle =>
      'User created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of 1 in-app purchase of choice.';

  @override
  String get medalGoldSubtitle =>
      'User created a minimum of 4 events or user attended a minimum of 4 events without fail in the last 30 days. The user gets 8% discount of 1 in-app purchase of choice.';

  @override
  String get removeCardActionNotAllowedTitle => 'Action not allowed';

  @override
  String get removeCardConnectEscrowLabel => 'Connect your Escrow Account';

  @override
  String get removeCardSubscriptionsLabel => 'Subscriptions';

  @override
  String get removeCardConfirmDeletionTitle => 'Confirm card deletion';

  @override
  String get myEventDetailsLabel => 'Event Details';

  @override
  String get connectTvTitle => 'Connect TV';

  @override
  String get advertDialogTitle => 'Advert';

  @override
  String get advertEventStarts48hrs => 'Event starts in 48 hrs';

  @override
  String get advertEventStarts7days => 'Event starts in 7 days';

  @override
  String get userAroundTitle => 'User Around';

  @override
  String get userAroundMessage =>
      'Potential matches matching your criteria found currently';

  @override
  String get guestInviteTitle => 'Guest Invite';

  @override
  String get inviteFriendsToKumeleTitle => 'Invite your friends to Kumele';

  @override
  String get inviteReferralCodeLabel => 'Referral code';

  @override
  String get congratulationsTitle => 'Congratulations';

  @override
  String get congratsNewStatusBronze => 'New Status: Bronze';

  @override
  String get congratsDiscountCode => 'Discount Code: KEMELE20';

  @override
  String get congratsBronzeDescription =>
      'You created a minimum of 3 events or user attended a minimum of 3 events without fail in the last 30 days. The user gets 4% discount of one in-app purchase of choice.';

  @override
  String get passkeyIntroDescription =>
      'Passkeys are easy to set up and let you securely sign in to your Kumele Account using the  security capabilities of your devices like Touch ID and Face ID.  Passkeys are way more secure and are easier to use than all current 2-factor authentication methods.';

  @override
  String get passkeyTitle => 'Passkey';

  @override
  String get signInUsingPasskeyLabel => 'Sign in using passkey';

  @override
  String get signupPasskeyEmailHint => 'Enter your e-mail';

  @override
  String get eventStartInLabel => 'Start in';

  @override
  String get cancelEventTitle => 'Cancel event';

  @override
  String get setTimeTitle => 'Set Time';

  @override
  String get guestPricesTitle => 'Guest Prices';

  @override
  String get guestPricesUnavailableMessage =>
      'Guest prices are unavailable right now.';

  @override
  String get rewardRingsTitle => 'Reward Rings';

  @override
  String get moneyEarnedTitle => 'Money Earned';

  @override
  String get tryAgainLabel => 'Try Again';

  @override
  String get locationServicesOffTitle => 'Location Services Off';

  @override
  String get locationAccessRequiredTitle => 'Location Access Required';

  @override
  String get locationServicesOffMessage =>
      'Please enable location services on your device to discover events near you.';

  @override
  String get locationPermissionPermanentlyDeniedMessage =>
      'Location permission was permanently denied. Please enable it in app settings.';

  @override
  String get locationAccessNeededMessage =>
      'Location access is needed to show events near you.';

  @override
  String get joinEventConfirmTitle => 'Join this event?';

  @override
  String get joinLabel => 'Join';

  @override
  String get kumeleTermsOfUseLabel => 'Kumele Terms of use';

  @override
  String get eventCancelledDialogTitle => 'Event Cancelled';

  @override
  String get eventCancelledDialogMessage =>
      'The host unfortunately cancelled the event. We apologize for the inconvenience. In case of prepayments please contact PayPal immediately for a refund.';

  @override
  String get premiumPurchaseIncludeLabel => 'Premium In-app purchase include:';

  @override
  String get premiumLocationChange => 'Location Change';

  @override
  String get premiumHouseParty => 'House party (Max guest 10)';

  @override
  String get premiumNoAds => 'No Ads';

  @override
  String get premium7DaysAdvertising => '7 days pre event Advertising';

  @override
  String get signupDateOfBirthLabel => 'Date of birth';

  @override
  String get signupGenderLabel => 'Gender';

  @override
  String get signUpButtonLabel => 'Sign up';

  @override
  String myEventJoinedLabel(String date) {
    return 'Joined $date';
  }

  @override
  String get myEventOrganizedByLabel => 'Organized by';

  @override
  String get myEventDateTimeLabel => 'Date & Time';

  @override
  String get myEventLocationLabel => 'Location';

  @override
  String get myEventCapacityAvailabilityLabel => 'Capacity & Availability';

  @override
  String get myEventAboutEventLabel => 'About Event';

  @override
  String get eventRulesTitle => 'Event Rules & Info';

  @override
  String eventRuleAgeLabel(String minAge, String maxAge) {
    return 'Age: $minAge - $maxAge';
  }

  @override
  String get eventRuleNoAgeLimitLabel => 'No limit';

  @override
  String eventRuleGenderLabel(String gender) {
    return 'Gender: $gender';
  }

  @override
  String eventRuleLanguageLabel(String language) {
    return 'Language: $language';
  }

  @override
  String get eventRuleRequiresApprovalLabel => 'Requires Host Approval';

  @override
  String get exploreMatchedEventLabel => 'Matched Event';

  @override
  String get exploreCreatedEventLabel => 'Created Event';

  @override
  String get exploreJoinNowLabel => 'Join Now';

  @override
  String get exploreSwipeNoMoreMatchesLine1 => 'No more matches currently,';

  @override
  String get exploreSwipeNoMoreMatchesLine2 => 'until then';

  @override
  String get exploreSwipeCreateEventCta => 'Be awesome and create an event';

  @override
  String get exploreSwipeBlogsSuggestion => 'Here are some blogs you may like';

  @override
  String get exploreSwipeInviteFriendsCta =>
      'Be awesome and invite your friends';

  @override
  String get exploreNotificationsTitle => 'Notifications';

  @override
  String get exploreTabletHeaderTitle => 'Explore';

  @override
  String get createEventTitle => 'Create event';

  @override
  String get previewEventLabel => 'Preview Event';

  @override
  String get createEventAgeRangeLabel => 'Age range';

  @override
  String get createEventNumberOfGuestsLabel => 'Number of guests';

  @override
  String get createEventRsvpGuestPaymentLabel => 'RSVP Guest Payment';

  @override
  String get createEventFreeEventLabel => 'Free Event';

  @override
  String get createEventCardPaymentLabel => 'Card Payment';

  @override
  String get createEventCashOnEntryLabel => 'Cash On Entry';

  @override
  String get reportEventTitle => 'Report Event';

  @override
  String get reportEventChooseReasonLabel => 'Choose a reason';

  @override
  String get ratingsTitle => 'Ratings';

  @override
  String get rateEventTitle => 'Rate Event';

  @override
  String get attendeeRatingsLabel => 'Attendee Ratings (70%)';

  @override
  String get blogNoCommentsMessage =>
      'No comments yet. Be the first to comment!';

  @override
  String get nftPreviewTitle => 'NFT Preview';

  @override
  String get nftClosePreviewLabel => 'Close Preview';

  @override
  String get walletSignatureRequiredTitle => 'Wallet Signature Required';

  @override
  String get dismissLabel => 'Dismiss';

  @override
  String get soundNotificationTurnOnLabel => 'Turn on Sound notification';

  @override
  String get soundNotificationLabel => 'Sound notification';

  @override
  String get turnOn2faLabel => 'Turn on 2 factor authentications';

  @override
  String get chooseInterestsTitle => 'Choose interests';

  @override
  String chooseUpToInterestsLabel(String count) {
    return 'Choose up to $count interests:';
  }

  @override
  String get earnMedalsAndRewardsTitle => 'Earn medals and rewards';

  @override
  String otherEventsFromHostLabel(String hostName) {
    return 'Other events from $hostName';
  }

  @override
  String get hobbyMeetupTagline => 'Hobby Meetup';

  @override
  String get splashTagline => 'We play. We overcome. We unite. We live.';

  @override
  String get skipLabel => 'Skip';

  @override
  String get guestTileGroupMeditationLabel => 'Group Meditation';

  @override
  String get guestTileHostedByLabel => 'Hosted By Anki Maheshwari';

  @override
  String get guestTileLocationLabel => 'Bahawalpur, Punjab PK';

  @override
  String get filterMockLocationLabel => 'United Kingdom, 39495, kentucky';

  @override
  String get historyTitle => 'History';

  @override
  String get historyStatisticsTitle => 'History & Statistics';

  @override
  String get blogDetailsTitle => 'Blog Details';

  @override
  String get addCardTitle => 'Add card';

  @override
  String get addCardStripeMessage =>
      'Card details are collected securely by Stripe.';

  @override
  String get addCardSubmitLabel => 'Add Card';

  @override
  String get noNotificationsTitle => 'No Notifications';

  @override
  String get noNotificationsDescription =>
      'You have no new notifications right now. Check back later.';
}
