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
    'onboardingQuestionSafetyTitle': 'Vuoi funzioni di sicurezza come il rilevamento delle cadute e il SOS di emergenza?',
    'onboardingQuestionCaregiverTitle': 'Stai configurando questa app per una persona cara, o vuoi che un familiare resti informato?',
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
    'settingsDisclaimerBody': 'Lumen aiuta ma non sostituisce un medico o il numero di emergenza 112, e non e un dispositivo medico certificato.',
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
    'moduleDescriptionVedere': 'Descrizione di scene, lettura di testi e date di scadenza tramite la fotocamera.',
    'moduleDescriptionSentire': 'Sottotitoli e avvisi sonori offline.',
    'moduleDescriptionProtezione':
        'Rilevamento cadute, SOS di emergenza e filtro truffe.',
    'moduleDescriptionFamiglia':
        'Configurazione remota e stato condiviso con i familiari.',
    'uiModeVoiceFirstHighContrast': 'Vocale, massimo contrasto',
    'uiModeVisualWithVibration': 'Visiva, con vibrazione',
    'uiModeSimple': 'Semplice',
    'uiModeComplete': 'Completa',
  };

  static const _en = <String, String>{
    'appTitle': 'Lumen',
    'onboardingTitle': 'Who are you?',
    'onboardingNext': 'Next',
    'onboardingFinish': 'Finish',
    'onboardingQuestionVisionTitle': 'Do you have difficulty seeing clearly?',
    'onboardingQuestionHearingTitle': 'Do you have difficulty hearing?',
    'onboardingQuestionSafetyTitle': 'Would you like safety features such as fall detection and emergency SOS?',
    'onboardingQuestionCaregiverTitle': 'Are you setting this up for a loved one, or do you want a family member kept informed?',
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
    'settingsDisclaimerBody': 'Lumen helps but does not replace a doctor or the 112 emergency number, and is not a certified medical device.',
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
    'moduleDescriptionVedere': 'Scene description, text reading, and expiry date lookup via the camera.',
    'moduleDescriptionSentire': 'Offline captions and sound alerts.',
    'moduleDescriptionProtezione':
        'Fall detection, emergency SOS, and scam filtering.',
    'moduleDescriptionFamiglia':
        'Remote configuration and shared status with family members.',
    'uiModeVoiceFirstHighContrast': 'Voice-first, high contrast',
    'uiModeVisualWithVibration': 'Visual, with vibration',
    'uiModeSimple': 'Simple',
    'uiModeComplete': 'Complete',
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
