import 'package:flutter/widgets.dart';

/// Barra segmentada de progresso do pedido (4 traços no Figma "Delivery").
@immutable
class StepProgressViewModel {
  const StepProgressViewModel({required this.totalSteps, required this.completedSteps})
      : assert(totalSteps > 0),
        assert(completedSteps >= 0 && completedSteps <= totalSteps);

  final int totalSteps;
  final int completedSteps;
}
