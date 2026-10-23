# lumen-app

Italiano | [English](README.md)

L'applicazione Flutter per [Lumen](https://github.com/lumen-assistive):
onboarding, interfaccia adattiva, host dei moduli, impostazioni e
archiviazione locale. Dipende da
[`lumen_sdk`](https://github.com/lumen-assistive/lumen-sdk) e
[`lumen_core`](https://github.com/lumen-assistive/lumen-core), entrambi
ancorati alla rispettiva versione `v0.1.0`.

## Cosa include questa versione

- **Onboarding**: un flusso di cinque domande (pulsanti grandi, alto
  contrasto, etichettati per lettori di schermo) che decide la
  modalita dell'interfaccia e quali moduli attivare, costruito
  interamente su `OnboardingController.computeOutcome`, una funzione
  pura interamente coperta da test.
- **Interfaccia adattiva**: quattro `UiMode` (vocale ad alto contrasto,
  visiva con vibrazione, semplice, completa), ciascuna con il proprio
  `ThemeData` chiaro e scuro costruito in `AppTheme`. Una palette
  originale (accento ambra caldo su neutri inchiostro/crema) — nessun
  gradiente, nessun glassmorphism, nessuna icona a emoji.
- **Host dei moduli**: una schermata principale che elenca i moduli
  attivati dall'utente, in modo generico, a partire dai metadati
  `ModuleInfo`.
- **Impostazioni**: cambio modalita interfaccia, scala dinamica del
  testo, attivazione e consenso per ciascun modulo, l'avviso medico e
  di sicurezza richiesto dal progetto, e una modalita sviluppatore che
  rivela una schermata diagnostica.
- **Archiviazione locale**: interfaccia `AppDatabase` con due
  implementazioni: `InMemoryAppDatabase` (usata da tutta la suite di
  test e, per ora, dall'app in esecuzione) e `SqlCipherAppDatabase`
  (codice pronto per la produzione con `sqflite_sqlcipher`, non ancora
  collegato in `main()`).
- **Localizzazione**: italiano come lingua predefinita, inglese come
  ripiego, tramite un piccolo delegate `AppStrings` scritto a mano.

## Cosa questa versione non include deliberatamente, e perche

- **Input vocale durante l'onboarding.** Ogni domanda si risponde con
  un tocco. Il vero input vocale richiede il riconoscimento vocale
  on-device tramite i ponti nativi di `lumen-core`, che non esistono
  ancora.
- **Schermate specifiche per ciascun modulo** (anteprima della
  fotocamera per Vedere, acquisizione audio per Sentire, eccetera). I
  pacchetti plugin a cui questa app si ispira
  (`lumen-plugin-vedere`, `-sentire`, `-protezione`, `-famiglia`)
  forniscono finora solo logica di business, senza una propria
  interfaccia Flutter.
- **Archiviazione cifrata duratura in esecuzione.**
  `SqlCipherAppDatabase` e implementato e pronto, ma `main()` funziona
  attualmente su `InMemoryAppDatabase`.
- **Vere richieste di permesso del sistema operativo.**
  `AppCapabilityGate` tiene traccia di un semplice insieme in memoria
  di permessi concessi, senza ancora chiamare alcuna API di permesso
  della piattaforma.
- **Una build di rilascio firmata.** Non esiste ancora un keystore di
  firma Android.
- **Test manuale con lettori di schermo.** TalkBack e VoiceOver non
  sono stati testati manualmente su questa app nell'ambiente in cui e
  stata costruita; vedi la versione inglese di questo file per il
  dettaglio completo.

## Sviluppo

Flutter non ha potuto essere verificato localmente nell'ambiente in
cui questo repository e stato costruito la prima volta. La correttezza
di questo repository e verificata dalla sua CI
(`flutter analyze`, `flutter test`) su runner ospitati da GitHub.

```
flutter pub get
flutter analyze --fatal-infos
flutter test
```

Installa l'hook condiviso per i messaggi di commit prima di fare commit:

```
git config core.hooksPath .githooks
```

Vedi [CONTRIBUTING.md](CONTRIBUTING.md) per il flusso di lavoro completo
(in inglese, come tutto il codice e la documentazione tecnica del
progetto).

## Licenza

Apache License 2.0, vedi [LICENSE](LICENSE).
