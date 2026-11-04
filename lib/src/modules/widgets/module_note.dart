import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// An honest, visible disclosure of what a module screen does and does
/// not demonstrate, shown near the top of every module screen.
///
/// Every plugin package already states this in its own README; this
/// widget surfaces the same honesty inside the app itself, rather than
/// only in a repository most users never read. Deliberately quiet: a
/// muted outlined box, so it informs without competing with the tools
/// below it.
class ModuleNote extends StatelessWidget {
  const ModuleNote({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20, color: AppColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.muted, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
