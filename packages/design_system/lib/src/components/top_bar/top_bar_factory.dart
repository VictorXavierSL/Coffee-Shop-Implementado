import 'package:flutter/widgets.dart';

import '../action_button/action_button_factory.dart';
import 'top_bar_view_model.dart';

abstract final class TopBarFactory {
  /// Voltar + título.
  static TopBarViewModel back({required String title, VoidCallback? onBack}) {
    return TopBarViewModel(title: title, leading: ActionButtonFactory.back(onPressed: onBack));
  }

  /// Voltar + título + favoritar (tela Detail).
  static TopBarViewModel detail({
    required String title,
    required bool isFavorite,
    VoidCallback? onBack,
    VoidCallback? onFavorite,
  }) {
    return TopBarViewModel(
      title: title,
      leading: ActionButtonFactory.back(onPressed: onBack),
      trailing: ActionButtonFactory.favorite(isFavorite: isFavorite, onPressed: onFavorite),
    );
  }
}
