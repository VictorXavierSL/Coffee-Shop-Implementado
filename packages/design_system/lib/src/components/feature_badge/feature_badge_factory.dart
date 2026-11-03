import 'package:flutter/material.dart';

import 'feature_badge_view_model.dart';

abstract final class FeatureBadgeFactory {
  static const fastDelivery = FeatureBadgeViewModel(
    icon: Icons.delivery_dining_rounded,
    label: 'Entrega rápida',
  );

  static const qualityBean = FeatureBadgeViewModel(
    icon: Icons.grain_rounded,
    label: 'Grão selecionado',
  );

  static const extraMilk = FeatureBadgeViewModel(
    icon: Icons.local_drink_rounded,
    label: 'Leite extra',
  );

  /// Converte códigos vindos da API (`features: ["fast_delivery", ...]`).
  static FeatureBadgeViewModel? fromCode(String code) => switch (code) {
        'fast_delivery' => fastDelivery,
        'quality_bean' => qualityBean,
        'extra_milk' => extraMilk,
        _ => null,
      };
}
