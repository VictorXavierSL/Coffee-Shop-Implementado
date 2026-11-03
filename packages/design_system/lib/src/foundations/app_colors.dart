import 'package:flutter/material.dart';

/// Paleta BRUTA — a única fonte de valores hexadecimais do projeto.
///
/// Os nomes seguem os estilos "Color Foundation" do arquivo Figma
/// "Coffee Shop Mobile App Design (Community)":
///
/// | Figma                                | Constante              |
/// |--------------------------------------|------------------------|
/// | Color Foundation/Brown/Normal        | [brownNormal]          |
/// | Color Foundation/Brown/Light         | [brownLight]           |
/// | Color Foundation/Grey/Normal         | [greyNormal]           |
/// | Color Foundation/Grey/Normal :hover  | [greyNormalHover]      |
/// | Color Foundation/Grey/Normal :active | [greyNormalActive]     |
/// | Color Foundation/Grey/Dark :active   | [greyDarkActive]       |
/// | Color Foundation/Grey/Light :hover   | [greyLightHover]       |
/// | Color Foundation/Grey/Lighter        | [greyLighter]          |
/// | Color Foundation/Surface/White       | [surfaceWhite]         |
/// | Color Foundation/Surface/White :active | [surfaceWhiteActive] |
/// | Color Foundation/Surface/Light       | [surfaceLight]         |
/// | Color Foundation/Surface/Light :active | [surfaceLightActive] |
/// | Color Foundation/Surface/Normal :active | [surfaceNormalActive] |
///
/// Os valores `dark*` são uma EXTENSÃO deste projeto: o Figma original
/// só define o tema claro.
///
/// Componentes NUNCA usam esta classe diretamente — eles leem papéis
/// semânticos via `context.colors` (ver [AppColorTokens]).
abstract final class AppColors {
  // Brown
  static const Color brownNormal = Color(0xFFC67C4E);
  static const Color brownLight = Color(0xFFF9F2ED);
  static const Color brownLightActive = Color(0xFFEDD6C8);

  // Grey
  static const Color greyNormal = Color(0xFF313131);
  static const Color greyNormalHover = Color(0xFF2A2A2A);
  static const Color greyNormalActive = Color(0xFF242424);
  static const Color greyDarkActive = Color(0xFF050505);
  static const Color greyDarkest = Color(0xFF111111);
  static const Color greyLightHover = Color(0xFF909090);
  static const Color greyLighter = Color(0xFFA2A2A2);

  // Surface
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceWhiteActive = Color(0xFFEDEDED);
  static const Color surfaceLight = Color(0xFFF9F9F9);
  static const Color surfaceLightActive = Color(0xFFE3E3E3);
  static const Color surfaceNormalActive = Color(0xFFD8D8D8);

  // Feedback
  static const Color red = Color(0xFFED5151);
  static const Color green = Color(0xFF3E9B5B);
  static const Color star = Color(0xFFFBBE21);

  // Dark — extensão do projeto (não existe no Figma)
  static const Color darkBackground = Color(0xFF141110);
  static const Color darkSurface = Color(0xFF211C19);
  static const Color darkSurfaceVariant = Color(0xFF2E2723);
  static const Color darkBorder = Color(0xFF3D342E);
  static const Color darkTextPrimary = Color(0xFFF5EDE8);
  static const Color darkTextBody = Color(0xFFE3D8D1);
  static const Color darkTextSecondary = Color(0xFFA89C94);
  static const Color darkBrownContainer = Color(0xFF3B2A20);
  static const Color darkBrownOnContainer = Color(0xFFE9B48F);
  static const Color darkHeroStart = Color(0xFF080706);
  static const Color darkHeroEnd = Color(0xFF1E1A17);
  static const Color darkHeroSurface = Color(0xFF2A2420);
  static const Color darkRed = Color(0xFFF07A7A);
  static const Color darkGreen = Color(0xFF6FC08A);
}
