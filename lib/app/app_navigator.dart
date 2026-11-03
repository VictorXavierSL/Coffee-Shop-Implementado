import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Navegação global usada pelos Coordinators.
///
/// Com a `navigatorKey`, o Coordinator navega sem precisar de um
/// `BuildContext` — por isso ele pode ser trocado por um fake nos testes.
abstract final class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static NavigatorState get _nav => navigatorKey.currentState!;

  /// Abre uma tela e espera um resultado ao voltar (`push<bool>` etc.).
  static Future<T?> push<T>(Widget screen) => _nav.push<T>(_route<T>(screen));

  /// Troca a tela atual pela nova.
  static Future<void> replace(Widget screen) => _nav.pushReplacement(_route<void>(screen));

  /// Limpa a pilha e começa um novo fluxo (login → home, logout → login).
  static Future<void> resetTo(Widget screen) =>
      _nav.pushAndRemoveUntil(_route<void>(screen), (_) => false);

  static void pop<T>([T? result]) => _nav.pop<T>(result);

  /// Helper `showAppMessage`: SnackBar a partir de qualquer Coordinator.
  static void showAppMessage(AppMessageViewModel message) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    AppMessageComponent.show(context, message);
  }

  static Route<T> _route<T>(Widget screen) => MaterialPageRoute<T>(builder: (_) => screen);
}
