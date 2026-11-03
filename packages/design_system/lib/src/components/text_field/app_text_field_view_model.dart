import 'package:flutter/widgets.dart';

/// Tipo de campo — define teclado, ícone e comportamento.
///
/// - [text]     → texto livre.
/// - [email]    → teclado de e-mail, ícone de envelope.
/// - [password] → texto oculto com botão de mostrar/ocultar.
/// - [search]   → campo escuro do cabeçalho da Home ("Search coffee").
enum AppTextFieldKind { text, email, password, search }

@immutable
class AppTextFieldViewModel {
  const AppTextFieldViewModel({
    required this.kind,
    this.label,
    this.hint,
    this.initialValue = '',
    this.errorText,
    this.isEnabled = true,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
    this.onSubmitted,
  });

  final AppTextFieldKind kind;
  final String? label;
  final String? hint;

  /// Valor inicial. O campo é preenchido UMA vez, na criação.
  final String initialValue;

  /// Mensagem de validação. `null` = sem erro.
  final String? errorText;
  final bool isEnabled;
  final TextInputAction textInputAction;

  /// Delegates: cada tecla e o "enter" são repassados à ViewModel da cena.
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  bool get hasError => errorText != null && errorText!.isNotEmpty;

  AppTextFieldViewModel copyWith({
    String? label,
    String? hint,
    String? initialValue,
    String? errorText,
    bool clearError = false,
    bool? isEnabled,
    TextInputAction? textInputAction,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return AppTextFieldViewModel(
      kind: kind,
      label: label ?? this.label,
      hint: hint ?? this.hint,
      initialValue: initialValue ?? this.initialValue,
      errorText: clearError ? null : (errorText ?? this.errorText),
      isEnabled: isEnabled ?? this.isEnabled,
      textInputAction: textInputAction ?? this.textInputAction,
      onChanged: onChanged ?? this.onChanged,
      onSubmitted: onSubmitted ?? this.onSubmitted,
    );
  }
}
