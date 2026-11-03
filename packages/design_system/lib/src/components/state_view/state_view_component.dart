import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import '../action_button/action_button_component.dart';
import 'state_view_view_model.dart';

class StateViewComponent extends StatelessWidget {
  const StateViewComponent({super.key, required this.viewModel});

  final StateViewViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    if (viewModel.kind == StateViewKind.loading) {
      return Center(child: CircularProgressIndicator(color: c.primary));
    }

    final icon = viewModel.kind == StateViewKind.error
        ? Icons.cloud_off_rounded
        : Icons.local_cafe_outlined;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: c.textSecondary),
            const SizedBox(height: AppSpacing.md),
            if (viewModel.title != null)
              Text(
                viewModel.title!,
                textAlign: TextAlign.center,
                style: AppTypography.title.copyWith(color: c.textPrimary),
              ),
            if (viewModel.message != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                viewModel.message!,
                textAlign: TextAlign.center,
                style: AppTypography.body.copyWith(color: c.textSecondary),
              ),
            ],
            if (viewModel.action != null) ...[
              const SizedBox(height: AppSpacing.lg),
              ActionButtonComponent(viewModel: viewModel.action!),
            ],
          ],
        ),
      ),
    );
  }
}
