import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color_tokens.dart';
import 'app_spacing.dart';

/// Monta os `ThemeData` claro e escuro a partir dos [AppColorTokens].
///
/// É o único lugar do projeto que conhece a API do `ThemeData`.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light, AppColorTokens.light);

  static ThemeData dark() => _build(Brightness.dark, AppColorTokens.dark);

  static ThemeData _build(Brightness brightness, AppColorTokens tokens) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    final textTheme = GoogleFonts.soraTextTheme(base.textTheme).apply(
      bodyColor: tokens.textPrimary,
      displayColor: tokens.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: tokens.background,
      canvasColor: tokens.background,
      textTheme: textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: tokens.primary,
        brightness: brightness,
      ).copyWith(
        primary: tokens.primary,
        onPrimary: tokens.onPrimary,
        surface: tokens.surface,
        onSurface: tokens.textPrimary,
        error: tokens.danger,
      ),
      dividerColor: tokens.border,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: tokens.primary),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: tokens.primary,
        selectionColor: tokens.primary.withValues(alpha: 0.25),
        selectionHandleColor: tokens.primary,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tokens.textPrimary,
        contentTextStyle: GoogleFonts.sora(color: tokens.background, fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[tokens],
    );
  }
}

/// Atalhos para ler o tema a partir de qualquer `BuildContext`.
extension AppThemeContext on BuildContext {
  AppColorTokens get colors =>
      Theme.of(this).extension<AppColorTokens>() ?? AppColorTokens.light;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

/// Estado global do tema (Observer: quem escuta é reconstruído).
class ThemeController extends ValueNotifier<ThemeMode> {
  ThemeController([super.value = ThemeMode.light]);

  bool get isDark => value == ThemeMode.dark;

  void toggle() => value = isDark ? ThemeMode.light : ThemeMode.dark;
}
