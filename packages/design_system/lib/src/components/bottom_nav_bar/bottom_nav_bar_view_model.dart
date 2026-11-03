import 'package:flutter/widgets.dart';

@immutable
class BottomNavItem {
  const BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount = 0,
  });

  final IconData icon;
  final IconData activeIcon;

  /// Usado só para acessibilidade (o Figma não mostra rótulo).
  final String label;
  final int badgeCount;
}

@immutable
class BottomNavBarViewModel {
  const BottomNavBarViewModel({
    required this.items,
    required this.selectedIndex,
    this.onSelected,
  });

  final List<BottomNavItem> items;
  final int selectedIndex;
  final ValueChanged<int>? onSelected;
}
