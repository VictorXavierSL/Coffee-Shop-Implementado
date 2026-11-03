import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Escala tipográfica do Figma (fonte **Sora**, Google Font gratuita).
///
/// Nenhum estilo define `color`: cor é token de tema, aplicada pelo
/// componente com `.copyWith(color: context.colors.<papel>)`.
///
/// | Token          | Tamanho | Peso      | Altura | Uso no Figma                         |
/// |----------------|---------|-----------|--------|--------------------------------------|
/// | display        | 32      | SemiBold  | 1.5    | "Fall in Love with Coffee..."        |
/// | headline       | 20      | SemiBold  | 1.5    | Nome do produto no Detail            |
/// | title          | 16      | SemiBold  | 1.5    | Títulos de seção, nome no card       |
/// | titleSmall     | 14      | SemiBold  | 1.5    | Endereço, "1 Discount is Applies"    |
/// | body           | 14      | Regular   | 1.5    | Categorias, linhas do resumo         |
/// | bodyLight      | 14      | Light     | 1.5    | Descrição do produto                 |
/// | caption        | 12      | Regular   | 1.2    | Subtítulos ("Deep Foam")             |
/// | captionStrong  | 12      | SemiBold  | 1.5    | Valor do pagamento ("$ 5.53")        |
/// | price          | 18      | SemiBold  | 1.5    | Preço no card e no Detail            |
/// | button         | 16      | SemiBold  | 1.5    | Botões grandes                       |
/// | tiny           | 8       | SemiBold  | 1.5    | Nota no selo de avaliação            |
abstract final class AppTypography {
  static TextStyle _sora(
    double size,
    FontWeight weight, {
    double? height,
    double? letterSpacing,
  }) {
    return GoogleFonts.sora(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle get display =>
      _sora(32, FontWeight.w600, height: 1.5, letterSpacing: 0.16);
  static TextStyle get bannerTitle => _sora(32, FontWeight.w600, height: 1.25);
  static TextStyle get headline => _sora(20, FontWeight.w600, height: 1.5);
  static TextStyle get title => _sora(16, FontWeight.w600, height: 1.5);
  static TextStyle get titleSmall => _sora(14, FontWeight.w600, height: 1.5);
  static TextStyle get body => _sora(14, FontWeight.w400, height: 1.5);
  static TextStyle get bodyLight => _sora(14, FontWeight.w300, height: 1.5);
  static TextStyle get caption => _sora(12, FontWeight.w400, height: 1.2);
  static TextStyle get captionStrong => _sora(12, FontWeight.w600, height: 1.5);
  static TextStyle get price => _sora(18, FontWeight.w600, height: 1.5);
  static TextStyle get button => _sora(16, FontWeight.w600, height: 1.5);
  static TextStyle get buttonSmall => _sora(12, FontWeight.w400, height: 1.2);
  static TextStyle get tiny => _sora(8, FontWeight.w600, height: 1.5);
}
