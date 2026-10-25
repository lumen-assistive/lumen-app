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
    'moduleNameVision': 'Vedere',
    'moduleNameHearing': 'Sentire',
    'moduleNameSafety': 'Protezione',
    'moduleNameFamily': 'Famiglia e caregiver',
    'moduleDescriptionVision':
        'Descrizione di scene, lettura di testi e date di scadenza tramite la fotocamera.',
    'moduleDescriptionHearing': 'Sottotitoli e avvisi sonori offline.',
    'moduleDescriptionSafety':
        'Rilevamento cadute, SOS di emergenza e filtro truffe.',
    'moduleDescriptionFamily':
        'Configurazione remota e stato condiviso con i familiari.',
    'moduleNameSpeech': 'Parlare',
    'moduleDescriptionSpeech':
        'Bacheca di frasi rapide con suggerimenti basati sull\'uso.',
    'moduleNameReading': 'Leggere e Studiare',
    'moduleDescriptionReading':
        'Divisione in sillabe e ripetizione dilazionata per lo studio.',
    'moduleNameMemory': 'Ricordare',
    'moduleDescriptionMemory': 'Rubrica con consenso e promemoria ricorrenti.',
    'moduleNameMobility': 'Muoversi',
    'moduleDescriptionMobility':
        'Monitoraggio dell\'andatura e profilo di mobilita.',
    'uiModeVoiceFirstHighContrast': 'Vocale, massimo contrasto',
    'uiModeVisualWithVibration': 'Visiva, con vibrazione',
    'uiModeSimple': 'Semplice',
    'uiModeComplete': 'Completa',
    'visionNote':
        'Mostra il lettore di date di scadenza e il riconoscimento colore, gia reali e testati. Descrizione di scene, banconote, medicinali e ostacoli richiedono fotocamera e modelli visivi non ancora implementati.',
    'visionExpiryTitle': 'Lettore di date di scadenza',
    'visionExpiryHint': 'Incolla un testo come letto da un\'etichetta',
    'visionExpiryButton': 'Trova la data di scadenza',
    'visionExpiryFound': 'Data di scadenza trovata: {date}',
    'visionExpiryNotFound': 'Nessuna data di scadenza riconosciuta.',
    'visionColorTitle': 'Riconoscimento colore',
    'visionColorRed': 'Rosso (0-255)',
    'visionColorGreen': 'Verde (0-255)',
    'visionColorBlue': 'Blu (0-255)',
    'visionColorButton': 'Riconosci colore',
    'visionColorResultPrefix': 'Colore piu vicino:',
    'visionContrastTitle': 'Controllo contrasto WCAG',
    'visionContrastHint':
        'Controlla il contrasto del colore sopra su sfondo bianco e nero.',
    'visionContrastButton': 'Controlla contrasto',
    'visionContrastResult':
        'Su bianco: {whiteRatio}:1 (AA: {whitePass}). Su nero: {blackRatio}:1 (AA: {blackPass}).',
    'hearingNote':
        'Mostra il riassunto di un testo e la mappatura degli avvisi sonori, gia reali e testati. I sottotitoli dal vivo e la classificazione dei suoni richiedono un microfono e modelli non ancora implementati.',
    'hearingSummaryTitle': 'Riassunto trascrizione',
    'hearingSummaryHint': 'Incolla un testo trascritto',
    'hearingSummaryButton': 'Riassumi',
    'hearingSummaryEmpty': 'Nessuna frase riconosciuta in questo testo.',
    'hearingCaptionTitle': 'Formattazione sottotitoli',
    'hearingCaptionHint':
        'Divide il testo trascritto sopra in righe della lunghezza di un sottotitolo.',
    'hearingCaptionButton': 'Formatta come sottotitoli',
    'hearingAlertTitle': 'Presentazione avviso sonoro',
    'hearingAlertButton': 'Mostra presentazione',
    'hearingAlertResult':
        'Vibrazione: {pattern} ms. Flash: {flash}. Gravita: {severity}.',
    'safetyNote':
        'Mostra il filtro truffe, il rilevamento cadute e l\'SOS, gia reali e testati. L\'SOS usa un mittente SMS finto: non puo mai inviare un messaggio vero. Il rilevamento cadute usa dati accelerometrici simulati, non un sensore dal vivo.',
    'safetyScamTitle': 'Controllo messaggi truffa',
    'safetyScamHint': 'Incolla un messaggio',
    'safetyScamButton': 'Controlla messaggio',
    'safetyFallTitle': 'Rilevamento cadute',
    'safetyFallSteadyButton': 'Simula movimento normale',
    'safetyFallSimulateButton': 'Simula una caduta',
    'safetyFallNotDetected': 'Nessuna caduta rilevata.',
    'safetyFallDetected': 'Caduta rilevata.',
    'safetyCheckInTitle': 'Controllo periodico',
    'safetyCheckInHint':
        'Conferma di stare bene ogni 12 ore. Se non lo fai, il controllo risulta scaduto.',
    'safetyCheckInButton': 'Conferma ora',
    'safetyCheckInStatusButton': 'Controlla stato',
    'safetyCheckInOk': 'Tutto a posto, nessun controllo scaduto.',
    'safetyCheckInOverdue': 'Controllo scaduto: nessuna conferma recente.',
    'safetySosTitle': 'SOS di emergenza',
    'safetySosIdle': 'Nessun SOS in corso.',
    'safetySosCountdown': 'Conto alla rovescia in corso, puoi annullare.',
    'safetySosSent':
        'Messaggio pronto per l\'invio (mittente finto, nessun SMS reale inviato).',
    'safetySosCancelled': 'SOS annullato.',
    'safetySosStartButton': 'Avvia SOS',
    'safetySosCancelButton': 'Annulla',
    'familyNote':
        'Mostra la generazione di codici di accoppiamento, il calendario e lo stato giornaliero, gia reali e testati. La sincronizzazione effettiva con un dispositivo caregiver tramite lumen-server non e ancora collegata.',
    'familyPairingTitle': 'Codice di accoppiamento caregiver',
    'familyPairingButton': 'Genera codice',
    'familyPairingResult': 'Codice: {code} (valido {minutes} minuti)',
    'familyCalendarTitle': 'Calendario condiviso',
    'familyCalendarTitleHint': 'Titolo evento',
    'familyCalendarMinutesHint': 'Minuti da adesso',
    'familyCalendarButton': 'Aggiungi evento',
    'familyStatusTitle': 'Stato di oggi',
    'familyStatusOkResult': 'Stato di oggi: tutto ok',
    'familyStatusAttentionResult': 'Stato di oggi: serve attenzione',
    'familyStatusUnknownResult': 'Nessuno stato impostato per oggi.',
    'familyStatusOkButton': 'Tutto ok',
    'familyStatusAttentionButton': 'Serve attenzione',
    'familyNotificationTitle': 'Notifica per il caregiver',
    'familyNotificationHint':
        'Componi il testo della notifica dallo stato di oggi e dagli eventi aggiunti sopra.',
    'familyNotificationButton': 'Componi notifica',
    'speechNote':
        'Mostra la bacheca di frasi e i suggerimenti basati sull\'uso, gia reali e testati. La sintesi vocale reale e le immagini dei simboli non sono ancora implementate.',
    'speechCategoryNeeds': 'Bisogni',
    'speechCategoryGreetings': 'Saluti',
    'speechCategoryEmotions': 'Emozioni',
    'speechCategoryEmergency': 'Emergenza',
    'speechSuggestionsTitle': 'Suggerimenti principali',
    'speechSentenceTitle': 'Costruisci una frase',
    'speechSentenceHint':
        'Le frasi toccate sopra si aggiungono qui. Componile in una frase unica.',
    'speechSentenceBuildButton': 'Componi frase',
    'speechSentenceClearButton': 'Cancella',
    'readingNote':
        'Mostra la divisione in sillabe e la ripetizione dilazionata (SM-2), gia reali e testate. La lettura ad alta voce di testo scansionato e l\'adattamento specifico per la dislessia non sono ancora implementati.',
    'readingSyllableTitle': 'Divisione in sillabe',
    'readingSyllableHint': 'Scrivi una parola o frase',
    'readingSyllableButton': 'Dividi in sillabe',
    'readingFlashcardTitle': 'Ripasso con flashcard',
    'readingFlashcardPrompt': 'Qual e la capitale d\'Italia?',
    'readingFlashcardQualityHint':
        'Quanto bene te la ricordavi? (0 scarso, 5 perfetto)',
    'readingFlashcardResult':
        'Prossimo ripasso tra {days} giorno/i, facilita {ease}, {streak} ripasso/i corretti di fila.',
    'readingTimeTitle': 'Tempo di lettura stimato',
    'readingTimeHint': 'Incolla un testo da stimare',
    'readingTimeButton': 'Stima tempo di lettura',
    'readingTimeResult': 'Tempo di lettura stimato: {minutes} minuto/i.',
    'memoryNote':
        'Mostra la rubrica con consenso e i promemoria, gia reali e testati. Il riconoscimento facciale reale richiede fotocamera e modello non ancora implementati.',
    'memoryPersonTitle': 'Persone da ricordare',
    'memoryPersonNameHint': 'Nome',
    'memoryPersonRelationshipHint': 'Relazione',
    'memoryPersonConsent': 'Consenso al riconoscimento futuro',
    'memoryPersonButton': 'Aggiungi persona',
    'memoryPersonAdded': 'Persona aggiunta.',
    'memoryConsentGiven': 'consenso dato',
    'memoryConsentNotGiven': 'consenso non dato',
    'memoryReminderTitle': 'Promemoria',
    'memoryReminderTitleHint': 'Promemoria',
    'memoryReminderMinutesHint': 'Minuti da adesso',
    'memoryReminderAddButton': 'Aggiungi promemoria',
    'memoryReminderCheckButton': 'Controlla scadenze',
    'memoryReminderNoneDue': 'Nessun promemoria scaduto.',
    'memoryReminderDue': 'In scadenza: {titles}',
    'memoryRoutineTitle': 'Rituale giornaliero',
    'memoryRoutineHint': 'Si azzera ogni giorno a mezzanotte.',
    'memoryRoutineStepMedication': 'Prendere la medicina del mattino',
    'memoryRoutineStepLockDoor': 'Chiudere la porta a chiave',
    'memoryRoutineComplete': 'Rituale completato per oggi.',
    'memoryRoutineRemaining': 'Ancora da fare: {steps}',
    'mobilityNote':
        'Mostra il monitoraggio della stabilita dell\'andatura su dati simulati e il profilo di mobilita, gia reali e testati. Non c\'e ancora un sensore accelerometrico dal vivo in questa app.',
    'mobilityGaitTitle': 'Monitoraggio andatura',
    'mobilityGaitSteadyButton': 'Simula camminata regolare',
    'mobilityGaitUnsteadyButton': 'Simula camminata irregolare',
    'mobilityGaitResult':
        '{irregular}. {steps} passi rilevati, {cadence} passi al minuto.',
    'mobilityGaitIrregular': 'Ritmo irregolare: possibile rischio di inciampo',
    'mobilityGaitSteady': 'Ritmo regolare',
    'mobilityProfileTitle': 'Profilo di mobilita',
    'mobilityAidNone': 'Nessun ausilio',
    'mobilityAidCane': 'Bastone',
    'mobilityAidWheelchair': 'Sedia a rotelle',
    'mobilityAidWalker': 'Deambulatore',
    'mobilityAidOther': 'Altro',
    'mobilityVerbosityMinimal': 'Essenziale',
    'mobilityVerbosityStandard': 'Standard',
    'mobilityVerbosityDetailed': 'Dettagliata',
    'mobilityProfileNotesHint': 'Note (richieste se \'Altro\')',
    'mobilityProfileButton': 'Salva profilo',
    'mobilityProfileSaved': 'Profilo salvato.',
    'mobilityBreaksTitle': 'Pianifica le pause',
    'mobilityBreaksHint':
        'Suggerisce le pause in base alla durata della camminata e al livello di dettaglio scelto sopra.',
    'mobilityBreaksMinutesHint': 'Durata camminata (minuti)',
    'mobilityBreaksButton': 'Pianifica pause',
    'mobilityBreaksNone':
        'Nessuna pausa necessaria per una camminata cosi breve.',
    'mobilityBreaksResult': 'Pause consigliate al minuto: {minutes}',
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
        'Shows transcript summarization and sound alert mapping, already real and tested. Live captioning and real sound classification need a microphone and models not implemented yet.',
    'hearingSummaryTitle': 'Transcript summarizer',
    'hearingSummaryHint': 'Paste transcript-like text',
    'hearingSummaryButton': 'Summarize',
    'hearingSummaryEmpty': 'No sentences recognized in this text.',
    'hearingCaptionTitle': 'Caption formatting',
    'hearingCaptionHint':
        'Wraps the transcript above into caption-sized lines.',
    'hearingCaptionButton': 'Format as captions',
    'hearingAlertTitle': 'Sound alert presentation',
    'hearingAlertButton': 'Show presentation',
    'hearingAlertResult':
        'Vibration: {pattern} ms. Flash: {flash}. Severity: {severity}.',
    'safetyNote':
        'Shows the scam filter, fall detection, and SOS, already real and tested. SOS uses a fake message sender: it can never send a real message. Fall detection uses simulated accelerometer data, not a live sensor.',
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
        'Shows pairing code generation, the shared calendar, and daily status, already real and tested. Actual sync to a caregiver device through lumen-server is not wired up yet.',
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
        'Shows the phrase board and usage-ranked suggestions, already real and tested. Real text-to-speech output and pictogram images are not implemented yet.',
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
    'readingNote':
        'Shows syllable splitting and spaced repetition (SM-2), already real and tested. Reading scanned text aloud and dyslexia-specific text adaptation are not implemented yet.',
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
        'Shows the consent-gated person directory and reminders, already real and tested. Real face recognition needs a camera and a model not implemented yet.',
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
        'Shows gait stability monitoring over simulated data and the mobility profile, already real and tested. There is no live accelerometer sensor in this app yet.',
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
