import 'package:flutter/widgets.dart';

/// Lumen's own localized strings.
///
/// Implemented as a plain `LocalizationsDelegate` over const resource
/// maps rather than the `flutter gen-l10n` code generation pipeline:
/// this keeps the build fully deterministic and inspectable without
/// depending on a generation step that could not be exercised in the
/// environment this repository was first built in. Italian is the
/// default locale; English is the fallback for any locale this app
/// does not otherwise recognize.
class AppStrings {
  const AppStrings._(this._values);

  final Map<String, String> _values;

  static const _it = <String, String>{
    'appTitle': 'Lumen',
    'onboardingTitle': 'Chi sei?',
    'onboardingNext': 'Avanti',
    'onboardingFinish': 'Fine',
    'onboardingQuestionVisionTitle': 'Hai difficolta a vedere chiaramente?',
    'onboardingQuestionHearingTitle': 'Hai difficolta a sentire?',
    'onboardingQuestionSafetyTitle':
        'Vuoi funzioni di sicurezza come il rilevamento delle cadute e il SOS di emergenza?',
    'onboardingQuestionCaregiverTitle':
        'Stai configurando questa app per una persona cara, o vuoi che un familiare resti informato?',
    'onboardingQuestionComplexityTitle': 'Come preferisci che appaia l\'app?',
    'answerYes': 'Si',
    'answerNo': 'No',
    'answerComplexitySimple': 'Semplice ed essenziale',
    'answerComplexityComplete': 'Completa, con tutte le opzioni',
    'homeTitle': 'I tuoi moduli',
    'homeNoModules':
        'Nessun modulo attivo. Vai nelle impostazioni per attivarne uno.',
    'homeModuleStatusActive': 'Attivo',
    'settingsTitle': 'Impostazioni',
    'settingsSectionAppearance': 'Aspetto',
    'settingsUiMode': 'Modalita interfaccia',
    'settingsTextScale': 'Dimensione del testo',
    'settingsSectionModules': 'Moduli',
    'settingsModuleEnabled': 'Attivo',
    'settingsModuleConsent': 'Consenso alla condivisione con i familiari',
    'settingsDisclaimerTitle': 'Avviso importante',
    'settingsDisclaimerBody':
        'Lumen aiuta ma non sostituisce un medico o il numero di emergenza 112, e non e un dispositivo medico certificato.',
    'settingsDeveloperSection': 'Sviluppatore',
    'settingsDeveloperModeToggle': 'Modalita sviluppatore',
    'diagnosticsTitle': 'Diagnostica',
    'diagnosticsNoPlugins': 'Nessun modulo registrato nel motore al momento.',
    'diagnosticsBatteryLabel': 'Consumo batteria',
    'diagnosticsLatencyLabel': 'Latenza media',
    'diagnosticsNotAvailable': 'non ancora disponibile',
    'moduleNameVedere': 'Vedere',
    'moduleNameSentire': 'Sentire',
    'moduleNameProtezione': 'Protezione',
    'moduleNameFamiglia': 'Famiglia e caregiver',
    'moduleDescriptionVedere':
        'Descrizione di scene, lettura di testi e date di scadenza tramite la fotocamera.',
    'moduleDescriptionSentire': 'Sottotitoli e avvisi sonori offline.',
    'moduleDescriptionProtezione':
        'Rilevamento cadute, SOS di emergenza e filtro truffe.',
    'moduleDescriptionFamiglia':
        'Configurazione remota e stato condiviso con i familiari.',
    'moduleNameParlare': 'Parlare',
    'moduleDescriptionParlare':
        'Bacheca di frasi rapide con suggerimenti basati sull\'uso.',
    'moduleNameLeggere': 'Leggere e Studiare',
    'moduleDescriptionLeggere':
        'Divisione in sillabe e ripetizione dilazionata per lo studio.',
    'moduleNameRicordare': 'Ricordare',
    'moduleDescriptionRicordare':
        'Rubrica con consenso e promemoria ricorrenti.',
    'moduleNameMuoversi': 'Muoversi',
    'moduleDescriptionMuoversi':
        'Monitoraggio dell\'andatura e profilo di mobilita.',
    'uiModeVoiceFirstHighContrast': 'Vocale, massimo contrasto',
    'uiModeVisualWithVibration': 'Visiva, con vibrazione',
    'uiModeSimple': 'Semplice',
    'uiModeComplete': 'Completa',
    'vedereNote':
        'Mostra il lettore di date di scadenza e il riconoscimento colore, gia reali e testati. Descrizione di scene, banconote, medicinali e ostacoli richiedono fotocamera e modelli visivi non ancora implementati.',
    'vedereExpiryTitle': 'Lettore di date di scadenza',
    'vedereExpiryHint': 'Incolla un testo come letto da un\'etichetta',
    'vedereExpiryButton': 'Trova la data di scadenza',
    'vedereExpiryFound': 'Data di scadenza trovata: {date}',
    'vedereExpiryNotFound': 'Nessuna data di scadenza riconosciuta.',
    'vedereColorTitle': 'Riconoscimento colore',
    'vedereColorRed': 'Rosso (0-255)',
    'vedereColorGreen': 'Verde (0-255)',
    'vedereColorBlue': 'Blu (0-255)',
    'vedereColorButton': 'Riconosci colore',
    'vedereColorResultPrefix': 'Colore piu vicino:',
    'sentireNote':
        'Mostra il riassunto di un testo e la mappatura degli avvisi sonori, gia reali e testati. I sottotitoli dal vivo e la classificazione dei suoni richiedono un microfono e modelli non ancora implementati.',
    'sentireSummaryTitle': 'Riassunto trascrizione',
    'sentireSummaryHint': 'Incolla un testo trascritto',
    'sentireSummaryButton': 'Riassumi',
    'sentireSummaryEmpty': 'Nessuna frase riconosciuta in questo testo.',
    'sentireAlertTitle': 'Presentazione avviso sonoro',
    'sentireAlertButton': 'Mostra presentazione',
    'sentireAlertResult':
        'Vibrazione: {pattern} ms. Flash: {flash}. Gravita: {severity}.',
    'protezioneNote':
        'Mostra il filtro truffe, il rilevamento cadute e l\'SOS, gia reali e testati. L\'SOS usa un mittente SMS finto: non puo mai inviare un messaggio vero. Il rilevamento cadute usa dati accelerometrici simulati, non un sensore dal vivo.',
    'protezioneScamTitle': 'Controllo messaggi truffa',
    'protezioneScamHint': 'Incolla un messaggio',
    'protezioneScamButton': 'Controlla messaggio',
    'protezioneFallTitle': 'Rilevamento cadute',
    'protezioneFallSteadyButton': 'Simula movimento normale',
    'protezioneFallSimulateButton': 'Simula una caduta',
    'protezioneFallNotDetected': 'Nessuna caduta rilevata.',
    'protezioneFallDetected': 'Caduta rilevata.',
    'protezioneSosTitle': 'SOS di emergenza',
    'protezioneSosIdle': 'Nessun SOS in corso.',
    'protezioneSosCountdown': 'Conto alla rovescia in corso, puoi annullare.',
    'protezioneSosSent':
        'Messaggio pronto per l\'invio (mittente finto, nessun SMS reale inviato).',
    'protezioneSosCancelled': 'SOS annullato.',
    'protezioneSosStartButton': 'Avvia SOS',
    'protezioneSosCancelButton': 'Annulla',
    'famigliaNote':
        'Mostra la generazione di codici di accoppiamento, il calendario e lo stato giornaliero, gia reali e testati. La sincronizzazione effettiva con un dispositivo caregiver tramite lumen-server non e ancora collegata.',
    'famigliaPairingTitle': 'Codice di accoppiamento caregiver',
    'famigliaPairingButton': 'Genera codice',
    'famigliaPairingResult': 'Codice: {code} (valido {minutes} minuti)',
    'famigliaCalendarTitle': 'Calendario condiviso',
    'famigliaCalendarTitleHint': 'Titolo evento',
    'famigliaCalendarMinutesHint': 'Minuti da adesso',
    'famigliaCalendarButton': 'Aggiungi evento',
    'famigliaStatusTitle': 'Stato di oggi',
    'famigliaStatusOkResult': 'Stato di oggi: tutto ok',
    'famigliaStatusAttentionResult': 'Stato di oggi: serve attenzione',
    'famigliaStatusUnknownResult': 'Nessuno stato impostato per oggi.',
    'famigliaStatusOkButton': 'Tutto ok',
    'famigliaStatusAttentionButton': 'Serve attenzione',
    'parlareNote':
        'Mostra la bacheca di frasi e i suggerimenti basati sull\'uso, gia reali e testati. La sintesi vocale reale e le immagini dei simboli non sono ancora implementate.',
    'parlareCategoryNeeds': 'Bisogni',
    'parlareCategoryGreetings': 'Saluti',
    'parlareCategoryEmotions': 'Emozioni',
    'parlareCategoryEmergency': 'Emergenza',
    'parlareSuggestionsTitle': 'Suggerimenti principali',
    'leggereNote':
        'Mostra la divisione in sillabe e la ripetizione dilazionata (SM-2), gia reali e testate. La lettura ad alta voce di testo scansionato e l\'adattamento specifico per la dislessia non sono ancora implementati.',
    'leggereSyllableTitle': 'Divisione in sillabe',
    'leggereSyllableHint': 'Scrivi una parola o frase',
    'leggereSyllableButton': 'Dividi in sillabe',
    'leggereFlashcardTitle': 'Ripasso con flashcard',
    'leggereFlashcardPrompt': 'Qual e la capitale d\'Italia?',
    'leggereFlashcardQualityHint':
        'Quanto bene te la ricordavi? (0 scarso, 5 perfetto)',
    'leggereFlashcardResult':
        'Prossimo ripasso tra {days} giorno/i, facilita {ease}, {streak} ripasso/i corretti di fila.',
    'ricordareNote':
        'Mostra la rubrica con consenso e i promemoria, gia reali e testati. Il riconoscimento facciale reale richiede fotocamera e modello non ancora implementati.',
    'ricordarePersonTitle': 'Persone da ricordare',
    'ricordarePersonNameHint': 'Nome',
    'ricordarePersonRelationshipHint': 'Relazione',
    'ricordarePersonConsent': 'Consenso al riconoscimento futuro',
    'ricordarePersonButton': 'Aggiungi persona',
    'ricordarePersonAdded': 'Persona aggiunta.',
    'ricordareConsentGiven': 'consenso dato',
    'ricordareConsentNotGiven': 'consenso non dato',
    'ricordareReminderTitle': 'Promemoria',
    'ricordareReminderTitleHint': 'Promemoria',
    'ricordareReminderMinutesHint': 'Minuti da adesso',
    'ricordareReminderAddButton': 'Aggiungi promemoria',
    'ricordareReminderCheckButton': 'Controlla scadenze',
    'ricordareReminderNoneDue': 'Nessun promemoria scaduto.',
    'ricordareReminderDue': 'In scadenza: {titles}',
    'muoversiNote':
        'Mostra il monitoraggio della stabilita dell\'andatura su dati simulati e il profilo di mobilita, gia reali e testati. Non c\'e ancora un sensore accelerometrico dal vivo in questa app.',
    'muoversiGaitTitle': 'Monitoraggio andatura',
    'muoversiGaitSteadyButton': 'Simula camminata regolare',
    'muoversiGaitUnsteadyButton': 'Simula camminata irregolare',
    'muoversiGaitResult':
        '{irregular}. {steps} passi rilevati, {cadence} passi al minuto.',
    'muoversiGaitIrregular': 'Ritmo irregolare: possibile rischio di inciampo',
    'muoversiGaitSteady': 'Ritmo regolare',
    'muoversiProfileTitle': 'Profilo di mobilita',
    'muoversiAidNone': 'Nessun ausilio',
    'muoversiAidCane': 'Bastone',
    'muoversiAidWheelchair': 'Sedia a rotelle',
    'muoversiAidWalker': 'Deambulatore',
    'muoversiAidOther': 'Altro',
    'muoversiVerbosityMinimal': 'Essenziale',
    'muoversiVerbosityStandard': 'Standard',
    'muoversiVerbosityDetailed': 'Dettagliata',
    'muoversiProfileNotesHint': 'Note (richieste se \'Altro\')',
    'muoversiProfileButton': 'Salva profilo',
    'muoversiProfileSaved': 'Profilo salvato.',
  };

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
    'moduleNameVedere': 'Vedere',
    'moduleNameSentire': 'Sentire',
    'moduleNameProtezione': 'Protezione',
    'moduleNameFamiglia': 'Family and caregivers',
    'moduleDescriptionVedere':
        'Scene description, text reading, and expiry date lookup via the camera.',
    'moduleDescriptionSentire': 'Offline captions and sound alerts.',
    'moduleDescriptionProtezione':
        'Fall detection, emergency SOS, and scam filtering.',
    'moduleDescriptionFamiglia':
        'Remote configuration and shared status with family members.',
    'moduleNameParlare': 'Speak',
    'moduleDescriptionParlare':
        'Quick phrase board with usage-ranked suggestions.',
    'moduleNameLeggere': 'Read and Study',
    'moduleDescriptionLeggere':
        'Syllable splitting and spaced repetition for studying.',
    'moduleNameRicordare': 'Remember',
    'moduleDescriptionRicordare':
        'Consent-gated contacts and recurring reminders.',
    'moduleNameMuoversi': 'Move',
    'moduleDescriptionMuoversi': 'Gait monitoring and a mobility profile.',
    'uiModeVoiceFirstHighContrast': 'Voice-first, high contrast',
    'uiModeVisualWithVibration': 'Visual, with vibration',
    'uiModeSimple': 'Simple',
    'uiModeComplete': 'Complete',
    'vedereNote':
        'Shows the expiry date reader and color namer, already real and tested. Scene description, banknote, medicine, and obstacle recognition need a camera and vision models not implemented yet.',
    'vedereExpiryTitle': 'Expiry date reader',
    'vedereExpiryHint': 'Paste text as if read from a label',
    'vedereExpiryButton': 'Find the expiry date',
    'vedereExpiryFound': 'Expiry date found: {date}',
    'vedereExpiryNotFound': 'No expiry date recognized.',
    'vedereColorTitle': 'Color namer',
    'vedereColorRed': 'Red (0-255)',
    'vedereColorGreen': 'Green (0-255)',
    'vedereColorBlue': 'Blue (0-255)',
    'vedereColorButton': 'Name color',
    'vedereColorResultPrefix': 'Nearest match:',
    'sentireNote':
        'Shows transcript summarization and sound alert mapping, already real and tested. Live captioning and real sound classification need a microphone and models not implemented yet.',
    'sentireSummaryTitle': 'Transcript summarizer',
    'sentireSummaryHint': 'Paste transcript-like text',
    'sentireSummaryButton': 'Summarize',
    'sentireSummaryEmpty': 'No sentences recognized in this text.',
    'sentireAlertTitle': 'Sound alert presentation',
    'sentireAlertButton': 'Show presentation',
    'sentireAlertResult':
        'Vibration: {pattern} ms. Flash: {flash}. Severity: {severity}.',
    'protezioneNote':
        'Shows the scam filter, fall detection, and SOS, already real and tested. SOS uses a fake message sender: it can never send a real message. Fall detection uses simulated accelerometer data, not a live sensor.',
    'protezioneScamTitle': 'Scam message checker',
    'protezioneScamHint': 'Paste a message',
    'protezioneScamButton': 'Check message',
    'protezioneFallTitle': 'Fall detection',
    'protezioneFallSteadyButton': 'Simulate steady readings',
    'protezioneFallSimulateButton': 'Simulate a fall',
    'protezioneFallNotDetected': 'No fall detected.',
    'protezioneFallDetected': 'Fall detected.',
    'protezioneSosTitle': 'Emergency SOS',
    'protezioneSosIdle': 'No SOS in progress.',
    'protezioneSosCountdown': 'Counting down, you can still cancel.',
    'protezioneSosSent':
        'Message ready to send (fake sender, no real SMS sent).',
    'protezioneSosCancelled': 'SOS cancelled.',
    'protezioneSosStartButton': 'Start SOS',
    'protezioneSosCancelButton': 'Cancel',
    'famigliaNote':
        'Shows pairing code generation, the shared calendar, and daily status, already real and tested. Actual sync to a caregiver device through lumen-server is not wired up yet.',
    'famigliaPairingTitle': 'Caregiver pairing code',
    'famigliaPairingButton': 'Generate code',
    'famigliaPairingResult': 'Code: {code} (valid for {minutes} minutes)',
    'famigliaCalendarTitle': 'Shared calendar',
    'famigliaCalendarTitleHint': 'Event title',
    'famigliaCalendarMinutesHint': 'Minutes from now',
    'famigliaCalendarButton': 'Add event',
    'famigliaStatusTitle': "Today's status",
    'famigliaStatusOkResult': "Today's status: all ok",
    'famigliaStatusAttentionResult': "Today's status: needs attention",
    'famigliaStatusUnknownResult': 'No status set for today yet.',
    'famigliaStatusOkButton': 'All ok',
    'famigliaStatusAttentionButton': 'Needs attention',
    'parlareNote':
        'Shows the phrase board and usage-ranked suggestions, already real and tested. Real text-to-speech output and pictogram images are not implemented yet.',
    'parlareCategoryNeeds': 'Needs',
    'parlareCategoryGreetings': 'Greetings',
    'parlareCategoryEmotions': 'Emotions',
    'parlareCategoryEmergency': 'Emergency',
    'parlareSuggestionsTitle': 'Top suggestions',
    'leggereNote':
        'Shows syllable splitting and spaced repetition (SM-2), already real and tested. Reading scanned text aloud and dyslexia-specific text adaptation are not implemented yet.',
    'leggereSyllableTitle': 'Syllable splitter',
    'leggereSyllableHint': 'Type a word or phrase',
    'leggereSyllableButton': 'Split into syllables',
    'leggereFlashcardTitle': 'Flashcard review',
    'leggereFlashcardPrompt': 'What is the capital of Italy?',
    'leggereFlashcardQualityHint':
        'How well did you recall it? (0 poor, 5 perfect)',
    'leggereFlashcardResult':
        'Next review in {days} day(s), easiness {ease}, {streak} successful review(s) in a row.',
    'ricordareNote':
        'Shows the consent-gated person directory and reminders, already real and tested. Real face recognition needs a camera and a model not implemented yet.',
    'ricordarePersonTitle': 'People to remember',
    'ricordarePersonNameHint': 'Name',
    'ricordarePersonRelationshipHint': 'Relationship',
    'ricordarePersonConsent': 'Consent to future recognition',
    'ricordarePersonButton': 'Add person',
    'ricordarePersonAdded': 'Person added.',
    'ricordareConsentGiven': 'consent given',
    'ricordareConsentNotGiven': 'consent not given',
    'ricordareReminderTitle': 'Reminders',
    'ricordareReminderTitleHint': 'Reminder',
    'ricordareReminderMinutesHint': 'Minutes from now',
    'ricordareReminderAddButton': 'Add reminder',
    'ricordareReminderCheckButton': 'Check due reminders',
    'ricordareReminderNoneDue': 'No reminders due.',
    'ricordareReminderDue': 'Due now: {titles}',
    'muoversiNote':
        'Shows gait stability monitoring over simulated data and the mobility profile, already real and tested. There is no live accelerometer sensor in this app yet.',
    'muoversiGaitTitle': 'Gait stability monitor',
    'muoversiGaitSteadyButton': 'Simulate steady walk',
    'muoversiGaitUnsteadyButton': 'Simulate unsteady walk',
    'muoversiGaitResult':
        '{irregular}. {steps} steps detected, {cadence} steps per minute.',
    'muoversiGaitIrregular': 'Irregular rhythm: possible stumble risk',
    'muoversiGaitSteady': 'Steady rhythm',
    'muoversiProfileTitle': 'Mobility profile',
    'muoversiAidNone': 'No aid',
    'muoversiAidCane': 'Cane',
    'muoversiAidWheelchair': 'Wheelchair',
    'muoversiAidWalker': 'Walker',
    'muoversiAidOther': 'Other',
    'muoversiVerbosityMinimal': 'Minimal',
    'muoversiVerbosityStandard': 'Standard',
    'muoversiVerbosityDetailed': 'Detailed',
    'muoversiProfileNotesHint': "Notes (required if 'Other')",
    'muoversiProfileButton': 'Save profile',
    'muoversiProfileSaved': 'Profile saved.',
  };

  /// Looks up [key], falling back to the English resource if a locale
  /// does not define it, and finally to the key itself as a last
  /// resort so a missing translation never crashes the app.
  String call(String key) => _values[key] ?? _en[key] ?? key;

  static const _delegateInstance = _AppStringsDelegate();

  /// The delegate to register in `MaterialApp.localizationsDelegates`.
  static LocalizationsDelegate<AppStrings> get delegate => _delegateInstance;

  /// Retrieves the [AppStrings] for the nearest [Localizations] in
  /// [context].
  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings)!;
  }

  static const supportedLocales = <Locale>[Locale('it'), Locale('en')];

  static AppStrings _forLocale(Locale locale) {
    return switch (locale.languageCode) {
      'it' => const AppStrings._(_it),
      _ => const AppStrings._(_en),
    };
  }
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales.any(
        (l) => l.languageCode == locale.languageCode,
      );

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings._forLocale(locale);

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
