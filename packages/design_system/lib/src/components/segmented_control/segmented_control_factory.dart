import 'package:flutter/widgets.dart';

import 'segmented_control_view_model.dart';

abstract final class SegmentedControlFactory {
  /// Tipo de entrega da tela Order.
  static SegmentedControlViewModel deliveryType({
    required bool isDelivery,
    ValueChanged<int>? onChanged,
    String deliverLabel = 'Entregar',
    String pickUpLabel = 'Retirar',
  }) {
    return SegmentedControlViewModel(
      options: [deliverLabel, pickUpLabel],
      selectedIndex: isDelivery ? 0 : 1,
      onChanged: onChanged,
    );
  }

  static SegmentedControlViewModel options({
    required List<String> options,
    required int selectedIndex,
    ValueChanged<int>? onChanged,
  }) {
    return SegmentedControlViewModel(
      options: options,
      selectedIndex: selectedIndex,
      onChanged: onChanged,
    );
  }
}
