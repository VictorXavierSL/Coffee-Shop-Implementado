import 'package:flutter/widgets.dart';

import '../quantity_stepper/quantity_stepper_view_model.dart';

/// Linha de produto no checkout ("Checkout Product" no Figma).
@immutable
class CartItemTileViewModel {
  const CartItemTileViewModel({
    required this.title,
    required this.subtitle,
    required this.stepper,
    this.imageSource,
  });

  final String title;

  /// Ex.: "Deep Foam · M".
  final String subtitle;
  final String? imageSource;

  /// Composição: o tile CONTÉM a ViewModel do stepper.
  final QuantityStepperViewModel stepper;
}
