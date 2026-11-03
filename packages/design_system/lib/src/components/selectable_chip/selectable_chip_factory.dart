import 'package:flutter/widgets.dart';

import 'selectable_chip_view_model.dart';

abstract final class SelectableChipFactory {
  /// Aba de categoria da Home (raio 6, preenchida quando ativa).
  static SelectableChipViewModel category({
    required String label,
    required bool isSelected,
    bool isEnabled = true,
    VoidCallback? onSelected,
  }) {
    return SelectableChipViewModel(
      label: label,
      shape: SelectableChipShape.category,
      isSelected: isSelected,
      isEnabled: isEnabled,
      onSelected: onSelected,
    );
  }

  /// Opção de tamanho do Detail (96×41, raio 12, contorno marrom quando ativa).
  static SelectableChipViewModel size({
    required String label,
    required bool isSelected,
    bool isEnabled = true,
    VoidCallback? onSelected,
  }) {
    return SelectableChipViewModel(
      label: label,
      shape: SelectableChipShape.size,
      isSelected: isSelected,
      isEnabled: isEnabled,
      onSelected: onSelected,
    );
  }
}
