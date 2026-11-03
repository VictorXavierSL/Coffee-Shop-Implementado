import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import 'action_tile_view_model.dart';

class ActionTileComponent extends StatelessWidget {
  const ActionTileComponent({super.key, required this.viewModel});

  final ActionTileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: viewModel.isBordered ? c.surface : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: viewModel.isBordered ? BorderSide(color: c.surfaceVariant) : BorderSide.none,
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: viewModel.onTap,
        child: Padding(
          padding: viewModel.isBordered
              ? const EdgeInsets.all(AppSpacing.md)
              : const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Row(
            children: [
              Icon(viewModel.icon, size: 20, color: c.primary),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(viewModel.title, style: AppTypography.titleSmall.copyWith(color: c.textBody)),
                    if (viewModel.subtitle != null)
                      Text(viewModel.subtitle!, style: AppTypography.captionStrong.copyWith(color: c.primary)),
                  ],
                ),
              ),
              if (viewModel.trailingIcon != null)
                Icon(viewModel.trailingIcon, size: 20, color: c.textPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
