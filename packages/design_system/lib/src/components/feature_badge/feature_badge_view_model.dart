import 'package:flutter/widgets.dart';

/// Ícone de diferencial do produto (Figma: "Superiority" no Detail).
@immutable
class FeatureBadgeViewModel {
  const FeatureBadgeViewModel({required this.icon, required this.label});

  final IconData icon;

  /// Mostrado como tooltip e lido por leitores de tela.
  final String label;
}
