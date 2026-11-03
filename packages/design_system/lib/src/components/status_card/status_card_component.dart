import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import '../action_button/action_button_component.dart';
import 'status_card_view_model.dart';

class StatusCardComponent extends StatelessWidget {
  const StatusCardComponent({super.key, required this.viewModel});

  final StatusCardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: viewModel.isBordered ? const EdgeInsets.all(AppSpacing.sm) : EdgeInsets.zero,
      decoration: viewModel.isBordered
          ? BoxDecoration(
              color: c.surface,
              border: Border.all(color: c.surfaceVariant),
              borderRadius: BorderRadius.circular(AppRadius.md),
            )
          : null,
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: viewModel.isBordered ? c.surface : c.primaryContainer,
              border: viewModel.isBordered ? Border.all(color: c.surfaceVariant) : null,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(viewModel.icon, size: 32, color: c.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewModel.title, style: AppTypography.titleSmall.copyWith(color: c.textPrimary)),
                const SizedBox(height: AppSpacing.xxs),
                Text(viewModel.message, style: AppTypography.caption.copyWith(color: c.textSecondary, height: 1.5)),
              ],
            ),
          ),
          if (viewModel.trailing != null) ...[
            const SizedBox(width: AppSpacing.xs),
            ActionButtonComponent(viewModel: viewModel.trailing!),
          ],
        ],
      ),
    );
  }
}
