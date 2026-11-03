import 'step_progress_view_model.dart';

abstract final class StepProgressFactory {
  /// Etapas do pedido: recebido → preparando → a caminho → entregue.
  static StepProgressViewModel orderStatus({required int completedSteps}) {
    final steps = completedSteps < 0 ? 0 : (completedSteps > 4 ? 4 : completedSteps);
    return StepProgressViewModel(totalSteps: 4, completedSteps: steps);
  }
}
