import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tokens SEMÂNTICOS de cor — o que os componentes consomem.
///
/// Cada componente pede um PAPEL (`primary`, `surface`, `textSecondary`...)
/// e não um valor. Assim o mesmo componente funciona no tema claro (valores
/// do Figma) e no escuro (extensão do projeto) sem nenhum `if`.
@immutable
class AppColorTokens extends ThemeExtension<AppColorTokens> {
  const AppColorTokens({
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.textPrimary,
    required this.textBody,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.outline,
    required this.heroStart,
    required this.heroEnd,
    required this.heroSurface,
    required this.onHero,
    required this.onHeroMuted,
    required this.danger,
    required this.success,
    required this.star,
    required this.scrim,
  });

  /// Cor de marca: botões principais, preço, item ativo.
  final Color primary;

  /// Texto/ícone sobre [primary].
  final Color onPrimary;

  /// Fundo de item selecionado de baixa ênfase (chip de tamanho "M").
  final Color primaryContainer;

  /// Texto/ícone sobre [primaryContainer].
  final Color onPrimaryContainer;

  /// Fundo das telas.
  final Color background;

  /// Cards, barras inferiores, campos.
  final Color surface;

  /// Superfície neutra (fundo do segmented control, chip inativo).
  final Color surfaceVariant;

  /// Títulos (Figma: Grey/Normal :active #242424).
  final Color textPrimary;

  /// Corpo de texto (Figma: Grey/Normal #313131).
  final Color textBody;

  /// Legendas e subtítulos (Figma: Grey/Lighter #A2A2A2).
  final Color textSecondary;

  /// Rótulos discretos, ex.: "Price" (Figma: Grey/Light :hover #909090).
  final Color textMuted;

  /// Bordas e divisores (Figma: Surface/Light :active #E3E3E3).
  final Color border;

  /// Contorno de botões outline (Figma: Grey/Lighter).
  final Color outline;

  /// Início/fim do gradiente do cabeçalho escuro da Home.
  final Color heroStart;
  final Color heroEnd;

  /// Campo de busca dentro do cabeçalho (Figma: Grey/Normal :hover #2A2A2A).
  final Color heroSurface;

  /// Texto sobre o cabeçalho escuro.
  final Color onHero;

  /// Texto secundário sobre o cabeçalho escuro (Surface/Normal :active).
  final Color onHeroMuted;

  final Color danger;
  final Color success;
  final Color star;

  /// Véu escuro translúcido (selo de avaliação sobre a foto).
  final Color scrim;

  static const AppColorTokens light = AppColorTokens(
    primary: AppColors.brownNormal,
    onPrimary: AppColors.surfaceWhite,
    primaryContainer: AppColors.brownLight,
    onPrimaryContainer: AppColors.brownNormal,
    background: AppColors.surfaceLight,
    surface: AppColors.surfaceWhite,
    surfaceVariant: AppColors.surfaceWhiteActive,
    textPrimary: AppColors.greyNormalActive,
    textBody: AppColors.greyNormal,
    textSecondary: AppColors.greyLighter,
    textMuted: AppColors.greyLightHover,
    border: AppColors.surfaceLightActive,
    outline: AppColors.greyLighter,
    heroStart: AppColors.greyDarkest,
    heroEnd: AppColors.greyNormal,
    heroSurface: AppColors.greyNormalHover,
    onHero: AppColors.surfaceWhite,
    onHeroMuted: AppColors.surfaceNormalActive,
    danger: AppColors.red,
    success: AppColors.green,
    star: AppColors.star,
    scrim: Color(0x4D111111),
  );

  static const AppColorTokens dark = AppColorTokens(
    primary: AppColors.brownNormal,
    onPrimary: AppColors.surfaceWhite,
    primaryContainer: AppColors.darkBrownContainer,
    onPrimaryContainer: AppColors.darkBrownOnContainer,
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    surfaceVariant: AppColors.darkSurfaceVariant,
    textPrimary: AppColors.darkTextPrimary,
    textBody: AppColors.darkTextBody,
    textSecondary: AppColors.darkTextSecondary,
    textMuted: AppColors.darkTextSecondary,
    border: AppColors.darkBorder,
    outline: AppColors.darkTextSecondary,
    heroStart: AppColors.darkHeroStart,
    heroEnd: AppColors.darkHeroEnd,
    heroSurface: AppColors.darkHeroSurface,
    onHero: AppColors.darkTextPrimary,
    onHeroMuted: AppColors.darkTextBody,
    danger: AppColors.darkRed,
    success: AppColors.darkGreen,
    star: AppColors.star,
    scrim: Color(0x66000000),
  );

  @override
  AppColorTokens copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? textPrimary,
    Color? textBody,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? outline,
    Color? heroStart,
    Color? heroEnd,
    Color? heroSurface,
    Color? onHero,
    Color? onHeroMuted,
    Color? danger,
    Color? success,
    Color? star,
    Color? scrim,
  }) {
    return AppColorTokens(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      textPrimary: textPrimary ?? this.textPrimary,
      textBody: textBody ?? this.textBody,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      border: border ?? this.border,
      outline: outline ?? this.outline,
      heroStart: heroStart ?? this.heroStart,
      heroEnd: heroEnd ?? this.heroEnd,
      heroSurface: heroSurface ?? this.heroSurface,
      onHero: onHero ?? this.onHero,
      onHeroMuted: onHeroMuted ?? this.onHeroMuted,
      danger: danger ?? this.danger,
      success: success ?? this.success,
      star: star ?? this.star,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColorTokens lerp(ThemeExtension<AppColorTokens>? other, double t) {
    if (other is! AppColorTokens) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColorTokens(
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      primaryContainer: l(primaryContainer, other.primaryContainer),
      onPrimaryContainer: l(onPrimaryContainer, other.onPrimaryContainer),
      background: l(background, other.background),
      surface: l(surface, other.surface),
      surfaceVariant: l(surfaceVariant, other.surfaceVariant),
      textPrimary: l(textPrimary, other.textPrimary),
      textBody: l(textBody, other.textBody),
      textSecondary: l(textSecondary, other.textSecondary),
      textMuted: l(textMuted, other.textMuted),
      border: l(border, other.border),
      outline: l(outline, other.outline),
      heroStart: l(heroStart, other.heroStart),
      heroEnd: l(heroEnd, other.heroEnd),
      heroSurface: l(heroSurface, other.heroSurface),
      onHero: l(onHero, other.onHero),
      onHeroMuted: l(onHeroMuted, other.onHeroMuted),
      danger: l(danger, other.danger),
      success: l(success, other.success),
      star: l(star, other.star),
      scrim: l(scrim, other.scrim),
    );
  }
}
