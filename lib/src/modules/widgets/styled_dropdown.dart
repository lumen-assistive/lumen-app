import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// A dropdown drawn like the app's text fields: a raised, rounded,
/// bordered box instead of Material's bare underlined control, so
/// choices and text inputs read as one family on module screens.
class StyledDropdown<T> extends StatelessWidget {
  const StyledDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isExpanded = true,
  });

  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: isExpanded,
          value: value,
          items: items,
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(18),
          dropdownColor: AppColors.surfaceRaised,
          icon: const Icon(Icons.expand_more_rounded),
          iconEnabledColor: AppColors.muted,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
