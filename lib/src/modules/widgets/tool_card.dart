import 'package:flutter/material.dart';

/// A titled card grouping one real, interactive tool on a module
/// screen, so a screen with several tools reads as a clear set of
/// distinct capabilities rather than one undifferentiated form.
class ToolCard extends StatelessWidget {
  const ToolCard({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// A labeled, bordered box showing the result of running a tool, so a
/// result reads as distinct from the controls that produced it.
class ToolOutput extends StatelessWidget {
  const ToolOutput({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        border: Border(left: BorderSide(color: colorScheme.primary, width: 3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, semanticsLabel: text),
    );
  }
}
