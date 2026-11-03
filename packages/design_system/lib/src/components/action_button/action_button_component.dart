import 'package:flutter/material.dart';

import '../../foundations/app_color_tokens.dart';
import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import 'action_button_view_model.dart';

/// Component: só DESENHA o [ActionButtonViewModel]. Nenhuma regra aqui.
class ActionButtonComponent extends StatelessWidget {
  const ActionButtonComponent({super.key, required this.viewModel});

  final ActionButtonViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final spec = _ButtonSpec.of(viewModel, context.colors);

    return Semantics(
      button: true,
      enabled: viewModel.isInteractive,
      label: viewModel.semanticLabel ?? viewModel.label,
      child: SizedBox(
        width: viewModel.isIconOnly ? spec.height : (viewModel.expand ? double.infinity : null),
        height: spec.height,
        child: Material(
          color: spec.background,
          shape: spec.shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: viewModel.isInteractive ? viewModel.onPressed : null,
            child: Padding(
              padding: spec.padding,
              child: Center(child: _ButtonContent(viewModel: viewModel, spec: spec)),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({required this.viewModel, required this.spec});

  final ActionButtonViewModel viewModel;
  final _ButtonSpec spec;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading) {
      return SizedBox.square(
        dimension: spec.iconSize,
        child: CircularProgressIndicator(strokeWidth: 2, color: spec.foreground),
      );
    }
    if (viewModel.isIconOnly) {
      return Icon(viewModel.icon, size: spec.iconSize, color: spec.foreground);
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (viewModel.icon != null) ...[
          Icon(viewModel.icon, size: spec.iconSize, color: spec.foreground),
          const SizedBox(width: AppSpacing.xxs),
        ],
        Flexible(
          child: Text(
            viewModel.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: spec.textStyle.copyWith(color: spec.foreground),
          ),
        ),
      ],
    );
  }
}

/// Resolve medidas e cores fora do `build()` (mínimo de lógica na view).
class _ButtonSpec {
  const _ButtonSpec({
    required this.height,
    required this.iconSize,
    required this.padding,
    required this.shape,
    required this.background,
    required this.foreground,
    required this.textStyle,
  });

  final double height;
  final double iconSize;
  final EdgeInsets padding;
  final ShapeBorder shape;
  final Color background;
  final Color foreground;
  final TextStyle textStyle;

  factory _ButtonSpec.of(ActionButtonViewModel vm, AppColorTokens c) {
    final disabled = !vm.isEnabled;
    final iconOnly = vm.isIconOnly;

    final double height = switch ((vm.size, iconOnly)) {
      (ActionButtonSize.small, true) => 32,
      (ActionButtonSize.medium, true) => 44,
      (ActionButtonSize.large, true) => 52,
      (ActionButtonSize.small, false) => 28,
      (ActionButtonSize.medium, false) => 44,
      (ActionButtonSize.large, false) => 56,
    };

    final double radius = switch ((vm.style, vm.size)) {
      (ActionButtonStyle.outline, _) => AppRadius.pill,
      (_, ActionButtonSize.small) => AppRadius.sm,
      (_, ActionButtonSize.medium) => AppRadius.md,
      (_, ActionButtonSize.large) => iconOnly ? AppRadius.md : AppRadius.lg,
    };

    final (Color bg, Color fg, BorderSide side) = switch (vm.style) {
      ActionButtonStyle.primary => (
          disabled ? c.border : c.primary,
          disabled ? c.textSecondary : c.onPrimary,
          BorderSide.none,
        ),
      ActionButtonStyle.secondary => (
          disabled ? c.border : c.textPrimary,
          disabled ? c.textSecondary : c.surface,
          BorderSide.none,
        ),
      ActionButtonStyle.outline => (
          c.surface,
          disabled ? c.textSecondary : c.textBody,
          BorderSide(color: c.outline),
        ),
      ActionButtonStyle.ghost => (
          Colors.transparent,
          disabled ? c.textSecondary : c.textPrimary,
          BorderSide.none,
        ),
      ActionButtonStyle.hero => (
          c.heroSurface,
          disabled ? c.textSecondary : c.onHero,
          BorderSide.none,
        ),
    };

    return _ButtonSpec(
      height: height,
      iconSize: switch (vm.size) {
        ActionButtonSize.small => iconOnly ? 16 : 14,
        ActionButtonSize.medium => 20,
        ActionButtonSize.large => 20,
      },
      padding: iconOnly
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(horizontal: vm.size == ActionButtonSize.small ? 12 : 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: side,
      ),
      background: bg,
      foreground: fg,
      textStyle: vm.size == ActionButtonSize.small ? AppTypography.buttonSmall : AppTypography.button,
    );
  }
}
