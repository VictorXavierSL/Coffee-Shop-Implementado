import 'package:flutter/material.dart';

import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';

enum AppMessageKind { info, success, error }

/// ViewModel da mensagem rápida (SnackBar).
@immutable
class AppMessageViewModel {
  const AppMessageViewModel({required this.text, this.kind = AppMessageKind.info});

  final String text;
  final AppMessageKind kind;
}

abstract final class AppMessageFactory {
  static AppMessageViewModel info(String text) => AppMessageViewModel(text: text);

  static AppMessageViewModel success(String text) =>
      AppMessageViewModel(text: text, kind: AppMessageKind.success);

  static AppMessageViewModel error(String text) =>
      AppMessageViewModel(text: text, kind: AppMessageKind.error);
}

/// Component: transforma a ViewModel em `SnackBar` com as cores do tema.
abstract final class AppMessageComponent {
  static SnackBar snackBar(BuildContext context, AppMessageViewModel vm) {
    final c = context.colors;
    final (Color bg, IconData icon) = switch (vm.kind) {
      AppMessageKind.info => (c.textPrimary, Icons.info_outline_rounded),
      AppMessageKind.success => (c.success, Icons.check_circle_outline_rounded),
      AppMessageKind.error => (c.danger, Icons.error_outline_rounded),
    };
    return SnackBar(
      backgroundColor: bg,
      content: Row(
        children: [
          Icon(icon, color: c.background, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(vm.text, style: AppTypography.body.copyWith(color: c.background))),
        ],
      ),
    );
  }

  /// Atalho: mostra a mensagem no `ScaffoldMessenger` do contexto.
  static void show(BuildContext context, AppMessageViewModel vm) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar(context, vm));
  }
}
