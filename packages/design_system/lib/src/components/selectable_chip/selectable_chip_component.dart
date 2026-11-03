import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import 'selectable_chip_view_model.dart';

class SelectableChipComponent extends StatelessWidget {
  const SelectableChipComponent({super.key, required this.viewModel});

  final SelectableChipViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final selected = viewModel.isSelected;
    final isSize = viewModel.shape == SelectableChipShape.size;

    final background = isSize
        ? (selected ? c.primaryContainer : c.surface)
        : (selected ? c.primary : c.surfaceVariant.withValues(alpha: 0.35));
    final foreground = isSize
        ? (selected ? c.primary : c.textPrimary)
        : (selected ? c.onPrimary : c.textBody);
    final textStyle = (isSize || !selected ? AppTypography.body : AppTypography.titleSmall)
        .copyWith(color: foreground);
    final radius = BorderRadius.circular(isSize ? AppRadius.md : AppRadius.xs);

    return Semantics(
      selected: selected,
      button: true,
      child: Opacity(
        opacity: viewModel.isEnabled ? 1 : 0.4,
        child: Material(
          color: background,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: isSize
                ? BorderSide(color: selected ? c.primary : c.border)
                : BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: viewModel.isEnabled ? viewModel.onSelected : null,
            child: Container(
              width: isSize ? 96 : null,
              height: isSize ? 41 : 29,
              padding: EdgeInsets.symmetric(horizontal: isSize ? 0 : AppSpacing.xs),
              alignment: Alignment.center,
              child: Text(viewModel.label, style: textStyle),
            ),
          ),
        ),
      ),
    );
  }
}
