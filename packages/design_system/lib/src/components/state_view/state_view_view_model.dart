import 'package:flutter/widgets.dart';

import '../action_button/action_button_view_model.dart';

enum StateViewKind { loading, empty, error }

/// Estados de tela "não feliz": carregando, vazio e erro.
@immutable
class StateViewViewModel {
  const StateViewViewModel({
    required this.kind,
    this.title,
    this.message,
    this.action,
  });

  final StateViewKind kind;
  final String? title;
  final String? message;
  final ActionButtonViewModel? action;
}
