import 'package:flutter/widgets.dart';

import 'app_text_field_view_model.dart';

abstract final class AppTextFieldFactory {
  static AppTextFieldViewModel email({
    String label = 'E-mail',
    String hint = 'voce@email.com',
    String initialValue = '',
    String? errorText,
    bool isEnabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return AppTextFieldViewModel(
      kind: AppTextFieldKind.email,
      label: label,
      hint: hint,
      initialValue: initialValue,
      errorText: errorText,
      isEnabled: isEnabled,
      onChanged: onChanged,
    );
  }

  static AppTextFieldViewModel password({
    String label = 'Senha',
    String hint = 'Sua senha',
    String initialValue = '',
    String? errorText,
    bool isEnabled = true,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return AppTextFieldViewModel(
      kind: AppTextFieldKind.password,
      label: label,
      hint: hint,
      initialValue: initialValue,
      errorText: errorText,
      isEnabled: isEnabled,
      textInputAction: TextInputAction.done,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }

  static AppTextFieldViewModel text({
    required String label,
    String? hint,
    String initialValue = '',
    String? errorText,
    ValueChanged<String>? onChanged,
  }) {
    return AppTextFieldViewModel(
      kind: AppTextFieldKind.text,
      label: label,
      hint: hint,
      initialValue: initialValue,
      errorText: errorText,
      onChanged: onChanged,
    );
  }

  /// Busca escura do cabeçalho da Home.
  static AppTextFieldViewModel search({
    String hint = 'Buscar café',
    String initialValue = '',
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return AppTextFieldViewModel(
      kind: AppTextFieldKind.search,
      hint: hint,
      initialValue: initialValue,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
