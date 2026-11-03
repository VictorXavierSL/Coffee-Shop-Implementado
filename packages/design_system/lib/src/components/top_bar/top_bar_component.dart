import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import '../action_button/action_button_component.dart';
import 'top_bar_view_model.dart';

class TopBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const TopBarComponent({super.key, required this.viewModel});

  final TopBarViewModel viewModel;

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    const slot = SizedBox(width: 44, height: 44);
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 8),
        child: Row(
          children: [
            if (viewModel.leading != null) ActionButtonComponent(viewModel: viewModel.leading!) else slot,
            Expanded(
              child: Text(
                viewModel.title,
                textAlign: TextAlign.center,
                style: AppTypography.title.copyWith(color: context.colors.textPrimary, height: 1.2),
              ),
            ),
            if (viewModel.trailing != null) ActionButtonComponent(viewModel: viewModel.trailing!) else slot,
          ],
        ),
      ),
    );
  }
}
