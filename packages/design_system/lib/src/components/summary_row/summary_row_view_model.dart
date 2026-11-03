import 'package:flutter/widgets.dart';

/// Linha do "Payment Summary": rótulo à esquerda, valor à direita.
@immutable
class SummaryRowViewModel {
  const SummaryRowViewModel({
    required this.label,
    required this.value,
    this.previousValue,
    this.isEmphasized = false,
  });

  final String label;
  final String value;

  /// Valor riscado antes do atual ("$ 2.0" → "$ 1.0").
  final String? previousValue;

  /// Linha de total.
  final bool isEmphasized;
}
