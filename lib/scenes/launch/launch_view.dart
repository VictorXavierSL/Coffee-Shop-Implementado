import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'launch_view_model.dart';

class LaunchView extends StatefulWidget {
  const LaunchView({super.key, required this.viewModel});

  final LaunchViewModel viewModel;

  @override
  State<LaunchView> createState() => _LaunchViewState();
}

class _LaunchViewState extends State<LaunchView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.viewModel.start());
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [c.heroStart, c.heroEnd],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.coffee_rounded, size: 64, color: c.primary),
              const SizedBox(height: AppSpacing.md),
              Text('Coffee Shop', style: AppTypography.headline.copyWith(color: c.onHero)),
              const SizedBox(height: AppSpacing.lg),
              SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: c.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
