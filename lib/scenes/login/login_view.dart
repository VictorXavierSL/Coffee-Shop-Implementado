import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'login_view_model.dart';

/// A View só desenha o que a ViewModel expõe e repassa os eventos.
class LoginView extends StatefulWidget {
  const LoginView({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  LoginViewModel get vm => widget.viewModel;

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: vm,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xxl, AppSpacing.lg, AppSpacing.lg),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: c.primaryContainer,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Icon(Icons.coffee_rounded, color: c.primary, size: 32),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Entrar', style: AppTypography.display.copyWith(color: c.textPrimary, height: 1.2)),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Acesse sua conta para pedir seu café.',
                style: AppTypography.body.copyWith(color: c.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppTextFieldComponent(viewModel: vm.emailField),
              const SizedBox(height: AppSpacing.md),
              AppTextFieldComponent(viewModel: vm.passwordField),
              if (vm.formError != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(vm.formError!, style: AppTypography.caption.copyWith(color: c.danger)),
              ],
              const SizedBox(height: AppSpacing.lg),
              ActionButtonComponent(viewModel: vm.submitButton),
              const SizedBox(height: AppSpacing.md),
              Text(
                vm.demoHint,
                textAlign: TextAlign.center,
                style: AppTypography.caption.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
