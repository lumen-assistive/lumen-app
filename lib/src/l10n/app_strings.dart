import 'package:flutter/widgets.dart';

/// Lumen's own localized strings.
///
/// Implemented as a plain `LocalizationsDelegate` over a const resource
/// map rather than the `flutter gen-l10n` code generation pipeline:
/// this keeps the build fully deterministic and inspectable without
/// depending on a generation step that could not be exercised in the
/// environment this repository was first built in. English only: the
/// app no longer ships an Italian locale, a deliberate reversal of the
/// original design so that no Italian wording appears in the interface.
class AppStrings {
  const AppStrings._(this._values);

  final Map<String, String> _values;

  static const _en = <String, String>{
    'appTitle': 'Lumen',
    'onboardingTitle': 'Who are you?',
    'onboardingNext': 'Next',
    'onboardingFinish': 'Finish',
    'onboardingQuestionVisionTitle': 'Do you have difficulty seeing clearly?',
    'onboardingQuestionHearingTitle': 'Do you have difficulty hearing?',
    'onboardingQuestionSafetyTitle':
        'Would you like safety features such as fall detection and emergency SOS?',
    'onboardingQuestionCaregiverTitle':
        'Are you setting this up for a loved one, or do you want a family member kept informed?',
    'onboardingQuestionComplexityTitle': 'How would you like the app to look?',
    'answerYes': 'Yes',
    'answerNo': 'No',
    'answerComplexitySimple': 'Simple and essential',
    'answerComplexityComplete': 'Complete, with every option',
    'homeTitle': 'Your modules',
    'homeHeadline': "A little light, when it's needed.",
    'homeSubtitle': 'Everything runs on this phone, no internet required.',
    'homeNoModules': 'No module is active yet. Go to settings to enable one.',
    'homeModuleStatusActive': 'Active',
    'settingsTitle': 'Settings',
    'settingsSectionAppearance': 'Appearance',
    'settingsUiMode': 'Interface mode',
    'settingsTextScale': 'Text size',
    'settingsSectionModules': 'Modules',
    'settingsModuleEnabled': 'Enabled',
    'settingsModuleConsent': 'Consent to share with family',
    'settingsDisclaimerTitle': 'Important notice',
    'settingsDisclaimerBody':
        'Lumen helps but does not replace a doctor or the 112 emergency number, and is not a certified medical device.',
    'settingsDeveloperSection': 'Developer',
    'settingsDeveloperModeToggle': 'Developer mode',
    'diagnosticsTitle': 'Diagnostics',
    'diagnosticsNoPlugins':
        'No module is registered with the engine right now.',
    'diagnosticsBatteryLabel': 'Battery drain',
    'diagnosticsLatencyLabel': 'Mean latency',
    'diagnosticsNotAvailable': 'not available yet',
    'moduleNameVision': 'Vision',
    'moduleNameHearing': 'Hearing',
    'moduleNameSafety': 'Safety',
    'moduleNameFamily': 'Family and caregivers',
    'moduleDescriptionVision':
        'Scene description, text reading, and expiry date lookup via the camera.',
    'moduleDescriptionHearing': 'Offline captions and sound alerts.',
    'moduleDescriptionSafety':
        'Fall detection, emergency SOS, and scam filtering.',
    'moduleDescriptionFamily':
        'Remote configuration and shared status with family members.',
    'moduleNameSpeech': 'Speak',
    'moduleDescriptionSpeech':
        'Quick phrase board with usage-ranked suggestions.',
    'moduleNameReading': 'Read and Study',
    'moduleDescriptionReading':
        'Syllable splitting and spaced repetition for studying.',
    'moduleNameMemory': 'Remember',
    'moduleDescriptionMemory':
        'Consent-gated contacts and recurring reminders.',
    'moduleNameMobility': 'Move',
    'moduleDescriptionMobility': 'Gait monitoring and a mobility profile.',
    'uiModeVoiceFirstHighContrast': 'Voice-first, high contrast',
    'uiModeVisualWithVibration': 'Visual, with vibration',
    'uiModeSimple': 'Simple',
    'uiModeComplete': 'Complete',
    'visionNote':
        'Shows the expiry date reader and color namer, already real and tested. Scene description, banknote, medicine, and obstacle recognition need a camera and vision models not implemented yet.',
    'visionExpiryTitle': 'Expiry date reader',
    'visionExpiryHint': 'Paste text as if read from a label',
    'visionExpiryButton': 'Find the expiry date',
    'visionExpiryFound': 'Expiry date found: {date}',
    'visionExpiryNotFound': 'No expiry date recognized.',
    'visionColorTitle': 'Color namer',
    'visionColorRed': 'Red (0-255)',
    'visionColorGreen': 'Green (0-255)',
    'visionColorBlue': 'Blue (0-255)',
    'visionColorButton': 'Name color',
    'visionColorResultPrefix': 'Nearest match:',
    'visionContrastTitle': 'WCAG contrast check',
    'visionContrastHint':
        'Check the color above against a white and a black background.',
    'visionContrastButton': 'Check contrast',
    'visionContrastResult':
        'On white: {whiteRatio}:1 (AA: {whitePass}). On black: {blackRatio}:1 (AA: {blackPass}).',
    'hearingNote':
        'Shows transcript summarization and sound alert mapping, already real and tested, and a sound alert now really vibrates the phone. Live captioning and real sound classification need a microphone and models not implemented yet.',
    'hearingSummaryTitle': 'Transcript summarizer',
    'hearingSummaryHint': 'Paste transcript-like text',
    'hearingSummaryButton': 'Summarize',
    'hearingSummaryEmpty': 'No sentences recognized in this text.',
    'hearingCaptionTitle': 'Caption formatting',
    'hearingCaptionHint':
        'Wraps the transcript above into caption-sized lines.',
    'hearingCaptionButton': 'Format as captions',
    'hearingAlertTitle': 'Sound alert presentation',
    'hearingAlertButton': 'Show and vibrate',
    'hearingAlertResult':
        'Vibration: {pattern} ms. Flash: {flash}. Severity: {severity}.',
    'safetyNote':
        'Shows the scam filter, fall detection, and SOS, already real and tested. Fall detection can also run on the phone\'s live accelerometer. SOS uses a fake message sender: it can never send a real message.',
    'safetyScamTitle': 'Scam message checker',
    'safetyScamHint': 'Paste a message',
    'safetyScamButton': 'Check message',
    'safetyFallTitle': 'Fall detection',
    'safetyFallSteadyButton': 'Simulate steady readings',
    'safetyFallSimulateButton': 'Simulate a fall',
    'safetyFallNotDetected': 'No fall detected.',
    'safetyFallDetected': 'Fall detected.',
    'safetyCheckInTitle': 'Periodic check-in',
    'safetyCheckInHint':
        'Confirm you are ok every 12 hours. Without a confirmation, the check-in becomes overdue.',
    'safetyCheckInButton': 'Check in now',
    'safetyCheckInStatusButton': 'Check status',
    'safetyCheckInOk': 'All good, no overdue check-in.',
    'safetyCheckInOverdue': 'Check-in overdue: no recent confirmation.',
    'safetySosTitle': 'Emergency SOS',
    'safetySosIdle': 'No SOS in progress.',
    'safetySosCountdown': 'Counting down, you can still cancel.',
    'safetySosSent': 'Message ready to send (fake sender, no real SMS sent).',
    'safetySosCancelled': 'SOS cancelled.',
    'safetySosStartButton': 'Start SOS',
    'safetySosCancelButton': 'Cancel',
    'familyNote':
        'Shows pairing code generation, the shared calendar, and daily status, already real and tested, and what you add is kept on this device. Actual sync to a caregiver device through lumen-server is not wired up yet.',
    'familyPairingTitle': 'Caregiver pairing code',
    'familyPairingButton': 'Generate code',
    'familyPairingResult': 'Code: {code} (valid for {minutes} minutes)',
    'familyCalendarTitle': 'Shared calendar',
    'familyCalendarTitleHint': 'Event title',
    'familyCalendarMinutesHint': 'Minutes from now',
    'familyCalendarButton': 'Add event',
    'familyStatusTitle': "Today's status",
    'familyStatusOkResult': "Today's status: all ok",
    'familyStatusAttentionResult': "Today's status: needs attention",
    'familyStatusUnknownResult': 'No status set for today yet.',
    'familyStatusOkButton': 'All ok',
    'familyStatusAttentionButton': 'Needs attention',
    'familyNotificationTitle': 'Caregiver notification',
    'familyNotificationHint':
        'Compose the notification text from today\'s status and the events added above.',
    'familyNotificationButton': 'Compose notification',
    'speechNote':
        'Shows the phrase board and usage-ranked suggestions, already real and tested. Phrases are spoken aloud with the phone\'s own voice, and your usage is remembered. Pictogram images are not implemented yet.',
    'speechCategoryNeeds': 'Needs',
    'speechCategoryGreetings': 'Greetings',
    'speechCategoryEmotions': 'Emotions',
    'speechCategoryEmergency': 'Emergency',
    'speechSuggestionsTitle': 'Top suggestions',
    'speechSentenceTitle': 'Build a sentence',
    'speechSentenceHint':
        'Phrases tapped above are added here. Compose them into one sentence.',
    'speechSentenceBuildButton': 'Build sentence',
    'speechSentenceClearButton': 'Clear',
    'speechSpeakButton': 'Speak aloud',
    'speechNoVoice': 'No speech voice is available on this device.',
    'readingReadAloudButton': 'Read aloud',
    'safetyLiveToggle': 'Use the live accelerometer',
    'safetyLiveWatching':
        'Watching for a fall. Readings are checked twice a second.',
    'safetyLiveFall': 'Fall detected from live sensor data.',
    'mobilityLiveToggle': 'Use the live accelerometer',
    'mobilityLiveWatching':
        'Walk with the phone in a pocket. Your gait is analysed every two seconds.',
    'hearingNoVibrator':
        'This device has no vibrator, so only the pattern is shown.',
    'readingNote':
        'Shows syllable splitting and spaced repetition (SM-2), already real and tested, and your review progress is kept. Text can be read aloud with the phone\'s own voice. Scanning printed text and dyslexia-specific adaptation are not implemented yet.',
    'readingSyllableTitle': 'Syllable splitter',
    'readingSyllableHint': 'Type a word or phrase',
    'readingSyllableButton': 'Split into syllables',
    'readingFlashcardTitle': 'Flashcard review',
    'readingFlashcardPrompt': 'What is the capital of Italy?',
    'readingFlashcardQualityHint':
        'How well did you recall it? (0 poor, 5 perfect)',
    'readingFlashcardResult':
        'Next review in {days} day(s), easiness {ease}, {streak} successful review(s) in a row.',
    'readingTimeTitle': 'Estimated reading time',
    'readingTimeHint': 'Paste a block of text to estimate',
    'readingTimeButton': 'Estimate reading time',
    'readingTimeResult': 'Estimated reading time: {minutes} minute(s).',
    'memoryNote':
        'Shows the consent-gated person directory and reminders, already real and tested, and what you add is kept on this device. Reminders are checked inside the app and do not send notifications yet. Real face recognition needs a camera and a model not implemented yet.',
    'memoryPersonTitle': 'People to remember',
    'memoryPersonNameHint': 'Name',
    'memoryPersonRelationshipHint': 'Relationship',
    'memoryPersonConsent': 'Consent to future recognition',
    'memoryPersonButton': 'Add person',
    'memoryPersonAdded': 'Person added.',
    'memoryConsentGiven': 'consent given',
    'memoryConsentNotGiven': 'consent not given',
    'memoryReminderTitle': 'Reminders',
    'memoryReminderTitleHint': 'Reminder',
    'memoryReminderMinutesHint': 'Minutes from now',
    'memoryReminderAddButton': 'Add reminder',
    'memoryReminderCheckButton': 'Check due reminders',
    'memoryReminderNoneDue': 'No reminders due.',
    'memoryReminderDue': 'Due now: {titles}',
    'memoryRoutineTitle': 'Daily routine',
    'memoryRoutineHint': 'Resets every day at midnight.',
    'memoryRoutineStepMedication': 'Take morning medication',
    'memoryRoutineStepLockDoor': 'Lock the door',
    'memoryRoutineComplete': 'Routine complete for today.',
    'memoryRoutineRemaining': 'Still to do: {steps}',
    'mobilityNote':
        'Shows gait stability monitoring and the mobility profile, already real and tested. You can use simulated walks or the phone\'s live accelerometer, and your profile is kept on this device.',
    'mobilityGaitTitle': 'Gait stability monitor',
    'mobilityGaitSteadyButton': 'Simulate steady walk',
    'mobilityGaitUnsteadyButton': 'Simulate unsteady walk',
    'mobilityGaitResult':
        '{irregular}. {steps} steps detected, {cadence} steps per minute.',
    'mobilityGaitIrregular': 'Irregular rhythm: possible stumble risk',
    'mobilityGaitSteady': 'Steady rhythm',
    'mobilityProfileTitle': 'Mobility profile',
    'mobilityAidNone': 'No aid',
    'mobilityAidCane': 'Cane',
    'mobilityAidWheelchair': 'Wheelchair',
    'mobilityAidWalker': 'Walker',
    'mobilityAidOther': 'Other',
    'mobilityVerbosityMinimal': 'Minimal',
    'mobilityVerbosityStandard': 'Standard',
    'mobilityVerbosityDetailed': 'Detailed',
    'mobilityProfileNotesHint': "Notes (required if 'Other')",
    'mobilityProfileButton': 'Save profile',
    'mobilityProfileSaved': 'Profile saved.',
    'mobilityBreaksTitle': 'Plan rest breaks',
    'mobilityBreaksHint':
        'Suggests breaks based on the walk duration and the verbosity chosen above.',
    'mobilityBreaksMinutesHint': 'Walk duration (minutes)',
    'mobilityBreaksButton': 'Plan breaks',
    'mobilityBreaksNone': 'No break needed for such a short walk.',
    'mobilityBreaksResult': 'Suggested breaks at minute: {minutes}',
  };

  /// Looks up [key], falling back to the key itself as a last resort so
  /// a missing translation never crashes the app.
  String call(String key) => _values[key] ?? key;

  static const _delegateInstance = _AppStringsDelegate();

  /// The delegate to register in `MaterialApp.localizationsDelegates`.
  static LocalizationsDelegate<AppStrings> get delegate => _delegateInstance;

  /// Retrieves the [AppStrings] for the nearest [Localizations] in
  /// [context].
  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings)!;
  }

  static const supportedLocales = <Locale>[Locale('en')];

  static const _instance = AppStrings._(_en);
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings._instance;

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
