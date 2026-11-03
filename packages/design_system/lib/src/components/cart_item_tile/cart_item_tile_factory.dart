import 'package:flutter/widgets.dart';

import '../quantity_stepper/quantity_stepper_factory.dart';
import 'cart_item_tile_view_model.dart';

abstract final class CartItemTileFactory {
  static CartItemTileViewModel make({
    required String title,
    required String subtitle,
    required int quantity,
    String? imageSource,
    VoidCallback? onIncrement,
    VoidCallback? onDecrement,
  }) {
    return CartItemTileViewModel(
      title: title,
      subtitle: subtitle,
      imageSource: imageSource,
      stepper: QuantityStepperFactory.cartItem(
        quantity: quantity,
        onIncrement: onIncrement,
        onDecrement: onDecrement,
      ),
    );
  }
}
