import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import 'summary_row_view_model.dart';

class SummaryRowComponent extends StatelessWidget {
  const SummaryRowComponent({super.key, required this.viewModel});

  final SummaryRowViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final labelStyle = viewModel.isEmphasized
        ? AppTypography.title.copyWith(color: c.textPrimary)
        : AppTypography.body.copyWith(color: c.textBody);
    final valueStyle = (viewModel.isEmphasized ? AppTypography.title : AppTypography.titleSmall)
        .copyWith(color: viewModel.isEmphasized ? c.primary : c.textPrimary);

    return Row(
      children: [
        Expanded(child: Text(viewModel.label, style: labelStyle)),
        if (viewModel.previousValue != null) ...[
          Text(
            viewModel.previousValue!,
            style: AppTypography.body.copyWith(
              color: c.textBody,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        Text(viewModel.value, style: valueStyle),
      ],
    );
  }
}
