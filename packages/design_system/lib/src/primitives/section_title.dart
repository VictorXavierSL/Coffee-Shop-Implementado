import 'package:flutter/material.dart';

import '../foundations/app_theme.dart';
import '../foundations/app_typography.dart';

/// Primitiva: título de seção ("Description", "Size", "Payment Summary").
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(text, style: AppTypography.title.copyWith(color: context.colors.textPrimary)),
    );
  }
}

/// Primitiva: divisor de 1px recuado 16 de cada lado, como no Figma.
class InsetDivider extends StatelessWidget {
  const InsetDivider({super.key, this.indent = 16});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, thickness: 1, indent: indent, endIndent: indent, color: context.colors.border);
  }
}

/// Primitiva: faixa grossa de 4px que separa blocos (tela Order).
class SectionBreak extends StatelessWidget {
  const SectionBreak({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 4, color: context.colors.primaryContainer);
  }
}
