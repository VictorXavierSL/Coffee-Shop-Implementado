import 'package:flutter/material.dart';

import 'bottom_nav_bar_view_model.dart';

/// Abas do app, na ordem do Figma.
enum CoffeeTab { home, favorites, bag, notifications }

abstract final class BottomNavBarFactory {
  /// Barra do app: Home, Favoritos, Sacola (com contador) e Notificações.
  static BottomNavBarViewModel coffeeShop({
    required CoffeeTab selected,
    int bagCount = 0,
    int notificationCount = 0,
    ValueChanged<CoffeeTab>? onSelected,
  }) {
    return BottomNavBarViewModel(
      selectedIndex: selected.index,
      onSelected: onSelected == null ? null : (i) => onSelected(CoffeeTab.values[i]),
      items: [
        const BottomNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: 'Início',
        ),
        const BottomNavItem(
          icon: Icons.favorite_border_rounded,
          activeIcon: Icons.favorite_rounded,
          label: 'Favoritos',
        ),
        BottomNavItem(
          icon: Icons.shopping_bag_outlined,
          activeIcon: Icons.shopping_bag_rounded,
          label: 'Sacola',
          badgeCount: bagCount,
        ),
        BottomNavItem(
          icon: Icons.notifications_none_rounded,
          activeIcon: Icons.notifications_rounded,
          label: 'Notificações',
          badgeCount: notificationCount,
        ),
      ],
    );
  }
}
