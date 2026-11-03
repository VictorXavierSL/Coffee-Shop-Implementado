import 'package:flutter/widgets.dart';

import 'quantity_stepper_view_model.dart';

abstract final class QuantityStepperFactory {
  /// Quantidade de um item do carrinho. Chegar a 0 remove o item.
  static QuantityStepperViewModel cartItem({
    required int quantity,
    VoidCallback? onIncrement,
    VoidCallback? onDecrement,
  }) {
    return QuantityStepperViewModel(
      value: quantity,
      min: 0,
      max: 20,
      onIncrement: onIncrement,
      onDecrement: onDecrement,
    );
  }
}
