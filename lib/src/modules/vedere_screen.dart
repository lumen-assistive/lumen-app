import 'package:flutter/material.dart';
import 'package:lumen_plugin_vedere/lumen_plugin_vedere.dart';

import '../l10n/app_strings.dart';
import 'widgets/module_note.dart';
import 'widgets/tool_card.dart';

/// Vedere (See) module screen.
///
/// Runs the real `ExpiryDateParser` and `ColorNamer` from
/// `lumen_plugin_vedere`. Scene description, banknote and medicine
/// recognition, obstacle detection, and "find" mode all need a camera
/// bridge and vision models that do not exist in this app yet; see
/// `moduleNameVedere`'s note below and the package README.
class VedereScreen extends StatefulWidget {
  const VedereScreen({super.key});

  @override
  State<VedereScreen> createState() => _VedereScreenState();
}

class _VedereScreenState extends State<VedereScreen> {
  final _expiryDateParser = ExpiryDateParser();
  final _colorNamer = ColorNamer();

  final _expiryController = TextEditingController(
    text: 'Da consumarsi preferibilmente entro il 25/12/2026',
  );
  final _redController = TextEditingController(text: '225');
  final _greenController = TextEditingController(text: '25');
  final _blueController = TextEditingController(text: '15');

  String? _expiryResult;
  String? _colorResult;
  Color? _colorSwatch;

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
          ? strings('vedereExpiryFound').replaceAll(
              '{date}',
              '${result.date!.year}-${result.date!.month.toString().padLeft(2, '0')}-${result.date!.day.toString().padLeft(2, '0')}',
            )
          : strings('vedereExpiryNotFound');
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

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings('moduleNameVedere'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ModuleNote(text: strings('vedereNote')),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('vedereExpiryTitle'),
            children: [
              TextField(
                controller: _expiryController,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: strings('vedereExpiryHint'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _runExpiryParser,
                  child: Text(strings('vedereExpiryButton')),
                ),
              ),
              if (_expiryResult != null) ToolOutput(text: _expiryResult!),
            ],
          ),
          const SizedBox(height: 16),
          ToolCard(
            title: strings('vedereColorTitle'),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _redController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: strings('vedereColorRed'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _greenController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: strings('vedereColorGreen'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _blueController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: strings('vedereColorBlue'),
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
                  child: Text(strings('vedereColorButton')),
                ),
              ),
              if (_colorResult != null)
                ToolOutput(
                  text: '${strings('vedereColorResultPrefix')} $_colorResult',
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
        ],
      ),
    );
  }
}
