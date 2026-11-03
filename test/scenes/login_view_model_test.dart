import 'package:coffee_shop/scenes/login/login_coordinator.dart';
import 'package:coffee_shop/scenes/login/login_server.dart';
import 'package:coffee_shop/scenes/login/login_view_model.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fakes.dart';

class FakeLoginServer implements LoginServer {
  ApiException? error;
  int calls = 0;

  @override
  Future<User> login({required String email, required String password}) async {
    calls++;
    if (error != null) throw error!;
    return testUser;
  }
}

class FakeLoginCoordinator implements LoginCoordinator {
  int homeCalls = 0;
  final errors = <String>[];

  @override
  void goToHome() => homeCalls++;

  @override
  void showError(String message) => errors.add(message);
}

void main() {
  late FakeLoginServer server;
  late FakeLoginCoordinator coordinator;
  late LoginViewModel vm;

  setUp(() {
    server = FakeLoginServer();
    coordinator = FakeLoginCoordinator();
    vm = LoginViewModel(server: server, coordinator: coordinator);
  });

  test('e-mail inválido não chama o servidor', () async {
    vm.onEmailChanged('ana@');
    vm.onPasswordChanged('123456');
    await vm.submit();

    expect(server.calls, 0);
    expect(vm.emailError, isNotNull);
    expect(coordinator.homeCalls, 0);
  });

  test('senha curta mostra erro no campo', () async {
    vm.onEmailChanged('ana@coffee.dev');
    vm.onPasswordChanged('123');
    await vm.submit();

    expect(vm.passwordError, contains('6'));
    expect(vm.passwordField.errorText, vm.passwordError);
  });

  test('login válido navega para a Home', () async {
    vm.onEmailChanged('ana@coffee.dev');
    vm.onPasswordChanged('123456');
    await vm.submit();

    expect(server.calls, 1);
    expect(coordinator.homeCalls, 1);
    expect(vm.isLoading, isFalse);
  });

  test('credenciais erradas: mensagem do servidor e continua no login', () async {
    server.error = invalidCredentials;
    vm.onEmailChanged('ana@coffee.dev');
    vm.onPasswordChanged('errada1');
    await vm.submit();

    expect(coordinator.homeCalls, 0);
    expect(coordinator.errors, ['E-mail ou senha incorretos.']);
    expect(vm.formError, 'E-mail ou senha incorretos.');
  });

  test('botão desabilitado enquanto os campos estão vazios', () {
    expect(vm.submitButton.isEnabled, isFalse);
    vm.onEmailChanged('a@b.co');
    vm.onPasswordChanged('123456');
    expect(vm.submitButton.isEnabled, isTrue);
  });
}
