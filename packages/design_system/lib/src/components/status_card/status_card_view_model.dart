import 'package:flutter/widgets.dart';

import '../action_button/action_button_view_model.dart';

/// Cartão com ícone em destaque, título e mensagem.
/// Figma "Delivery": "Delivered your order" e o card do entregador.
@immutable
class StatusCardViewModel {
  const StatusCardViewModel({
    required this.icon,
    required this.title,
    required this.message,
    this.trailing,
    this.isBordered = true,
  });

  final IconData icon;
  final String title;
  final String message;
  final ActionButtonViewModel? trailing;
  final bool isBordered;
}
