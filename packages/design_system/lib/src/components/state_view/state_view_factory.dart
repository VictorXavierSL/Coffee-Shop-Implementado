import 'package:flutter/widgets.dart';

import '../action_button/action_button_factory.dart';
import 'state_view_view_model.dart';

abstract final class StateViewFactory {
  static const loading = StateViewViewModel(kind: StateViewKind.loading);

  static StateViewViewModel empty({
    required String title,
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return StateViewViewModel(
      kind: StateViewKind.empty,
      title: title,
      message: message,
      action: actionLabel == null
          ? null
          : ActionButtonFactory.primary(label: actionLabel, onPressed: onAction, expand: false),
    );
  }

  static StateViewViewModel error({required String message, VoidCallback? onRetry}) {
    return StateViewViewModel(
      kind: StateViewKind.error,
      title: 'Algo deu errado',
      message: message,
      action: onRetry == null
          ? null
          : ActionButtonFactory.primary(label: 'Tentar novamente', onPressed: onRetry, expand: false),
    );
  }
}
