import 'package:flutter/material.dart';
import 'package:lumen_plugin_vision/lumen_plugin_vision.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Vedere (See) module screen.
///
/// Runs the real `ExpiryDateParser` and `ColorNamer` from
/// `lumen_plugin_vision`. Scene description, banknote and medicine
/// recognition, obstacle detection, and "find" mode all need a camera
/// bridge and vision models that do not exist in this app yet; see
/// `moduleNameVision`'s note below and the package README.
class VisionScreen extends StatefulWidget {
  const VisionScreen({super.key});

  @override
  State<VisionScreen> createState() => _VisionScreenState();
}

class _VisionScreenState extends State<VisionScreen> {
  final _expiryDateParser = ExpiryDateParser();
  final _colorNamer = ColorNamer();
  final ContrastChecker _contrastChecker = const ContrastChecker();

  final _expiryController = TextEditingController(
    text: 'Da consumarsi preferibilmente entro il 25/12/2026',
  );
  final _redController = TextEditingController(text: '225');
  final _greenController = TextEditingController(text: '25');
  final _blueController = TextEditingController(text: '15');

  String? _expiryResult;
  String? _colorResult;
  Color? _colorSwatch;
  String? _contrastResult;

  @override
  void dispose() {
    _expiryController.dispose();
    _redController.dispose();
    _greenController.dispose();
    _blueController.dispose();
    super.dispose();
  }

  void _runExpiryParser() {
    final strings = AppStrings.of(context);
    final result = _expiryDateParser.parse(_expiryController.text);
    setState(() {
      _expiryResult = result.isFound
          ? strings('visionExpiryFound').replaceAll(
              '{date}',
              '${result.date!.year}-${result.date!.month.toString().padLeft(2, '0')}-${result.date!.day.toString().padLeft(2, '0')}',
            )
          : strings('visionExpiryNotFound');
    });
  }

  void _runColorNamer() {
    final r = int.tryParse(_redController.text) ?? 0;
    final g = int.tryParse(_greenController.text) ?? 0;
    final b = int.tryParse(_blueController.text) ?? 0;
    final name = _colorNamer.nameOf(RgbColor(r, g, b));
    setState(() {
      _colorResult = name;
      _colorSwatch = Color.fromARGB(255, r, g, b);
    });
  }

  void _runContrastCheck() {
    final r = int.tryParse(_redController.text) ?? 0;
    final g = int.tryParse(_greenController.text) ?? 0;
    final b = int.tryParse(_blueController.text) ?? 0;
    final color = RgbColor(r, g, b);
    final onWhite =
        _contrastChecker.check(color, const RgbColor(255, 255, 255));
    final onBlack = _contrastChecker.check(color, const RgbColor(0, 0, 0));
    final strings = AppStrings.of(context);
    setState(() {
      _contrastResult = strings('visionContrastResult')
          .replaceAll('{whiteRatio}', onWhite.ratio.toStringAsFixed(2))
          .replaceAll(
            '{whitePass}',
            onWhite.passes(WcagLevel.aa)
                ? strings('answerYes')
                : strings('answerNo'),
          )
          .replaceAll('{blackRatio}', onBlack.ratio.toStringAsFixed(2))
          .replaceAll(
            '{blackPass}',
            onBlack.passes(WcagLevel.aa)
                ? strings('answerYes')
                : strings('answerNo'),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings('moduleNameVision'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('visionNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('visionExpiryTitle'),
            children: [
              TextField(
                controller: _expiryController,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: strings('visionExpiryHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runExpiryParser,
                  child: Text(strings('visionExpiryButton')),
                ),
              ),
              if (_expiryResult != null) ToolOutput(text: _expiryResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('visionColorTitle'),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _redController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: strings('visionColorRed'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _greenController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: strings('visionColorGreen'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _blueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: strings('visionColorBlue'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runColorNamer,
                  child: Text(strings('visionColorButton')),
                ),
              ),
              if (_colorResult != null)
                ToolOutput(
                  text: '${strings('visionColorResultPrefix')} $_colorResult',
                ),
              if (_colorSwatch != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _colorSwatch,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('visionContrastTitle'),
            children: [
              Text(strings('visionContrastHint')),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runContrastCheck,
                  child: Text(strings('visionContrastButton')),
                ),
              ),
              if (_contrastResult != null) ToolOutput(text: _contrastResult!),
            ],
          ),
        ],
      ),
    );
  }
}
