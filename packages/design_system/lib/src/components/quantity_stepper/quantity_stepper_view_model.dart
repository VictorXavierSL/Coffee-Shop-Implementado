import 'package:flutter/widgets.dart';

/// Seletor de quantidade "(−) 1 (+)" da tela Order.
@immutable
class QuantityStepperViewModel {
  const QuantityStepperViewModel({
    required this.value,
    this.min = 0,
    this.max = 99,
    this.onIncrement,
    this.onDecrement,
  });

  final int value;
  final int min;
  final int max;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  bool get canIncrement => value < max && onIncrement != null;
  bool get canDecrement => value > min && onDecrement != null;
}
