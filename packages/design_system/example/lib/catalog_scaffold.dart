import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'main.dart' show themeController;

/// Layout padrão das páginas do catálogo, com o botão de tema no topo.
class CatalogScaffold extends StatelessWidget {
  const CatalogScaffold({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: c.background,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        titleSpacing: AppSpacing.md,
        title: Row(
          children: [
            if (canPop) ...[
              ActionButtonComponent(
                viewModel: ActionButtonFactory.back(onPressed: () => Navigator.of(context).pop()),
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Expanded(child: Text(title, style: AppTypography.title.copyWith(color: c.textPrimary))),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeController,
              builder: (context, mode, _) => ActionButtonComponent(
                viewModel: ActionButtonFactory.ghostIcon(
                  icon: mode == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  semanticLabel: 'Alternar tema',
                  onPressed: themeController.toggle,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.xxl),
        children: children,
      ),
    );
  }
}

/// Bloco "título + descrição + exemplos" de uma seção do catálogo.
class ShowcaseSection extends StatelessWidget {
  const ShowcaseSection({
    super.key,
    required this.title,
    this.description,
    required this.items,
    this.wrap = true,
  });

  final String title;
  final String? description;
  final List<ShowcaseItem> items;

  /// `true` = lado a lado; `false` = um embaixo do outro, largura total.
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: AppTypography.captionStrong.copyWith(color: c.primary, letterSpacing: 0.8)),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(description!, style: AppTypography.caption.copyWith(color: c.textSecondary, height: 1.5)),
          ],
          const SizedBox(height: AppSpacing.md),
          if (wrap)
            Wrap(spacing: AppSpacing.md, runSpacing: AppSpacing.md, children: items)
          else
            for (final item in items) ...[item, const SizedBox(height: AppSpacing.md)],
        ],
      ),
    );
  }
}

class ShowcaseItem extends StatelessWidget {
  const ShowcaseItem({super.key, required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        const SizedBox(height: AppSpacing.xs),
        Text(caption, style: AppTypography.caption.copyWith(color: c.textSecondary)),
      ],
    );
  }
}
