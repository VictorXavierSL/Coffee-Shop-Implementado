import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import 'app_text_field_view_model.dart';

/// Campo de texto do Design System.
///
/// É `StatefulWidget` apenas por estado PURAMENTE visual (o controller do
/// texto e o "mostrar senha"). O valor digitado é delegado à ViewModel da
/// cena via `onChanged`.
class AppTextFieldComponent extends StatefulWidget {
  const AppTextFieldComponent({super.key, required this.viewModel});

  final AppTextFieldViewModel viewModel;

  @override
  State<AppTextFieldComponent> createState() => _AppTextFieldComponentState();
}

class _AppTextFieldComponentState extends State<AppTextFieldComponent> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.viewModel.initialValue);
  bool _obscured = true;

  AppTextFieldViewModel get _vm => widget.viewModel;
  bool get _isSearch => _vm.kind == AppTextFieldKind.search;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleObscured() => setState(() => _obscured = !_obscured);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final field = TextField(
      controller: _controller,
      enabled: _vm.isEnabled,
      obscureText: _vm.kind == AppTextFieldKind.password && _obscured,
      keyboardType: _vm.kind == AppTextFieldKind.email
          ? TextInputType.emailAddress
          : TextInputType.text,
      autocorrect: _vm.kind == AppTextFieldKind.text,
      textInputAction: _vm.textInputAction,
      onChanged: _vm.onChanged,
      onSubmitted: _vm.onSubmitted,
      style: AppTypography.body.copyWith(color: _isSearch ? c.onHero : c.textPrimary),
      decoration: _decoration(context),
    );

    if (_vm.label == null) return field;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_vm.label!, style: AppTypography.titleSmall.copyWith(color: c.textPrimary)),
        const SizedBox(height: AppSpacing.xs),
        field,
      ],
    );
  }

  InputDecoration _decoration(BuildContext context) {
    final c = context.colors;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: _isSearch ? BorderSide.none : BorderSide(color: color),
        );

    return InputDecoration(
      hintText: _vm.hint,
      hintStyle: AppTypography.body.copyWith(color: c.textSecondary),
      errorText: _vm.hasError ? _vm.errorText : null,
      errorStyle: AppTypography.caption.copyWith(color: c.danger),
      filled: true,
      fillColor: _isSearch ? c.heroSurface : c.surface,
      contentPadding: const EdgeInsets.all(AppSpacing.md),
      prefixIcon: _prefixIcon(context),
      suffixIcon: _suffixIcon(context),
      enabledBorder: border(c.border),
      disabledBorder: border(c.border),
      focusedBorder: border(c.primary),
      errorBorder: border(c.danger),
      focusedErrorBorder: border(c.danger),
    );
  }

  Widget? _prefixIcon(BuildContext context) {
    final c = context.colors;
    final icon = switch (_vm.kind) {
      AppTextFieldKind.email => Icons.mail_outline_rounded,
      AppTextFieldKind.password => Icons.lock_outline_rounded,
      AppTextFieldKind.search => Icons.search_rounded,
      AppTextFieldKind.text => null,
    };
    if (icon == null) return null;
    return Icon(icon, size: 20, color: _isSearch ? c.onHero : c.textSecondary);
  }

  Widget? _suffixIcon(BuildContext context) {
    if (_vm.kind != AppTextFieldKind.password) return null;
    return IconButton(
      onPressed: _toggleObscured,
      tooltip: _obscured ? 'Mostrar senha' : 'Ocultar senha',
      icon: Icon(
        _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 20,
        color: context.colors.textSecondary,
      ),
    );
  }
}
