import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import 'bottom_nav_bar_view_model.dart';

/// Barra inferior: fundo branco, cantos superiores de raio 24, ícone ativo
/// marrom com um "dot" de 10×5 abaixo (Figma: "Button Icon").
class BottomNavBarComponent extends StatelessWidget {
  const BottomNavBarComponent({super.key, required this.viewModel});

  final BottomNavBarViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        boxShadow: AppShadows.bottomBar,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < viewModel.items.length; i++)
                _NavButton(
                  item: viewModel.items[i],
                  selected: i == viewModel.selectedIndex,
                  onTap: viewModel.onSelected == null ? null : () => viewModel.onSelected!(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.selected, this.onTap});

  final BottomNavItem item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: item.label,
      selected: selected,
      button: true,
      child: InkResponse(
        onTap: onTap,
        radius: 28,
        child: SizedBox(
          width: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Badge(
                isLabelVisible: item.badgeCount > 0,
                backgroundColor: c.primary,
                label: Text(
                  '${item.badgeCount}',
                  style: AppTypography.tiny.copyWith(color: c.onPrimary, fontSize: 9),
                ),
                child: Icon(
                  selected ? item.activeIcon : item.icon,
                  size: 24,
                  color: selected ? c.primary : c.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: AppDurations.fast,
                width: 10,
                height: 5,
                decoration: BoxDecoration(
                  color: selected ? c.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
