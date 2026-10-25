import 'package:flutter/material.dart';

/// An honest, visible disclosure of what a module screen does and does
/// not demonstrate, shown at the top of every module screen.
///
/// Every plugin package already states this in its own README; this
/// widget surfaces the same honesty inside the app itself, rather than
/// only in a repository most users never read.
class ModuleNote extends StatelessWidget {
  const ModuleNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: colorScheme.onSecondaryContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: colorScheme.onSecondaryContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
