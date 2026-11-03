import 'package:flutter/widgets.dart';

/// Formato do item selecionável:
/// - [category] → aba de categoria da Home ("All Coffee", "Machiato"...).
/// - [size]     → opção de tamanho do Detail ("S", "M", "L").
enum SelectableChipShape { category, size }

/// Um item que PERTENCE A UM GRUPO de seleção. Diferente do botão (que
/// dispara uma ação), a semântica aqui é "estou selecionado ou não".
@immutable
class SelectableChipViewModel {
  const SelectableChipViewModel({
    required this.label,
    required this.shape,
    this.isSelected = false,
    this.isEnabled = true,
    this.onSelected,
  });

  final String label;
  final SelectableChipShape shape;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onSelected;

  SelectableChipViewModel copyWith({bool? isSelected, bool? isEnabled, VoidCallback? onSelected}) {
    return SelectableChipViewModel(
      label: label,
      shape: shape,
      isSelected: isSelected ?? this.isSelected,
      isEnabled: isEnabled ?? this.isEnabled,
      onSelected: onSelected ?? this.onSelected,
    );
  }
}
