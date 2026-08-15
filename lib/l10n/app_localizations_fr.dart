// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get save => 'Enregistrer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get submit => 'Soumettre';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get done => 'Terminé';

  @override
  String get retry => 'Réessayer';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get selfCheck => 'Auto-vérification';

  @override
  String get success => 'Succès';

  @override
  String get error => 'Erreur';

  @override
  String get loading => 'Chargement...';

  @override
  String get somethingWentWrong =>
      'Un problème est survenu. Veuillez réessayer.';

  @override
  String get comment => 'Commentaire';

  @override
  String get addYourComment => 'Ajoutez votre commentaire...';

  @override
  String get publishComment => 'Publier le commentaire';

  @override
  String get posted => 'Publié !';

  @override
  String get requiredField => 'Ce champ est obligatoire';

  @override
  String get invalidEmail => 'Veuillez entrer une adresse e-mail valide';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get noChats => 'Aucune discussion';

  @override
  String get noChatsDescription =>
      'Vous n\'avez aucune discussion pour le moment. Commencez une conversation ou revenez plus tard.';

  @override
  String get noGuests => 'Aucun invité';

  @override
  String get noGuestsDescription =>
      'Il n\'y a pas encore d\'invités enregistrés ou présents pour cet événement.';

  @override
  String get chat => 'Discussion';

  @override
  String get spirituality => 'Spiritualité';

  @override
  String get hostedBy => 'Organisé par';

  @override
  String get rateEvent => 'Évaluer l\'événement';

  @override
  String get reportEvent => 'Signaler l\'événement';

  @override
  String get guestScan => 'Scan des invités';

  @override
  String get scanQrCode => 'Scanner le code QR';

  @override
  String get alignQrInFrame => 'Alignez le code QR de l\'invité dans le cadre';

  @override
  String get guestNotFound => 'Invité introuvable dans cet événement';

  @override
  String get invalidQrCode => 'Code QR invalide';

  @override
  String get confirmCheckIn => 'Confirmer l\'arrivée';

  @override
  String get confirmGuestCheckInDescription =>
      'Enregistrer l\'arrivée de cet invité pour l\'événement ?';

  @override
  String checkedInSuccess(String name) {
    return 'Arrivée de $name enregistrée avec succès !';
  }

  @override
  String get checkedInLabel => 'Arrivé(e)';

  @override
  String get notCheckedInLabel => 'Non arrivé(e)';

  @override
  String get confirmedLabel => 'Confirmé';

  @override
  String get followHost => 'Suivre l\'hôte';

  @override
  String daysLeftToRate(int days) {
    return '-- jours restants pour évaluer &\nlaisser un avis';
  }

  @override
  String scannedList(int count) {
    return 'Liste scannée : --';
  }

  @override
  String get chatToday => 'Today';

  @override
  String get chatYesterday => 'Yesterday';

  @override
  String get eventCanceled => 'Événement annulé';

  @override
  String get noMessages => 'Aucun message';

  @override
  String get noMessagesDescription => 'Il n\'y a pas encore de messages ici.';

  @override
  String get joinChatFailed => 'Échec de la connexion à la salle de discussion';

  @override
  String get joinChatSuccess => 'Connexion à la salle de discussion réussie';

  @override
  String get loadMessagesFailed =>
      'Échec du chargement des messages de discussion';

  @override
  String get sendMessageFailed => 'Échec de l\'envoi du message';

  @override
  String get chatNotAvailable => 'La discussion n\'est pas disponible';

  @override
  String get chatAccessDenied => 'Vous n\'avez pas accès à cette discussion';

  @override
  String get chatClosed => 'Cette discussion est fermée';

  @override
  String get typeAMessage => 'Tapez un message';

  @override
  String get reply => 'Répondre';

  @override
  String get unknownUser => 'Inconnu';

  @override
  String get activeEvent => 'Événement actif';

  @override
  String get active => 'Actif';

  @override
  String get eventChat => 'Discussion de l\'événement';

  @override
  String get guests => 'Invités';

  @override
  String get guest => 'Invité';

  @override
  String get priceLabel => 'Prix';

  @override
  String get eventAddressLabel => 'Adresse de l\'événement';

  @override
  String get cashOnEntry => 'Paiement à l\'entrée';

  @override
  String get free => 'Gratuit';

  @override
  String get profileTitle => 'Profil';

  @override
  String get myEvents => 'Mes événements';

  @override
  String get createdEvents => 'Événements créés';

  @override
  String get joinedEvents => 'Événements rejoints';

  @override
  String get noEventsCreatedYet =>
      'Vous n\'avez pas encore créé d\'événements.';

  @override
  String get noEventsJoinedYet =>
      'Vous n\'avez pas encore rejoint d\'événements.';

  @override
  String get blogsTitle => 'Blogs';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get interestedHobbies => 'Centres d\'intérêt';

  @override
  String get editHobbies => 'Modifier les loisirs';

  @override
  String get showMore => 'Voir plus';

  @override
  String get showLess => 'Voir moins';

  @override
  String get myQrCode => 'Mon code QR';

  @override
  String get following => 'Abonnements';

  @override
  String get followers => 'Abonnés';

  @override
  String get goldStatus => 'Statut Or';

  @override
  String get notifications => 'Notifications';

  @override
  String get languages => 'Langues';

  @override
  String get languagesLoadFailed => 'Échec du chargement des langues.';

  @override
  String get connectionsLoadFailed =>
      'Échec du chargement des abonnés et abonnements.';

  @override
  String get cardPaymentsSubscriptions =>
      'Paiements par carte, abonnements & Escrow';

  @override
  String get security => 'Sécurité';

  @override
  String get contact => 'Contact';

  @override
  String get faq => 'FAQ';

  @override
  String get contactPageSubtitle =>
      'Dites-nous comment nous pouvons vous aider.';

  @override
  String get contactSubjectLabel => 'Sujet';

  @override
  String get contactSubjectHint => 'Bref résumé de votre problème';

  @override
  String get contactDescriptionLabel => 'Description';

  @override
  String get contactDescriptionHint => 'Décrivez votre problème en détail';

  @override
  String get contactCategoryLabel => 'Catégorie';

  @override
  String get contactPriorityLabel => 'Priorité';

  @override
  String get contactAttachmentLabel => 'Pièce jointe (facultatif)';

  @override
  String get contactAttachmentHint => 'Télécharger une capture d\'écran';

  @override
  String get contactSubmitLabel => 'Soumettre';

  @override
  String get contactSuccessMessage => 'Votre message a été envoyé.';

  @override
  String get contactSubmitFailed =>
      'Échec de l\'envoi du message. Veuillez réessayer.';

  @override
  String get contactDescriptionTooShort =>
      'Veuillez entrer au moins 20 caractères pour que le support puisse vous aider correctement.';

  @override
  String get contactSubjectRequired => 'Veuillez entrer un sujet.';

  @override
  String get contactDescriptionRequired => 'Veuillez entrer une description.';

  @override
  String get contactAttachmentPickFailed =>
      'Échec de la sélection de l\'image.';

  @override
  String get guidelines => 'Directives';

  @override
  String get referAFriend => 'Parrainer un ami';

  @override
  String get referralCodeUnavailable =>
      'Votre code de parrainage n\'est pas disponible pour le moment. Veuillez réessayer plus tard.';

  @override
  String get referralShareSubject => 'Rejoignez-moi sur Kumele';

  @override
  String referralShareMessage(String referralCode, String referralLink) {
    return 'Rejoignez-moi sur Kumele — rencontrez des amis locaux grâce à des intérêts communs !\n\nUtilisez mon code de parrainage : $referralCode\n\nInscrivez-vous ici : $referralLink';
  }

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get nightMode => 'Mode nuit';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get deleteAccountConfirmTitle =>
      'Êtes-vous sûr ? Cette action est\n irréversible. Veuillez retaper\n votre mot de passe.';

  @override
  String get deleteAccountPasswordHint => 'Entrer le mot de passe actuel';

  @override
  String get deleteAccountPageSubtitle =>
      'Cette action est définitive. Entrez votre mot de passe et dites-nous pourquoi vous partez.';

  @override
  String get deleteAccountPasswordLabel => 'Mot de passe';

  @override
  String get deleteAccountReasonLabel => 'Raison';

  @override
  String get deleteAccountReasonHint => 'Dites-nous pourquoi vous partez';

  @override
  String get deleteAccountConfirmationLabel =>
      'Je comprends que cette action est définitive et ne peut être annulée';

  @override
  String get deleteAccountSubmitLabel => 'Supprimer le compte';

  @override
  String get deleteAccountSuccessMessage => 'Compte supprimé avec succès.';

  @override
  String get deleteAccountSubmitFailed =>
      'Échec de la suppression du compte. Veuillez réessayer.';

  @override
  String get deleteAccountPasswordRequired =>
      'Veuillez entrer votre mot de passe.';

  @override
  String get deleteAccountReasonRequired =>
      'Veuillez nous dire pourquoi vous partez.';

  @override
  String get deleteAccountConfirmationRequired =>
      'Veuillez confirmer que vous comprenez que cette action est définitive.';

  @override
  String get signOutConfirmTitle =>
      'Êtes-vous sûr de vouloir\n vous déconnecter ?';

  @override
  String get signOutSuccessMessage => 'Déconnecté avec succès.';

  @override
  String get forgotPasswordPageTitle => 'Mot de passe oublié';

  @override
  String get forgotPasswordSubtitle =>
      'Entrez votre adresse e-mail et nous vous enverrons un lien de réinitialisation.';

  @override
  String get forgotPasswordEmailLabel => 'E-mail';

  @override
  String get forgotPasswordHint => 'Entrer l\'e-mail';

  @override
  String get forgotPasswordSubmitLabel =>
      'Envoyer l\'e-mail de réinitialisation';

  @override
  String get forgotPasswordSuccessMessage =>
      'Si cet e-mail existe, un lien de réinitialisation a été envoyé.';

  @override
  String get resetPasswordPageTitle => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordSubtitle =>
      'Entrez le code envoyé à votre e-mail et choisissez un nouveau mot de passe.';

  @override
  String get resetPasswordTokenLabel => 'Code de vérification';

  @override
  String get resetPasswordTokenHint => 'Entrer le code';

  @override
  String get resetPasswordNewPasswordLabel => 'Nouveau mot de passe';

  @override
  String get resetPasswordNewPasswordHint => 'Entrer le nouveau mot de passe';

  @override
  String get resetPasswordConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get resetPasswordConfirmPasswordHint =>
      'Réentrer le nouveau mot de passe';

  @override
  String get resetPasswordSubmitLabel => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordSuccessMessage =>
      'Mot de passe réinitialisé avec succès';

  @override
  String get passwordMinLengthError =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get passwordsDoNotMatchError =>
      'Les mots de passe ne correspondent pas';

  @override
  String get emailVerificationPageTitle => 'Vérifiez votre e-mail';

  @override
  String get emailVerificationSubtitle =>
      'Nous avons envoyé un code de vérification à 6 chiffres à votre e-mail. Entrez-le ci-dessous pour continuer.';

  @override
  String get emailVerificationVerifyLabel => 'Vérifier l\'e-mail';

  @override
  String get emailVerificationResendLabel => 'Renvoyer le code';

  @override
  String get emailVerificationResendInLabel => 'Renvoyer le code dans';

  @override
  String get emailVerificationSentMessage =>
      'Code de vérification envoyé à votre e-mail.';

  @override
  String get emailVerificationFailedMessage =>
      'Code de vérification invalide. Veuillez réessayer.';

  @override
  String get emailVerificationSendFailedMessage =>
      'Échec de l\'envoi du code de vérification. Veuillez réessayer.';

  @override
  String get emailVerificationSuccessMessage => 'E-mail vérifié avec succès !';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get changePasswordCurrentLabel => 'Mot de passe actuel';

  @override
  String get changePasswordCurrentHint => 'Entrer le mot de passe actuel';

  @override
  String get changePasswordNewLabel => 'Nouveau mot de passe';

  @override
  String get changePasswordNewHint => 'Entrer le nouveau mot de passe';

  @override
  String get changePasswordConfirmLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get changePasswordConfirmHint => 'Réentrer le nouveau mot de passe';

  @override
  String get changePasswordSubmitLabel => 'Mettre à jour le mot de passe';

  @override
  String get changePasswordSuccessMessage =>
      'Mot de passe mis à jour avec succès. Veuillez vous connecter avec votre nouveau mot de passe.';

  @override
  String get changePasswordSubmitFailed =>
      'Échec de la mise à jour du mot de passe. Veuillez réessayer.';

  @override
  String get changePasswordCurrentRequired =>
      'Veuillez entrer votre mot de passe actuel.';

  @override
  String get registerPasskey => 'Enregistrer une clé d\'accès';

  @override
  String get twoFactorAuth => 'Authentification à deux facteurs';

  @override
  String get twoFactorSetupTitle =>
      'Configuration de l\'application d\'authentification';

  @override
  String get twoFactorSetupStep1 =>
      '1. Ouvrez une application d\'authentification sur votre appareil mobile';

  @override
  String get twoFactorSetupStep1Hint =>
      'Si vous n\'en avez pas, téléchargez et installez l\'une des applications recommandées :';

  @override
  String get twoFactorSetupStep2Lead => '2. Scannez ce code-barres avec votre ';

  @override
  String get twoFactorSetupStep2Bold => 'application d\'authentification';

  @override
  String get twoFactorSetupCantScan =>
      'Impossible de scanner ? Utilisez ce code à la place';

  @override
  String get twoFactorSetupStep3Lead =>
      '3. Entrez le code à six chiffres de l\'';

  @override
  String get twoFactorSetupStep3Bold => 'application d\'authentification';

  @override
  String get twoFactorVerificationHint => 'Entrez le code de vérification ici';

  @override
  String get twoFactorSetupLoadFailed =>
      'Échec du chargement de la configuration 2FA. Veuillez réessayer.';

  @override
  String get twoFactorEnableFailed =>
      'Échec de l\'activation de la 2FA. Veuillez vérifier votre code et réessayer.';

  @override
  String get twoFactorEnableSuccess =>
      'Authentification à deux facteurs activée avec succès.';

  @override
  String get twoFactorManualCodeCopied =>
      'Code de configuration copié dans le presse-papiers';

  @override
  String get setup => 'Configuration';

  @override
  String get twoFactorDisableTitle =>
      'Désactiver l\'authentification à deux facteurs';

  @override
  String get twoFactorDisableSubtitle =>
      'Êtes-vous sûr de vouloir désactiver l\'authentification à deux facteurs ?';

  @override
  String get twoFactorDisableDescription =>
      'Votre compte ne sera protégé que par votre mot de passe. Nous recommandons de garder la 2FA activée pour une meilleure sécurité.';

  @override
  String get twoFactorDisableConfirm => 'Désactiver la 2FA';

  @override
  String get twoFactorDisableCodeLead =>
      'Entrez le code à six chiffres de votre ';

  @override
  String get twoFactorDisableSuccess =>
      'Authentification à deux facteurs désactivée avec succès.';

  @override
  String get twoFactorDisableFailed =>
      'Échec de la désactivation de la 2FA. Veuillez vérifier votre code et réessayer.';

  @override
  String get twoFactorLoginTitle => 'Authentification à deux facteurs';

  @override
  String get twoFactorLoginSubtitle =>
      'Entrez le code de votre application d\'authentification pour continuer';

  @override
  String get twoFactorLoginDescription =>
      'Votre compte est protégé par une authentification à deux facteurs.';

  @override
  String get twoFactorLoginCodeLead =>
      'Entrez le code à six chiffres de votre ';

  @override
  String get twoFactorLoginCodeBold => 'application d\'authentification';

  @override
  String get twoFactorLoginVerify => 'Vérifier';

  @override
  String get twoFactorLoginFailed =>
      'Code de vérification invalide. Veuillez réessayer.';

  @override
  String get passkeyRegisterSuccess => 'Clé d\'accès enregistrée avec succès';

  @override
  String get onboardingPageTitle => 'Configurez votre profil';

  @override
  String get onboardingPageSubtitle =>
      'Ajoutez une photo et parlez de vous à la communauté.';

  @override
  String get onboardingAvatarHint => 'Appuyez pour ajouter une photo';

  @override
  String get onboardingImagePickerTitle => 'Ajouter une photo de profil';

  @override
  String get onboardingImagePickerSubtitle =>
      'Choisissez la galerie ou l\'appareil photo pour votre photo de profil';

  @override
  String get gallery => 'Galerie';

  @override
  String get camera => 'Appareil photo';

  @override
  String get onboardingUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get onboardingUsernameHint =>
      'Choisissez un nom d\'utilisateur (facultatif)';

  @override
  String get onboardingUsernameHelper =>
      'Les noms d\'utilisateur ne peuvent être modifiés que tous les 3 mois';

  @override
  String get onboardingUsernameChecking =>
      'Vérification du nom d\'utilisateur...';

  @override
  String get onboardingUsernameAvailable =>
      'Le nom d\'utilisateur est disponible';

  @override
  String get onboardingUsernameTaken => 'Le nom d\'utilisateur est déjà pris';

  @override
  String get onboardingPhoneLabel => 'Numéro de téléphone';

  @override
  String get onboardingPhoneHint =>
      'Entrez votre numéro de téléphone (facultatif)';

  @override
  String get onboardingAboutLabel => 'À propos de moi';

  @override
  String get onboardingAboutHint =>
      'Parlez-nous de vos intérêts, loisirs et ce que vous aimez faire';

  @override
  String get onboardingSuccessMessage => 'Profil enregistré avec succès.';

  @override
  String get onboardingImageRequired => 'Veuillez ajouter une photo de profil.';

  @override
  String get onboardingPhoneRequired =>
      'Veuillez entrer votre numéro de téléphone.';

  @override
  String get onboardingPhoneInvalid =>
      'Veuillez entrer un numéro de téléphone valide.';

  @override
  String get onboardingAboutTooShort =>
      'La section \'À propos de moi\' doit comporter au moins 200 caractères.';

  @override
  String get onboardingAboutTooLong =>
      'La section \'À propos de moi\' ne peut pas dépasser 500 caractères.';

  @override
  String get onboardingImagePlatformUnsupported =>
      'Le téléchargement d\'images n\'est disponible que sur Android.';

  @override
  String get onboardingImagePickFailed => 'Échec de la sélection de l\'image.';

  @override
  String get onboardingSubmitFailed =>
      'Échec de l\'enregistrement du profil. Veuillez réessayer.';

  @override
  String get editProfileTitle => 'Modifier le profil';

  @override
  String get editProfileFirstNameLabel => 'Prénom';

  @override
  String get editProfileFirstNameHint => 'Entrez votre prénom';

  @override
  String get editProfileLastNameLabel => 'Nom';

  @override
  String get editProfileLastNameHint => 'Entrez votre nom';

  @override
  String get editProfileAboutLabel => 'À propos de moi';

  @override
  String get editProfileAboutHint =>
      'Parlez-nous de vos intérêts, loisirs et ce que vous aimez faire';

  @override
  String get editProfilePhoneLabel => 'Numéro de téléphone';

  @override
  String get editProfilePhoneHint => 'Entrez votre numéro de téléphone';

  @override
  String get editProfileUpdateLabel => 'Mettre à jour';

  @override
  String get editProfileSuccessMessage => 'Profil mis à jour avec succès.';

  @override
  String get editProfileSubmitFailed =>
      'Échec de la mise à jour du profil. Veuillez réessayer.';

  @override
  String get editProfileFirstNameRequired => 'Veuillez entrer votre prénom.';

  @override
  String get editProfileAboutTooLong =>
      'La section \'À propos de moi\' ne peut pas dépasser 500 caractères.';

  @override
  String get editProfilePhoneInvalid =>
      'Veuillez entrer un numéro de téléphone valide.';

  @override
  String get editProfileUserMissing =>
      'Impossible de mettre à jour le profil. Utilisateur introuvable.';

  @override
  String get pickEventLocation => 'Choisir le lieu de l\'événement';

  @override
  String get selectedLocation => 'Lieu sélectionné';

  @override
  String get fetchingAddress => 'Récupération de l\'adresse...';

  @override
  String get moveMapToPickLocation => 'Déplacez la carte pour choisir un lieu';

  @override
  String get confirmLocation => 'Confirmer le lieu';

  @override
  String get searching => 'Recherche...';

  @override
  String get unknownLocation => 'Lieu inconnu';

  @override
  String get couldNotFetchAddress => 'Impossible de récupérer l\'adresse';

  @override
  String get locationServicesDisabled =>
      'Les services de localisation sont désactivés.';

  @override
  String get locationPermissionDenied => 'Permission de localisation refusée.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Permission de localisation refusée de façon permanente.';

  @override
  String get pickEventLocationPlaceholder => 'Choisir le lieu de l\'événement';

  @override
  String get tapToOpenMapPlaceholder =>
      'Appuyez pour ouvrir la carte et déposer un repère';

  @override
  String get limitedInvites => 'Invitations limitées';

  @override
  String get howItWorks => 'Comment ça marche :';

  @override
  String get login => 'Connexion';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get inviteFriendsAndFamily => 'Invitez vos amis et votre famille';

  @override
  String get eventCodeCopied =>
      'Code de l\'événement copié dans le presse-papiers !';

  @override
  String get copyTo => 'Copier dans le';

  @override
  String get clipboard => 'presse-papiers';

  @override
  String get eventIdLabel => 'ID de l\'événement : ';

  @override
  String get locationLabel => 'Lieu : ';

  @override
  String get scanQr => 'Scanner QR';

  @override
  String get hostQr => 'QR de l\'hôte';

  @override
  String get demoHostName => 'Ankit Maheswari';

  @override
  String get demoLocation => 'Bahawalpur, Pendjab Pakistan';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInEmailHint => 'Entrez l\'e-mail | Pseudo';

  @override
  String get signInPasswordHint => 'Entrez le mot de passe';

  @override
  String get signInRememberMeLabel => 'Se souvenir de moi';

  @override
  String get signInForgotPasswordLabel => 'Mot de passe oublié ?';

  @override
  String get signInCaptchaLabel => 'Je ne suis pas un robot';

  @override
  String get signInNotAMemberPrefix => 'Pas encore membre ? ';

  @override
  String get signInNoAccountPrefix => 'Vous n\'avez pas de compte ? ';

  @override
  String get signInPasskeyDividerLabel =>
      'Ou se connecter avec une clé d\'accès';

  @override
  String get signInPasskeyDescription =>
      'Nous recommandons la clé d\'accès à tous les utilisateurs, si votre appareil la prend en charge, pour une meilleure sécurité et une expérience utilisateur agréable.';

  @override
  String get signInLanguageChoiceLabel => 'Langue';

  @override
  String get signInFillFieldsError =>
      'Veuillez remplir tous les champs obligatoires';

  @override
  String get signInCaptchaRequiredError =>
      'Veuillez confirmer que vous n\'êtes pas un robot';

  @override
  String get signInSuccessMessage => 'Connecté avec succès';

  @override
  String get signInWithGoogleLabel => 'Se connecter avec Google';

  @override
  String get alreadyHaveAccount => 'Vous avez déjà un compte ? ';

  @override
  String get signupFirstNameLabel => 'Prénom';

  @override
  String get signupFirstNameHint => 'Entrez le prénom';

  @override
  String get signupLastNameLabel => 'Nom';

  @override
  String get signupLastNameHint => 'Entrez le nom';

  @override
  String get signupEmailHint => 'Entrez l\'e-mail';

  @override
  String get signupPasswordHint => 'Entrez le mot de passe';

  @override
  String get signupConfirmPasswordHint => 'Confirmez le mot de passe';

  @override
  String get signupReferralCodeLabel => 'Code de parrainage';

  @override
  String get signupBetaCodeLabel => 'Code bêta';

  @override
  String get signupCodeHint => ' ex. DF4R435';

  @override
  String get passkeySignInTitle =>
      'Connectez-vous avec votre clé d\'accès Kumele';

  @override
  String get earnMedals => 'Gagnez des médailles';

  @override
  String get bronzeStatus => 'Statut Bronze';

  @override
  String get silverStatus => 'Statut Argent';

  @override
  String get goldStatusMedal => 'Statut Or';

  @override
  String get bronzeStatusDescription =>
      'L\'utilisateur a créé un minimum de 2 événements ou a assisté à un minimum de 2 événements sans faute au cours\ndes 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 2 % sur un achat intégré au choix.';

  @override
  String get silverStatusDescription =>
      'L\'utilisateur a créé un minimum de 3 événements ou a assisté à un minimum de 3 événements sans faute au cours\ndes 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 4 % sur un achat intégré au choix.';

  @override
  String get goldStatusMedalDescription =>
      'L\'utilisateur a créé un minimum de 4 événements ou a assisté à un minimum de 4 événements sans faute au cours\ndes 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 8 % sur un achat intégré au choix.';

  @override
  String get filterTitle => 'Filtrer';

  @override
  String get currentLocation => 'Emplacement actuel';

  @override
  String get change => 'Changer';

  @override
  String get distanceRangeLabel => 'Plage de distance (en kilomètres)';

  @override
  String get ageRangeLabel => 'Tranche d\'âge';

  @override
  String get paidEvent => 'Événement payant';

  @override
  String get stateHint => 'État/Région';

  @override
  String get postalZipCodeHint => 'Code postal';

  @override
  String get countryHint => 'Pays';

  @override
  String get openPhantomWallet => 'Ouvrir Phantom Wallet';

  @override
  String get nftDescriptionLabel => 'Description';

  @override
  String get nftDetailsLabel => 'Détails du NFT';

  @override
  String get guestCountValidForEventOnly =>
      'Nombre d\'invités valable uniquement pour cet événement';

  @override
  String get tokenIdLabel => 'ID du Token';

  @override
  String get tokenStandardLabel => 'Standard du Token';

  @override
  String get blockchainLabel => 'Blockchain';

  @override
  String get creatorLabel => 'Créateur';

  @override
  String get addCommentsHint => 'Ajouter des commentaires';

  @override
  String get reportEventPageTitle => 'Signaler l\'événement';

  @override
  String get ratingPageTitle => 'Évaluation';

  @override
  String get send => 'Envoyer';

  @override
  String get blogLikePostSemanticLabel => 'Aimer l\'article';

  @override
  String get blogLikesLabel => 'J\'aime';

  @override
  String get blogShareLabel => 'Partager';

  @override
  String get replyDialogTitlePrefix => 'Répondre à';

  @override
  String get replyDialogHint => 'Écrivez votre réponse...';

  @override
  String get blogEmptyStateTitle => 'Aucun blog trouvé';

  @override
  String get blogEmptyStateDescription =>
      'Essayez un autre filtre de catégorie.';

  @override
  String get blogCategoryAll => 'Tout';

  @override
  String get blogCategoryFood => 'Nourriture';

  @override
  String get blogCategoryTravel => 'Voyage';

  @override
  String get blogCategorySports => 'Sports';

  @override
  String get blogCategoryMusic => 'Musique';

  @override
  String get blogPlaceholderTitle =>
      'Titre de remplacement pour l\'effet de chargement de l\'article de blog';

  @override
  String get blogPlaceholderExcerpt =>
      'Extrait de remplacement pour le chargement du squelette.';

  @override
  String get blogPlaceholderAuthorName => 'Chargement de l\'auteur';

  @override
  String get blogPlaceholderCategoryName => 'Catégorie';

  @override
  String get blogPostShareSampleTitle =>
      'Singleton de Glen Ord 38 ans et la gamme Singleton.';

  @override
  String get blogPostShareCategoryLabel => 'Spiritualité';

  @override
  String get blogPostShareAuthorLabel => ' Auteur :';

  @override
  String get blogPostSharePublishDateLabel => ' Date de publication :';

  @override
  String get blogPostShareHowItWorksTitle => 'Comment ça marche';

  @override
  String get blogPostShareStep1 => '1. Consultez l\'URL pour ouvrir le blog';

  @override
  String get blogPostShareStep2 =>
      '2. Ou recherchez le blog une fois connecté pour l\'aimer';

  @override
  String get blogPostShareInviteTitle => 'Invitez vos amis \n et votre famille';

  @override
  String get blogPostCommentsTitle => 'Commentaires';

  @override
  String get blogPostPreviousLabel => 'Précédent';

  @override
  String get blogRepliesCountLabel => 'Réponses';

  @override
  String get blogReplyPlaceholderText =>
      'Préparez-vous pour une soirée remplie de rires';

  @override
  String get blogSearchHint => 'Rechercher';

  @override
  String get createEventNameLabel => 'Nom de l\'événement';

  @override
  String get createEventTitleHint => 'Ajouter un titre';

  @override
  String get createEventSubtitleLabel => 'Sous-titre';

  @override
  String get createEventSubtitleHint => 'Ajouter un sous-titre';

  @override
  String get createEventDescriptionMaxLabel => 'Max';

  @override
  String get createEventDescriptionLabel => 'Description';

  @override
  String get createEventDescriptionHint =>
      'Plus d\'informations sur l\'événement';

  @override
  String get createEventDateLabel => 'Date';

  @override
  String get createEventStartTimeLabel => 'Heure de début de l\'événement';

  @override
  String get createEventStartTimePlaceholder => 'Heure de début';

  @override
  String get createEventEndTimeLabel => 'Heure de fin de l\'événement';

  @override
  String get createEventEndTimePlaceholder => 'Heure de fin';

  @override
  String get createEventCheckAvailabilityLabel =>
      'Vérifier la disponibilité de l\'utilisateur';

  @override
  String get createEventAvailabilityDisclaimer =>
      'Pour utiliser cette fonctionnalité, veuillez ajouter votre adresse et le nombre d\'invités. Avertissement : nous ne pouvons pas garantir des correspondances à 100% en raison de certains facteurs indépendants de notre volonté.';

  @override
  String get createEventStartsInLabel => 'L\'événement commence dans';

  @override
  String get createEventDecreaseTimeSemanticLabel => 'Diminuer le temps';

  @override
  String get createEventIncreaseTimeSemanticLabel => 'Augmenter le temps';

  @override
  String get createEventStreetLabel => 'Rue';

  @override
  String get createEventStreetHint => 'Saisir la rue';

  @override
  String get createEventHomeNumberLabel => 'Numéro de maison';

  @override
  String get createEventHomeNumberHint => 'Saisir le numéro de maison';

  @override
  String get createEventDistrictLabel => 'Quartier';

  @override
  String get createEventDistrictHint => 'Saisir le quartier';

  @override
  String get createEventPostalCodeLabel => 'Code postal';

  @override
  String get createEventPostalCodeHint => 'Saisir le code postal';

  @override
  String get createEventStateLabel => 'État';

  @override
  String get createEventStateHint => 'Saisir l\'état';

  @override
  String get createEventUploadImageTitle => 'Télécharger une image';

  @override
  String get createEventUploadImageSubtitle =>
      'Choisissez une source pour l\'image de votre événement';

  @override
  String get createEventCategoryPlaceholder => 'Catégorie';

  @override
  String get createEventCategoryLabel => 'Catégorie de l\'événement';

  @override
  String get createEventImageLabel => 'Image de l\'événement';

  @override
  String get createEventImageSizeHint => '(Taille recommandée 400 x 400px)';

  @override
  String get createEventStripeConnectedLabel => 'Stripe connecté';

  @override
  String get createEventPreviewSubmitLabel => 'Créer l\'événement';

  @override
  String get createEventPreviewGuestsSuffix => 'invités';

  @override
  String get createEventPreviewAlreadyStarted => 'L\'événement a déjà commencé';

  @override
  String createEventPreviewStartsInDays(Object days) {
    return 'Commence dans $days jours';
  }

  @override
  String get createEventPreviewStartsTomorrow => 'Commence demain';

  @override
  String createEventPreviewStartsInHour(Object hours) {
    return 'Commence dans $hours heure';
  }

  @override
  String createEventPreviewStartsInHours(Object hours) {
    return 'Commence dans $hours heures';
  }

  @override
  String createEventPreviewStartsInMinute(Object minutes) {
    return 'Commence dans $minutes minute';
  }

  @override
  String createEventPreviewStartsInMinutes(Object minutes) {
    return 'Commence dans $minutes minutes';
  }

  @override
  String get createEventPreviewStartingNow => 'Commence maintenant';

  @override
  String get createEventPreviewDefaultCategory => 'Spiritualité';

  @override
  String get createEventPreviewDefaultHostName => 'Moi';

  @override
  String createEventPreviewExpectedLabel(Object label) {
    return 'Attendu $label';
  }

  @override
  String createEventPreviewPricingLabel(Object label) {
    return 'Prix $label';
  }

  @override
  String get discoverNoMatchesMessage =>
      'Aucune autre correspondance pour le moment, d\'ici là';

  @override
  String get discoverGuestsSuffix => 'invités';

  @override
  String get discoverGoToChatLabel => 'Aller au chat';

  @override
  String get discoverLocationLabel => 'Lieu :';

  @override
  String get discoverStartsInLabel => 'Commence dans';

  @override
  String get discoverHoursSuffix => 'h';

  @override
  String get discoverShareLabel => 'Partager';

  @override
  String get discoverHostLabel => 'Hôte';

  @override
  String get discoverHostMedalGoldLabel => 'Or';

  @override
  String get discoverFollowersSuffix => ' abonnés';

  @override
  String get discoverOverallRatingsSuffix => 'Évaluations globales';

  @override
  String get exploreSwipeCardToday => 'Aujourd\'hui';

  @override
  String get exploreSearchHint => 'Rechercher des événements de loisirs';

  @override
  String get exploreSwipeCardStartInPrefix => 'Commence dans';

  @override
  String get exploreSwipeCardHostLabel => 'Hôte';

  @override
  String get exploreSwipeCardFollowersSuffix => 'abonnés';

  @override
  String get exploreSwipeCardOverallRatingsLabel => 'Évaluations globales';

  @override
  String get exploreCategoryVanLife => 'Vie en van';

  @override
  String get exploreCategoryPetLove => 'Amour des animaux';

  @override
  String get exploreCategorySpirituality => 'Spiritualité';

  @override
  String get exploreCategoryBoardGames => 'Jeux de société';

  @override
  String get exploreDiscountDeclineMessage => 'Refuser';

  @override
  String get openLabel => 'Ouvrir';

  @override
  String get exploreDiscountNoOfferTitle => 'Aucune offre disponible';

  @override
  String get exploreDiscountCheckBackLaterMessage =>
      'Veuillez revenir plus tard.';

  @override
  String get exploreDiscountNoAdDetailsMessage =>
      'Aucun détail d\'annonce fourni.';

  @override
  String get exploreDiscountOfferFallback => 'Offre';

  @override
  String get exploreLoadEventsFailed => 'Échec du chargement des événements.';

  @override
  String get exploreInterestedLabel => 'Intéressé';

  @override
  String get exploreEventDetailLoadFailed =>
      'Échec du chargement des détails de l\'événement.';

  @override
  String get birthdayNotificationTitle => 'Joyeux anniversaire !';

  @override
  String get birthdayNotificationMessage =>
      '« Joyeux anniversaire ! J\'espère que tous tes vœux et rêves d\'anniversaire se réaliseront. »';

  @override
  String get birthdayNotificationSignature => 'Équipe Kumele';

  @override
  String get commentsTitle => 'Commentaires';

  @override
  String get previousLabel => 'Précédent';

  @override
  String get blogCommentRepliesCount => '3 réponses';

  @override
  String get blogCommentReplayAction => 'Répondre';

  @override
  String get welcomeNotificationTitle => 'Bienvenue sur Kumele';

  @override
  String get welcomeNotificationDate => '23 novembre 2022';

  @override
  String get welcomeNotificationBody =>
      'Bienvenue sur Kumele ! Nous sommes ravis de vous accueillir. Découvrez des événements près de chez vous, connectez-vous avec des personnes partageant les mêmes centres d\'intérêt et vivez des moments inoubliables.';

  @override
  String get createEventButtonLabel => 'Créer un événement';

  @override
  String get notificationsEmptyTitle => 'Aucune notification';

  @override
  String get notificationsEmptyDescription =>
      'Vous n\'avez aucune nouvelle notification pour le moment. Revenez plus tard.';

  @override
  String get exploreEmptyNoMoreMatches =>
      'Aucune autre correspondance pour le moment,';

  @override
  String get exploreEmptyUntilThen => 'd\'ici là';

  @override
  String get exploreEmptyCreateEventPromptSubtitle =>
      'Soyez génial et créez un événement';

  @override
  String get exploreEmptyReadBlogPromptSubtitle =>
      'Voici quelques blogs qui pourraient vous plaire';

  @override
  String get exploreEmptyReadBlogButtonLabel => 'Lire le blog';

  @override
  String get exploreEmptyInviteFriendsPromptSubtitle =>
      'Soyez génial et invitez vos amis';

  @override
  String get exploreEmptyInviteFriendsButtonLabel => 'Inviter des amis';

  @override
  String get exploreMatchedEventsSectionTitle => 'Événement correspondant';

  @override
  String get exploreCreatedEventsSectionTitle => 'Événement créé';

  @override
  String get exploreHostFallbackName => 'Moi';

  @override
  String get addPaypalEmailOrMobileHint => 'E-mail ou numéro de mobile';

  @override
  String get orDividerLabel => 'Ou';

  @override
  String get eventAdsLabel => 'Annonces d\'événements';

  @override
  String get paymentThankYouTitle => 'Merci !';

  @override
  String get paymentCompleteMessage => 'Votre paiement est terminé.';

  @override
  String get viewPaymentLabel => 'Voir le paiement';

  @override
  String get statusLabel => 'Statut';

  @override
  String get completedStatusLabel => 'Terminé';

  @override
  String get orderCodeLabel => 'Code de commande';

  @override
  String get dateTimeLabel => 'Date et heure';

  @override
  String get exchangeRateLabel => 'Taux de change';

  @override
  String get totalLabel => 'Total';

  @override
  String get paymentProcessedByLabel => 'Paiement traité par';

  @override
  String get sendPaymentTitle => 'Envoyer le paiement';

  @override
  String get sendPaymentInstructions =>
      'Pour effectuer un paiement, envoyez des BTC à l\'adresse ci-dessous';

  @override
  String get payWithWalletLabel => 'Payer avec le portefeuille';

  @override
  String get amountLabel => 'Montant';

  @override
  String get copyLabel => 'Copier';

  @override
  String get btcAddressLabel => 'Adresse BTC';

  @override
  String get payWithCoinbaseLabel => 'Payer avec Coinbase';

  @override
  String get selectCryptocurrencyLabel => 'Ou sélectionnez une cryptomonnaie';

  @override
  String get showMoreLabel => 'Afficher plus';

  @override
  String get noSubscriptionTierAvailable =>
      'Aucun niveau d\'abonnement disponible pour le moment.';

  @override
  String get signInBeforeSubscription =>
      'Veuillez vous connecter avant de commencer un abonnement.';

  @override
  String get subscriptionActivatedMessage => 'Abonnement activé';

  @override
  String purchaseFailedMessage(Object error) {
    return 'Échec de l\'achat : $error';
  }

  @override
  String get subscriptionCheckoutSessionFailed =>
      'Impossible de créer la session de paiement de l\'abonnement.';

  @override
  String get subscribeLabel => 'S\'abonner';

  @override
  String get paymentCompleteShort => 'Paiement terminé';

  @override
  String get checkoutStartedMessage => 'Paiement commencé';

  @override
  String get subscriptionCreatedMessage => 'Abonnement créé';

  @override
  String get signInToManageSubscription =>
      'Veuillez vous connecter pour gérer un abonnement.';

  @override
  String get unableToCancelSubscription =>
      'Impossible d\'annuler l\'abonnement pour le moment.';

  @override
  String get subscriptionCancellationRequested =>
      'Annulation de l\'abonnement demandée';

  @override
  String get unableToResumeSubscription =>
      'Impossible de reprendre l\'abonnement pour le moment.';

  @override
  String get subscriptionResumedMessage => 'Abonnement repris';

  @override
  String get cryptoPaymentsComingSoon =>
      'Les paiements en cryptomonnaie sont encore en cours d\'intégration au flux de paiement en direct.';

  @override
  String get paymentLabel => 'Paiement';

  @override
  String get amountToPayLabel => 'Montant à payer';

  @override
  String get selectSubscriptionLabel => 'Sélectionnez un abonnement';

  @override
  String get monthlyLabel => 'Mensuel';

  @override
  String get yearlyLabel => 'Annuel';

  @override
  String tierPlanBillingSummary(Object cycle, Object tierName) {
    return 'Formule $tierName • facturation $cycle';
  }

  @override
  String get subscriptionPlansTitle => 'Formules d\'abonnement';

  @override
  String get noSubscriptionTiersAvailable =>
      'Aucune formule d\'abonnement disponible pour le moment.';

  @override
  String get popularBadgeLabel => 'Populaire';

  @override
  String get priceUnavailableLabel => 'Prix indisponible';

  @override
  String get currentSubscriptionTitle => 'Abonnement actuel';

  @override
  String get signInCheckSubscriptionStatus =>
      'Connectez-vous pour vérifier le statut de votre abonnement actif.';

  @override
  String get noActiveSubscriptionFound =>
      'Aucun abonnement actif trouvé pour le moment.';

  @override
  String get planLabel => 'Formule';

  @override
  String get unknownLabel => 'Inconnu';

  @override
  String get renewsEndsLabel => 'Renouvellement / fin';

  @override
  String get cancellationLabel => 'Annulation';

  @override
  String get scheduledForPeriodEndLabel => 'Prévu pour la fin de période';

  @override
  String get resumeSubscriptionLabel => 'Reprendre l\'abonnement';

  @override
  String get cancelAtPeriodEndLabel => 'Annuler à la fin de la période';

  @override
  String get recentPaymentsTitle => 'Paiements récents';

  @override
  String get paymentHistoryAfterSignIn =>
      'L\'historique des paiements devient disponible après la connexion.';

  @override
  String get noPaymentHistoryFound =>
      'Aucun historique de paiement trouvé pour le moment.';

  @override
  String paymentIdFallback(Object id) {
    return 'Paiement $id';
  }

  @override
  String get providerUnknownLabel => 'Fournisseur inconnu';

  @override
  String get refreshDetailsLabel => 'Actualiser les détails';

  @override
  String get cryptoPaymentOptionsLabel =>
      'Options de paiement en cryptomonnaie';

  @override
  String get signInToSubscribeLabel => 'Connectez-vous pour vous abonner';

  @override
  String get continueToCheckoutLabel => 'Continuer vers le paiement';

  @override
  String get enterDiscountCodeHint => 'Saisir le code de réduction';

  @override
  String get addDiscountCodeFirstMessage =>
      'Ajoutez d\'abord un code de réduction.';

  @override
  String get discountCodeValidatedAtCheckoutMessage =>
      'Le code de réduction sera validé au début du paiement.';

  @override
  String get applyLabel => 'Appliquer';

  @override
  String get authBannerSubscriptionMessage =>
      'Vous pouvez consulter les formules d\'abonnement maintenant, mais vous devez vous connecter avant que le paiement, l\'annulation ou l\'historique des paiements ne fonctionnent.';

  @override
  String get actionNotAllowedTitle => 'Action non autorisée';

  @override
  String get removeCardTitle => 'Supprimer la carte';

  @override
  String get connectEscrowAccountLabel => 'Connectez votre compte séquestre';

  @override
  String get subscriptionsTitle => 'Abonnements';

  @override
  String get buyNowLabel => 'Acheter maintenant';

  @override
  String get deactivateLabel => 'Désactiver';

  @override
  String get activateLabel => 'Activer';

  @override
  String get confirmCardDeletionTitle => 'Confirmer la suppression de la carte';

  @override
  String get eventDetailsTitle => 'Détails de l\'événement';

  @override
  String get eventNotFoundTitle => 'Événement introuvable';

  @override
  String get eventNotFoundDescription =>
      'Les détails de l\'événement demandé n\'ont pas pu être trouvés.';

  @override
  String get eventLocationLabel => 'Lieu';

  @override
  String get capacityAvailabilityLabel => 'Capacité et disponibilité';

  @override
  String capacityAvailabilitySummary(
      Object attendeeCount, Object capacity, Object spotsRemaining) {
    return '$attendeeCount / $capacity participants ($spotsRemaining places restantes)';
  }

  @override
  String get turnOnSoundNotificationLabel => 'Activer la notification sonore';

  @override
  String get emailNotificationsLabel => 'Notifications par e-mail';

  @override
  String get medalBronzeTitle => 'Statut Bronze';

  @override
  String get medalBronzeDescription =>
      'L\'utilisateur a créé au minimum 2 événements ou a assisté à au minimum 2 événements sans échec au cours des 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 2% sur 1 achat in-app de son choix.';

  @override
  String get medalSilverTitle => 'Statut Argent';

  @override
  String get medalSilverDescription =>
      'L\'utilisateur a créé au minimum 3 événements ou a assisté à au minimum 3 événements sans échec au cours des 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 4% sur 1 achat in-app de son choix.';

  @override
  String get medalGoldTitle => 'Statut Or';

  @override
  String get medalGoldDescription =>
      'L\'utilisateur a créé au minimum 4 événements ou a assisté à au minimum 4 événements sans échec au cours des 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 8% sur 1 achat in-app de son choix.';

  @override
  String get connectTvLabel => 'Connecter la TV';

  @override
  String get tvConnectedSuccessMessage => 'TV connectée avec succès.';

  @override
  String get couldNotConnectTvMessage => 'Impossible de connecter cette TV.';

  @override
  String get blogCommentAuthorYou => 'Vous';

  @override
  String get blogCommentJustNow => 'À l\'instant';

  @override
  String get discoverGoldBadgeLabel => 'Or';

  @override
  String get paymentDialogTitle => 'Paiement';

  @override
  String get paymentAmountToPayLabel => 'Montant à payer';

  @override
  String get paymentSelectSubscriptionLabel => 'Sélectionnez un abonnement';

  @override
  String get paymentPlanBulletSuffix => 'formule •';

  @override
  String get paymentBillingSuffix => 'facturation';

  @override
  String get paymentYearlyLabel => 'Annuel';

  @override
  String get paymentMonthlyLabel => 'Mensuel';

  @override
  String get paymentDiscountCodeHint => 'Saisir le code de réduction';

  @override
  String get paymentDiscountCodeEmptyMessage =>
      'Ajoutez d\'abord un code de réduction.';

  @override
  String get paymentDiscountCodeValidationMessage =>
      'Le code de réduction sera validé au début du paiement.';

  @override
  String get paymentApplyLabel => 'Appliquer';

  @override
  String get paymentAuthBannerMessage =>
      'Vous pouvez consulter les formules d\'abonnement maintenant, mais vous devez vous connecter avant que le paiement, l\'annulation ou l\'historique des paiements ne fonctionnent.';

  @override
  String get paymentSubscriptionPlansTitle => 'Formules d\'abonnement';

  @override
  String get paymentNoTiersMessage =>
      'Aucune formule d\'abonnement disponible pour le moment.';

  @override
  String get paymentPopularBadgeLabel => 'Populaire';

  @override
  String get paymentPriceUnavailableLabel => 'Prix indisponible';

  @override
  String get paymentCurrentSubscriptionTitle => 'Abonnement actuel';

  @override
  String get paymentSignInToCheckStatusMessage =>
      'Connectez-vous pour vérifier le statut de votre abonnement actif.';

  @override
  String get paymentNoActiveSubscriptionMessage =>
      'Aucun abonnement actif trouvé pour le moment.';

  @override
  String get paymentStatusLabel => 'Statut';

  @override
  String get paymentPlanLabel => 'Formule';

  @override
  String get paymentUnknownPlanLabel => 'Inconnu';

  @override
  String get paymentRenewsEndsLabel => 'Renouvellement / fin';

  @override
  String get paymentCancellationLabel => 'Annulation';

  @override
  String get paymentScheduledForPeriodEndLabel =>
      'Prévu pour la fin de période';

  @override
  String get paymentResumeSubscriptionLabel => 'Reprendre l\'abonnement';

  @override
  String get paymentCancelAtPeriodEndLabel => 'Annuler à la fin de la période';

  @override
  String get paymentRecentPaymentsTitle => 'Paiements récents';

  @override
  String get paymentHistoryAfterSignInMessage =>
      'L\'historique des paiements devient disponible après la connexion.';

  @override
  String get paymentNoHistoryMessage =>
      'Aucun historique de paiement trouvé pour le moment.';

  @override
  String paymentFallbackDescription(String id) {
    return 'Paiement $id';
  }

  @override
  String get paymentProviderUnknownLabel => 'Fournisseur inconnu';

  @override
  String get paymentRefreshDetailsLabel => 'Actualiser les détails';

  @override
  String get paymentCryptoOptionsLabel =>
      'Options de paiement en cryptomonnaie';

  @override
  String get paymentSignInToSubscribeLabel =>
      'Connectez-vous pour vous abonner';

  @override
  String get paymentContinueToCheckoutLabel => 'Continuer vers le paiement';

  @override
  String get interestMovies => 'Films';

  @override
  String get interestPubsAndBars => 'Bars et pubs';

  @override
  String get interestLiveShow => 'Spectacle en direct';

  @override
  String get interestClubbing => 'Boîtes de nuit';

  @override
  String get interestFestival => 'Festival';

  @override
  String get interestOutdoors => 'Plein air';

  @override
  String get interestVolunteer => 'Bénévolat';

  @override
  String get interestDiy => 'Bricolage';

  @override
  String get interestActivism => 'Activisme';

  @override
  String get interestPetLove => 'Amour des animaux';

  @override
  String get interestVideoGames => 'Jeux vidéo';

  @override
  String get interestFamilyActivities => 'Activités familiales';

  @override
  String get interestTech => 'Technologie';

  @override
  String get interestCostume => 'Costume';

  @override
  String get interestFoodie => 'Foodie';

  @override
  String get interestCamping => 'Camping';

  @override
  String get medalBronzeSubtitle =>
      'L\'utilisateur a créé au minimum 2 événements ou a assisté à au minimum 2 événements sans échec au cours des 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 2% sur 1 achat in-app de son choix.';

  @override
  String get medalSilverSubtitle =>
      'L\'utilisateur a créé au minimum 3 événements ou a assisté à au minimum 3 événements sans échec au cours des 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 4% sur 1 achat in-app de son choix.';

  @override
  String get medalGoldSubtitle =>
      'L\'utilisateur a créé au minimum 4 événements ou a assisté à au minimum 4 événements sans échec au cours des 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 8% sur 1 achat in-app de son choix.';

  @override
  String get removeCardActionNotAllowedTitle => 'Action non autorisée';

  @override
  String get removeCardConnectEscrowLabel => 'Connectez votre compte séquestre';

  @override
  String get removeCardSubscriptionsLabel => 'Abonnements';

  @override
  String get removeCardConfirmDeletionTitle =>
      'Confirmer la suppression de la carte';

  @override
  String get myEventDetailsLabel => 'Détails de l\'événement';

  @override
  String get connectTvTitle => 'Connecter la TV';

  @override
  String get advertDialogTitle => 'Annonce';

  @override
  String get advertEventStarts48hrs => 'L\'événement commence dans 48 h';

  @override
  String get advertEventStarts7days => 'L\'événement commence dans 7 jours';

  @override
  String get userAroundTitle => 'Utilisateurs à proximité';

  @override
  String get userAroundMessage =>
      'Des correspondances potentielles correspondant à vos critères ont été trouvées actuellement';

  @override
  String get guestInviteTitle => 'Invitation d\'invité';

  @override
  String get inviteFriendsToKumeleTitle => 'Invitez vos amis sur Kumele';

  @override
  String get inviteReferralCodeLabel => 'Code de parrainage';

  @override
  String get congratulationsTitle => 'Félicitations';

  @override
  String get congratsNewStatusBronze => 'Nouveau statut : Bronze';

  @override
  String get congratsDiscountCode => 'Code de réduction : KEMELE20';

  @override
  String get congratsBronzeDescription =>
      'Vous avez créé au minimum 3 événements ou assisté à au minimum 3 événements sans échec au cours des 30 derniers jours. L\'utilisateur bénéficie d\'une réduction de 4% sur un achat in-app de son choix.';

  @override
  String get passkeyIntroDescription =>
      'Les clés d\'accès sont faciles à configurer et vous permettent de vous connecter en toute sécurité à votre compte Kumele en utilisant les capacités de sécurité de vos appareils comme Touch ID et Face ID. Les clés d\'accès sont bien plus sûres et plus faciles à utiliser que toutes les méthodes actuelles d\'authentification à 2 facteurs.';

  @override
  String get passkeyTitle => 'Clé d\'accès';

  @override
  String get signInUsingPasskeyLabel => 'Se connecter avec une clé d\'accès';

  @override
  String get signupPasskeyEmailHint => 'Saisissez votre e-mail';

  @override
  String get eventStartInLabel => 'Commence dans';

  @override
  String get cancelEventTitle => 'Annuler l\'événement';

  @override
  String get setTimeTitle => 'Définir l\'heure';

  @override
  String get guestPricesTitle => 'Prix des invités';

  @override
  String get guestPricesUnavailableMessage =>
      'Les prix des invités sont indisponibles pour le moment.';

  @override
  String get rewardRingsTitle => 'Anneaux de récompense';

  @override
  String get moneyEarnedTitle => 'Argent gagné';

  @override
  String get tryAgainLabel => 'Réessayer';

  @override
  String get locationServicesOffTitle => 'Services de localisation désactivés';

  @override
  String get locationAccessRequiredTitle => 'Accès à la localisation requis';

  @override
  String get locationServicesOffMessage =>
      'Veuillez activer les services de localisation sur votre appareil pour découvrir des événements près de chez vous.';

  @override
  String get locationPermissionPermanentlyDeniedMessage =>
      'L\'autorisation de localisation a été refusée définitivement. Veuillez l\'activer dans les paramètres de l\'application.';

  @override
  String get locationAccessNeededMessage =>
      'L\'accès à la localisation est nécessaire pour afficher les événements près de chez vous.';

  @override
  String get joinEventConfirmTitle => 'Rejoindre cet événement ?';

  @override
  String get joinLabel => 'Rejoindre';

  @override
  String get kumeleTermsOfUseLabel => 'Conditions d\'utilisation de Kumele';

  @override
  String get eventCancelledDialogTitle => 'Événement annulé';

  @override
  String get eventCancelledDialogMessage =>
      'L\'hôte a malheureusement annulé l\'événement. Nous nous excusons pour la gêne occasionnée. En cas de prépaiement, veuillez contacter immédiatement PayPal pour un remboursement.';

  @override
  String get premiumPurchaseIncludeLabel =>
      'L\'achat premium in-app comprend :';

  @override
  String get premiumLocationChange => 'Changement de localisation';

  @override
  String get premiumHouseParty => 'Fête à la maison (max. 10 invités)';

  @override
  String get premiumNoAds => 'Sans publicité';

  @override
  String get premium7DaysAdvertising => 'Publicité 7 jours avant l\'événement';

  @override
  String get signupDateOfBirthLabel => 'Date de naissance';

  @override
  String get signupGenderLabel => 'Genre';

  @override
  String get signUpButtonLabel => 'S\'inscrire';

  @override
  String myEventJoinedLabel(String date) {
    return 'Rejoint le $date';
  }

  @override
  String get myEventOrganizedByLabel => 'Organisé par';

  @override
  String get myEventDateTimeLabel => 'Date et heure';

  @override
  String get myEventLocationLabel => 'Lieu';

  @override
  String get myEventCapacityAvailabilityLabel => 'Capacité et disponibilité';

  @override
  String get myEventAboutEventLabel => 'À propos de l\'événement';

  @override
  String get eventRulesTitle => 'Règles et informations de l\'événement';

  @override
  String eventRuleAgeLabel(String minAge, String maxAge) {
    return 'Âge : $minAge - $maxAge';
  }

  @override
  String get eventRuleNoAgeLimitLabel => 'Aucune limite';

  @override
  String eventRuleGenderLabel(String gender) {
    return 'Genre : $gender';
  }

  @override
  String eventRuleLanguageLabel(String language) {
    return 'Langue : $language';
  }

  @override
  String get eventRuleRequiresApprovalLabel =>
      'Nécessite l\'approbation de l\'hôte';

  @override
  String get exploreMatchedEventLabel => 'Événement correspondant';

  @override
  String get exploreCreatedEventLabel => 'Événement créé';

  @override
  String get exploreJoinNowLabel => 'Rejoindre maintenant';

  @override
  String get exploreSwipeNoMoreMatchesLine1 =>
      'Aucune autre correspondance pour le moment,';

  @override
  String get exploreSwipeNoMoreMatchesLine2 => 'd\'ici là';

  @override
  String get exploreSwipeCreateEventCta => 'Soyez génial et créez un événement';

  @override
  String get exploreSwipeBlogsSuggestion =>
      'Voici quelques blogs qui pourraient vous plaire';

  @override
  String get exploreSwipeInviteFriendsCta => 'Soyez génial et invitez vos amis';

  @override
  String get exploreNotificationsTitle => 'Notifications';

  @override
  String get exploreTabletHeaderTitle => 'Explorer';

  @override
  String get createEventTitle => 'Créer un événement';

  @override
  String get previewEventLabel => 'Aperçu de l\'événement';

  @override
  String get createEventAgeRangeLabel => 'Tranche d\'âge';

  @override
  String get createEventNumberOfGuestsLabel => 'Nombre d\'invités';

  @override
  String get createEventRsvpGuestPaymentLabel => 'Paiement des invités RSVP';

  @override
  String get createEventFreeEventLabel => 'Événement gratuit';

  @override
  String get createEventCardPaymentLabel => 'Paiement par carte';

  @override
  String get createEventCashOnEntryLabel => 'Espèces à l\'entrée';

  @override
  String get reportEventTitle => 'Signaler l\'événement';

  @override
  String get reportEventChooseReasonLabel => 'Choisissez une raison';

  @override
  String get ratingsTitle => 'Évaluations';

  @override
  String get rateEventTitle => 'Évaluer l\'événement';

  @override
  String get attendeeRatingsLabel => 'Évaluations des participants (70%)';

  @override
  String get blogNoCommentsMessage =>
      'Aucun commentaire pour le moment. Soyez le premier à commenter !';

  @override
  String get nftPreviewTitle => 'Aperçu NFT';

  @override
  String get nftClosePreviewLabel => 'Fermer l\'aperçu';

  @override
  String get walletSignatureRequiredTitle =>
      'Signature du portefeuille requise';

  @override
  String get dismissLabel => 'Ignorer';

  @override
  String get soundNotificationTurnOnLabel => 'Activer la notification sonore';

  @override
  String get soundNotificationLabel => 'Notification sonore';

  @override
  String get turnOn2faLabel => 'Activer l\'authentification à 2 facteurs';

  @override
  String get chooseInterestsTitle => 'Choisissez vos centres d\'intérêt';

  @override
  String chooseUpToInterestsLabel(String count) {
    return 'Choisissez jusqu\'à $count centres d\'intérêt :';
  }

  @override
  String get earnMedalsAndRewardsTitle =>
      'Gagnez des médailles et des récompenses';

  @override
  String otherEventsFromHostLabel(String hostName) {
    return 'Autres événements de $hostName';
  }

  @override
  String get hobbyMeetupTagline => 'Rencontre de loisirs';

  @override
  String get splashTagline =>
      'Nous jouons. Nous surmontons. Nous unissons. Nous vivons.';

  @override
  String get skipLabel => 'Passer';

  @override
  String get guestTileGroupMeditationLabel => 'Méditation de groupe';

  @override
  String get guestTileHostedByLabel => 'Organisé par Anki Maheshwari';

  @override
  String get guestTileLocationLabel => 'Bahawalpur, Pendjab PK';

  @override
  String get filterMockLocationLabel => 'Royaume-Uni, 39495, Kentucky';

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyStatisticsTitle => 'Historique et statistiques';

  @override
  String get blogDetailsTitle => 'Détails du blog';

  @override
  String get addCardTitle => 'Ajouter une carte';

  @override
  String get addCardStripeMessage =>
      'Les informations de carte sont collectées en toute sécurité par Stripe.';

  @override
  String get addCardSubmitLabel => 'Ajouter la carte';

  @override
  String get noNotificationsTitle => 'Aucune notification';

  @override
  String get noNotificationsDescription =>
      'Vous n\'avez aucune nouvelle notification pour le moment. Revenez plus tard.';

  @override
  String get reportReasonRacist => 'Raciste';

  @override
  String get reportReasonScam => 'Arnaque';

  @override
  String get reportReasonOther => 'Autre';

  @override
  String get reportReasonPhysicalAssault => 'Agression physique';

  @override
  String get rateAppTitle => 'Veuillez noter votre dernier événement';

  @override
  String get rateAppStoriesTitle => 'Noter cette application';

  @override
  String get rateAppThankYouTitle => 'Merci !';

  @override
  String get rateAppFeedbackTitle => 'Comment pouvons-nous améliorer ?';

  @override
  String get rateAppCommentHint => 'Ajouter un commentaire';

  @override
  String get rateAppSendButton => 'Envoyer';

  @override
  String get chooseUsernameTitle => 'Choisissez votre nom d\'utilisateur';

  @override
  String get chooseUsernameDescription =>
      'Les noms d\'utilisateur ne peuvent être modifiés que tous les 3 mois.';

  @override
  String get chooseUsernameHint => 'Saisissez votre nom d\'utilisateur';

  @override
  String get chooseUsernameSkip => 'Ignorer';

  @override
  String get guestInviteTotalGuests => 'Nombre total d\'invités';

  @override
  String get guestInviteFreeRange => '1–5 gratuits';

  @override
  String get guestInviteDialogOr => ' ou ';

  @override
  String get signupLegalAdultCheckbox => 'Je suis majeur (18/21+)';

  @override
  String get signupSubscribeCheckbox => 'S\'abonner à la newsletter';

  @override
  String get signupTermsCheckboxPrefix =>
      'En créant un compte, vous acceptez les ';

  @override
  String get signupTermsCheckboxLink => 'Conditions générales';

  @override
  String get signupCaptchaCheckbox => 'Je ne suis pas un robot';

  @override
  String get signupErrorFirstNameRequired => 'Veuillez saisir votre prénom';

  @override
  String get signupErrorEmailRequired => 'Veuillez saisir votre e-mail';

  @override
  String get signupErrorEmailInvalid => 'Veuillez saisir un e-mail valide';

  @override
  String get signupErrorPasswordRequired => 'Veuillez saisir le mot de passe';

  @override
  String get signupErrorPasswordTooShort =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get signupErrorConfirmPasswordRequired =>
      'Veuillez confirmer le mot de passe';

  @override
  String get signupErrorPasswordMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get signupErrorLegalAgeRequired =>
      'Vous devez confirmer que vous êtes majeur';

  @override
  String get signupErrorTermsRequired =>
      'Vous devez accepter les conditions générales';

  @override
  String get signupErrorCaptchaRequired =>
      'Veuillez confirmer que vous n\'êtes pas un robot';

  @override
  String get permissionGuestInviteTitle => 'Invitation d\'invité';

  @override
  String get permissionEventCanceledTitle => 'Événement annulé';

  @override
  String get permissionFollowHostTitle => 'Suivre l\'hôte';

  @override
  String get permissionFollowHostConfirm => 'Suivre';

  @override
  String get permissionUsernameHint => 'Saisissez le nom d\'utilisateur';

  @override
  String get exploreSwipeCreateEventButton => 'Créer un événement';

  @override
  String get exploreSwipeReadBlogButton => 'Lire le blog';

  @override
  String get exploreSwipeInviteFriendsButton => 'Inviter des amis';

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
    return 'Expire le $date';
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
  String get termsSection1Title => '1. Éligibilité du compte';

  @override
  String get termsSection2Title => '2. Utilisation acceptable';

  @override
  String get termsSection3Title => '3. Événements et contenu de la communauté';

  @override
  String get termsSection4Title => '4. Paiements et abonnements';

  @override
  String get termsSection5Title => '5. Confidentialité et communications';

  @override
  String get termsSection6Title => '6. Résiliation';

  @override
  String get termsSection7Title => '7. Modifications de ces conditions';

  @override
  String get nftClaimingButton => 'Réclamation en cours…';

  @override
  String get nftBuyingButton => 'Achat en cours…';

  @override
  String get nftClaimButton => 'Réclamer';

  @override
  String get nftBuyButton => 'Acheter';

  @override
  String get languageUpdateFailed => 'Échec de la mise à jour de la langue.';

  @override
  String get eventDetailNotFound =>
      'Les détails de l\'événement demandé sont introuvables.';

  @override
  String myEventAttendeesLabel(int count, int capacity, int remaining) {
    return '$count / $capacity participants ($remaining places restantes)';
  }

  @override
  String get shareEventDialogOr => ' ou ';

  @override
  String aboutHostPrefix(String hostName) {
    return 'À propos de $hostName : ';
  }

  @override
  String get pleaseCompleteAllFields => 'Veuillez remplir tous les champs';

  @override
  String get ratingSubmittedSuccess => 'Note envoyée avec succès';

  @override
  String get ratingSubmitFailed => 'Échec de l\'envoi de la note';

  @override
  String get reportSubmittedSuccess => 'Signalement envoyé avec succès';

  @override
  String get reportSubmitFailed => 'Échec de l\'envoi du signalement';

  @override
  String get markAllAsRead => 'Tout marquer comme lu';

  @override
  String get paymentAddNewCardLabel => 'Ajouter une nouvelle carte';

  @override
  String get paymentPayNowLabel => 'Payer maintenant';

  @override
  String get paymentPayWithLabel => 'Payer avec';

  @override
  String get useCurrentLocation => 'Utiliser la position actuelle';

  @override
  String get orEnterAnAddress => 'OU SAISIR UNE ADRESSE';

  @override
  String get openSettings => 'Ouvrir les réglages';

  @override
  String get saveLocation => 'Enregistrer la position';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get changeInterestsTitle => 'Modifier les centres d\'intérêt';

  @override
  String get houseNumberLabel => 'Numéro';

  @override
  String get districtCityLabel => 'Quartier / Ville';

  @override
  String get permissionNotificationPrimerTitle =>
      '« Kumele » souhaite vous envoyer des notifications';

  @override
  String get permissionNotificationPrimerMessage =>
      'Les notifications peuvent inclure des alertes, des sons et des pastilles. Elles sont configurables dans les Réglages.';

  @override
  String get permissionPhotosPrimerTitle =>
      '« Kumele » souhaite accéder à vos photos';

  @override
  String get permissionPhotosPrimerMessage =>
      'Autorisez « Kumele » à accéder à vos photos pour envoyer des images ou des vidéos';

  @override
  String get permissionLocationPrimerTitle =>
      'Autoriser « Kumele » à accéder à votre position ?';

  @override
  String get permissionLocationPrimerMessage =>
      'Autorisez « Kumele » à accéder à votre position pour afficher les événements près de vous';

  @override
  String get permissionDontAllow => 'Ne pas autoriser';

  @override
  String get permissionAllow => 'Autoriser';

  @override
  String get permissionSelectPhotos => 'Sélectionner des photos...';

  @override
  String get permissionAllowAllPhotos =>
      'Autoriser l\'accès à toutes les photos';

  @override
  String get permissionAllowWhileUsingApp =>
      'Autoriser lors de l\'utilisation de l\'app';

  @override
  String get permissionAllowOnce => 'Autoriser une fois';

  @override
  String get myEventPlaceholderTitle => 'Titre de l\'événement loisir';

  @override
  String get myEventPlaceholderTime => '12:00-13:00';

  @override
  String get myEventPlaceholderStartTime => 'Commence dans 2 j';

  @override
  String get myEventPlaceholderLocation => 'Centre-ville, Berlin';

  @override
  String get welcomeToKumeleMessage => 'Bienvenue sur Kumele !';

  @override
  String get selectDateTimeFirstError =>
      'Veuillez d\'abord sélectionner une date et une heure.';

  @override
  String get accountCreatedSuccessMessage => 'Compte créé avec succès !';

  @override
  String signupFailedPrefix(String error) {
    return 'Échec de l\'inscription : $error';
  }

  @override
  String get nftClaimedMessage => 'NFT réclamé.';

  @override
  String get nftClaimFailedError => 'Impossible de réclamer ce NFT.';

  @override
  String get nftPurchasedMessage => 'NFT acheté.';

  @override
  String get nftPurchaseFailedError => 'Impossible d\'acheter ce NFT.';

  @override
  String get loadBlogPostFailedError =>
      'Échec du chargement de l\'article de blog.';

  @override
  String get paypalAccountConnectedMessage => 'Compte PayPal connecté.';

  @override
  String get restoringPurchasesMessage =>
      'Restauration des achats en cours — cela peut prendre un moment.';

  @override
  String get cardSetupUnavailableError =>
      'La configuration de la carte n\'est pas disponible.';

  @override
  String get cardAddedSuccessMessage => 'Carte ajoutée avec succès.';

  @override
  String get addCardFailedError => 'Impossible d\'ajouter la carte.';

  @override
  String get copiedMessage => 'Copié';

  @override
  String get eventCreatedPendingPaymentMessage =>
      'Événement créé. Finalisez le paiement pour l\'activer.';

  @override
  String get eventCreatedSuccessMessage => 'Événement créé avec succès.';
}
