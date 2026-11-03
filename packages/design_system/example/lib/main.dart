import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'catalog_scaffold.dart';
import 'pages/component_pages.dart';
import 'pages/foundations_page.dart';

/// Sample App do Design System: um "Storybook" em Flutter.
///
/// Cada página chama as FACTORIES dos componentes — exatamente como as
/// telas do app fazem — e mostra todas as variantes e estados.
void main() => runApp(const CatalogApp());

final themeController = ThemeController();

class CatalogApp extends StatelessWidget {
  const CatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, mode, _) => MaterialApp(
        title: 'Coffee Design System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: mode,
        home: const CatalogHome(),
      ),
    );
  }
}

class CatalogEntry {
  const CatalogEntry(this.title, this.subtitle, this.icon, this.builder);

  final String title;
  final String subtitle;
  final IconData icon;
  final WidgetBuilder builder;
}

final entries = <CatalogEntry>[
  CatalogEntry('Foundations', 'Cores, tipografia, espaçamento e raios', Icons.palette_outlined,
      (_) => const FoundationsPage()),
  CatalogEntry('Action Button', 'primary · secondary · outline · ghost · hero · ícone',
      Icons.smart_button_outlined, (_) => const ActionButtonPage()),
  CatalogEntry('Text Field', 'e-mail · senha · texto · busca', Icons.text_fields_rounded,
      (_) => const TextFieldPage()),
  CatalogEntry('Selection', 'Chips de categoria e tamanho · Segmented control',
      Icons.check_circle_outline_rounded, (_) => const SelectionPage()),
  CatalogEntry('Navigation', 'Top bar · Category tabs · Bottom nav bar', Icons.navigation_outlined,
      (_) => const NavigationPage()),
  CatalogEntry('Product', 'Product card · Promo banner · Feature badge · Rating',
      Icons.local_cafe_outlined, (_) => const ProductPage()),
  CatalogEntry('Checkout', 'Cart item · Quantity stepper · Action tile · Summary row',
      Icons.shopping_bag_outlined, (_) => const CheckoutPage()),
  CatalogEntry('Feedback', 'Status card · Step progress · State view · App message',
      Icons.notifications_none_rounded, (_) => const FeedbackPage()),
];

class CatalogHome extends StatelessWidget {
  const CatalogHome({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return CatalogScaffold(
      title: 'Coffee Design System',
      children: [
        Text(
          'Catálogo de tokens e componentes extraídos do Figma "Coffee Shop Mobile App Design". '
          'Use o botão de tema para conferir claro e escuro.',
          style: AppTypography.body.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final entry in entries) ...[
          Material(
            color: c.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xxs),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(entry.icon, color: c.primary),
              ),
              title: Text(entry.title, style: AppTypography.title.copyWith(color: c.textPrimary)),
              subtitle: Text(entry.subtitle, style: AppTypography.caption.copyWith(color: c.textSecondary)),
              trailing: Icon(Icons.chevron_right_rounded, color: c.textSecondary),
              onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: entry.builder)),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}
