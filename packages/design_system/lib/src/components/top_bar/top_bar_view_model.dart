import 'package:flutter/widgets.dart';

import '../action_button/action_button_view_model.dart';

/// Cabeçalho de tela interna: voltar · título · ação (Figma: "Detail", "Order").
@immutable
class TopBarViewModel {
  const TopBarViewModel({required this.title, this.leading, this.trailing});

  final String title;
  final ActionButtonViewModel? leading;
  final ActionButtonViewModel? trailing;
}
