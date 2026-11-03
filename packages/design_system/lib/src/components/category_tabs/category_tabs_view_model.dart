import 'package:flutter/widgets.dart';

/// Grupo horizontal de abas de categoria.
///
/// Componente COMPOSTO (Composite): é montado a partir de vários
/// `SelectableChipComponent` — não redesenha nada do zero.
@immutable
class CategoryTabsViewModel {
  const CategoryTabsViewModel({
    required this.labels,
    required this.selectedIndex,
    this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;
}
