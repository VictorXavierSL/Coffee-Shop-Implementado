import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import 'segmented_control_view_model.dart';

class SegmentedControlComponent extends StatelessWidget {
  const SegmentedControlComponent({super.key, required this.viewModel});

  final SegmentedControlViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxs),
      decoration: BoxDecoration(
        color: c.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          for (var i = 0; i < viewModel.options.length; i++)
            Expanded(
              child: _Segment(
                label: viewModel.options[i],
                selected: i == viewModel.selectedIndex,
                onTap: viewModel.onChanged == null ? null : () => viewModel.onChanged!(i),
              ),
            ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.selected, this.onTap});

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = (selected ? AppTypography.title : AppTypography.body.copyWith(fontSize: 16))
        .copyWith(color: selected ? c.onPrimary : c.textPrimary, height: 1.2);

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? c.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: onTap,
          child: Container(
            height: 35,
            alignment: Alignment.center,
            child: Text(label, style: style),
          ),
        ),
      ),
    );
  }
}
