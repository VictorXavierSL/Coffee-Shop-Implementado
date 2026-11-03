import 'package:flutter/material.dart';

import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import 'quantity_stepper_view_model.dart';

class QuantityStepperComponent extends StatelessWidget {
  const QuantityStepperComponent({super.key, required this.viewModel});

  final QuantityStepperViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundButton(
          icon: Icons.remove_rounded,
          label: 'Diminuir quantidade',
          onTap: viewModel.canDecrement ? viewModel.onDecrement : null,
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${viewModel.value}',
            textAlign: TextAlign.center,
            style: AppTypography.titleSmall.copyWith(color: c.textPrimary),
          ),
        ),
        _RoundButton(
          icon: Icons.add_rounded,
          label: 'Aumentar quantidade',
          onTap: viewModel.canIncrement ? viewModel.onIncrement : null,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.label, this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = onTap != null;
    return Semantics(
      button: true,
      label: label,
      enabled: enabled,
      child: Material(
        color: c.surface,
        shape: CircleBorder(side: BorderSide(color: c.primaryContainer)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(icon, size: 16, color: enabled ? c.textPrimary : c.textSecondary),
          ),
        ),
      ),
    );
  }
}
