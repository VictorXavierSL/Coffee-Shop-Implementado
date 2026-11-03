import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'onboarding_view_model.dart';

/// Figma: "High-Fidelity (Onboarding)". Tela de marca — sempre escura.
class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key, required this.viewModel});

  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: AppColors.greyDarkActive,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.sizeOf(context).height * 0.34,
            child: ProductImage(source: viewModel.imageSource, radius: 0),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.45, 0.62],
                  colors: [AppColors.greyDarkActive.withValues(alpha: 0), AppColors.greyDarkActive],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    viewModel.title,
                    textAlign: TextAlign.center,
                    style: AppTypography.display.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    viewModel.message,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(color: c.textSecondary, letterSpacing: 0.14),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ActionButtonComponent(viewModel: viewModel.startButton),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
