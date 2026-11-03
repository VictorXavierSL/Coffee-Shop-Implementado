import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import 'step_progress_view_model.dart';

class StepProgressComponent extends StatelessWidget {
  const StepProgressComponent({super.key, required this.viewModel});

  final StepProgressViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: 'Etapa ${viewModel.completedSteps} de ${viewModel.totalSteps}',
      child: Row(
        children: [
          for (var i = 0; i < viewModel.totalSteps; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            Expanded(
              child: AnimatedContainer(
                duration: AppDurations.normal,
                height: 4,
                decoration: BoxDecoration(
                  color: i < viewModel.completedSteps ? c.success : c.border,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
