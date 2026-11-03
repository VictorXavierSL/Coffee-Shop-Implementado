import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';

import '../../app/safe_change_notifier.dart';
import 'login_coordinator.dart';
import 'login_server.dart';

/// Estado e ações da cena de login.
///
/// Tudo o que acontece na View chega aqui. A ViewModel valida, chama o
/// Server (troca de dados) e pede ao Coordinator a próxima tela.
class LoginViewModel extends ChangeNotifier with SafeChangeNotifier {
  LoginViewModel({required LoginServer server, required LoginCoordinator coordinator})
      : _server = server,
        _coordinator = coordinator;

  final LoginServer _server;
  final LoginCoordinator _coordinator;

  String _email = '';
  String _password = '';
  String? _emailError;
  String? _passwordError;
  String? _formError;
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get formError => _formError;
  bool get isLoading => _isLoading;
  bool get canSubmit => _email.isNotEmpty && _password.isNotEmpty && !_isLoading;

  final String demoHint =
      'Conta de demonstração: ${MockDatabase.demoEmail} · senha ${MockDatabase.demoPassword}';

  // --------------------------------------------------------------- eventos

  void onEmailChanged(String value) {
    _email = value.trim();
    _emailError = null;
    _formError = null;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _password = value;
    _passwordError = null;
    _formError = null;
    notifyListeners();
  }

  Future<void> submit() async {
    if (_isLoading) return;
    _emailError = Validators.email(_email);
    _passwordError = Validators.password(_password);
    if (_emailError != null || _passwordError != null) {
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      await _server.login(email: _email, password: _password);
      _coordinator.goToHome();
    } on ApiException catch (e) {
      _formError = e.message;
      _coordinator.showError(e.message);
    } finally {
      _setLoading(false);
    }
  }

  // ------------------------------------- ViewModels dos componentes do DS

  AppTextFieldViewModel get emailField => AppTextFieldFactory.email(
        errorText: _emailError,
        isEnabled: !_isLoading,
        onChanged: onEmailChanged,
      );

  AppTextFieldViewModel get passwordField => AppTextFieldFactory.password(
        errorText: _passwordError,
        isEnabled: !_isLoading,
        onChanged: onPasswordChanged,
        onSubmitted: (_) => submit(),
      );

  ActionButtonViewModel get submitButton => ActionButtonFactory.primary(
        label: 'Entrar',
        isLoading: _isLoading,
        isEnabled: canSubmit || _isLoading,
        onPressed: submit,
      );

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
