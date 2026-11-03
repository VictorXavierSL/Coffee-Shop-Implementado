import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../catalog_scaffold.dart';

class FoundationsPage extends StatelessWidget {
  const FoundationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final colors = <(String, Color)>[
      ('primary', c.primary),
      ('onPrimary', c.onPrimary),
      ('primaryContainer', c.primaryContainer),
      ('background', c.background),
      ('surface', c.surface),
      ('surfaceVariant', c.surfaceVariant),
      ('textPrimary', c.textPrimary),
      ('textBody', c.textBody),
      ('textSecondary', c.textSecondary),
      ('textMuted', c.textMuted),
      ('border', c.border),
      ('heroStart', c.heroStart),
      ('heroSurface', c.heroSurface),
      ('danger', c.danger),
      ('success', c.success),
      ('star', c.star),
    ];
    final type = <(String, TextStyle)>[
      ('display · 32 SemiBold', AppTypography.display),
      ('headline · 20 SemiBold', AppTypography.headline),
      ('title · 16 SemiBold', AppTypography.title),
      ('titleSmall · 14 SemiBold', AppTypography.titleSmall),
      ('body · 14 Regular', AppTypography.body),
      ('bodyLight · 14 Light', AppTypography.bodyLight),
      ('caption · 12 Regular', AppTypography.caption),
      ('price · 18 SemiBold', AppTypography.price),
    ];

    return CatalogScaffold(
      title: 'Foundations',
      children: [
        ShowcaseSection(
          title: 'Cores semânticas',
          description: 'Papéis lidos via context.colors. Alterne o tema para ver o mapeamento escuro.',
          items: [
            for (final (name, color) in colors)
              ShowcaseItem(
                caption: name,
                child: Container(
                  width: 96,
                  height: 64,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: c.border),
                  ),
                ),
              ),
          ],
        ),
        ShowcaseSection(
          title: 'Tipografia — Sora',
          wrap: false,
          items: [
            for (final (name, style) in type)
              ShowcaseItem(
                caption: name,
                child: Text('Caffe Mocha', style: style.copyWith(color: c.textPrimary)),
              ),
          ],
        ),
        ShowcaseSection(
          title: 'Espaçamento',
          items: [
            for (final (name, value) in const [
              ('xxs 4', AppSpacing.xxs),
              ('xs 8', AppSpacing.xs),
              ('sm 12', AppSpacing.sm),
              ('md 16', AppSpacing.md),
              ('lg 24', AppSpacing.lg),
              ('xl 32', AppSpacing.xl),
            ])
              ShowcaseItem(
                caption: name,
                child: Container(width: value, height: 24, color: c.primary),
              ),
          ],
        ),
        ShowcaseSection(
          title: 'Raios',
          items: [
            for (final (name, value) in const [
              ('xs 6', AppRadius.xs),
              ('sm 8', AppRadius.sm),
              ('md 12', AppRadius.md),
              ('lg 16', AppRadius.lg),
              ('xl 24', AppRadius.xl),
            ])
              ShowcaseItem(
                caption: name,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: c.primaryContainer,
                    border: Border.all(color: c.primary),
                    borderRadius: BorderRadius.circular(value),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
