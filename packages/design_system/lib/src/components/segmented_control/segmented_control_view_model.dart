import 'package:flutter/widgets.dart';

/// Alternador de opções mutuamente exclusivas ("Deliver" / "Pick Up").
@immutable
class SegmentedControlViewModel {
  const SegmentedControlViewModel({
    required this.options,
    required this.selectedIndex,
    this.onChanged,
  }) : assert(options.length >= 2);

  final List<String> options;
  final int selectedIndex;

  /// Delegate: recebe o índice escolhido.
  final ValueChanged<int>? onChanged;
}
