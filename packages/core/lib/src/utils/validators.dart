/// Validações de formulário. Retornam a mensagem de erro ou `null` se válido.
abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(String value, {String field = 'Campo'}) =>
      value.trim().isEmpty ? '$field é obrigatório.' : null;

  static String? email(String value) {
    if (value.trim().isEmpty) return 'Informe seu e-mail.';
    return _emailPattern.hasMatch(value.trim()) ? null : 'E-mail inválido.';
  }

  static String? password(String value, {int minLength = 6}) {
    if (value.isEmpty) return 'Informe sua senha.';
    return value.length < minLength ? 'A senha deve ter ao menos $minLength caracteres.' : null;
  }
}

/// Formatação de valores para exibição.
abstract final class Formatters {
  /// 4.53 → "$ 4.53" (padrão do Figma).
  static String money(double value) => '\$ ${value.toStringAsFixed(2)}';

  /// 2026-10-30 → "30/10/2026".
  static String date(DateTime value) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(value.day)}/${two(value.month)}/${value.year}';
  }
}
