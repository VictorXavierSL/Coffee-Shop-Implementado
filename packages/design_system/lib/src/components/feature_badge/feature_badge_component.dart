import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import 'feature_badge_view_model.dart';

class FeatureBadgeComponent extends StatelessWidget {
  const FeatureBadgeComponent({super.key, required this.viewModel});

  final FeatureBadgeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Tooltip(
      message: viewModel.label,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: c.surfaceVariant.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Icon(viewModel.icon, size: 24, color: c.primary),
      ),
    );
  }
}
