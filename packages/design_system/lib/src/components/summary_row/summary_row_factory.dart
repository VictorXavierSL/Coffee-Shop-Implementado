import 'summary_row_view_model.dart';

abstract final class SummaryRowFactory {
  static SummaryRowViewModel line({required String label, required String value}) =>
      SummaryRowViewModel(label: label, value: value);

  static SummaryRowViewModel discounted({
    required String label,
    required String value,
    required String previousValue,
  }) =>
      SummaryRowViewModel(label: label, value: value, previousValue: previousValue);

  static SummaryRowViewModel total({required String label, required String value}) =>
      SummaryRowViewModel(label: label, value: value, isEmphasized: true);
}
