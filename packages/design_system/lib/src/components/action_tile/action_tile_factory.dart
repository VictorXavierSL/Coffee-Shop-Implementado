import 'package:flutter/material.dart';

import 'action_tile_view_model.dart';

abstract final class ActionTileFactory {
  static ActionTileViewModel discount({required String text, VoidCallback? onTap}) {
    return ActionTileViewModel(
      icon: Icons.discount_outlined,
      title: text,
      trailingIcon: Icons.chevron_right_rounded,
      onTap: onTap,
    );
  }

  static ActionTileViewModel paymentMethod({
    required String method,
    required String amountLabel,
    VoidCallback? onTap,
  }) {
    return ActionTileViewModel(
      icon: Icons.account_balance_wallet_outlined,
      title: method,
      subtitle: amountLabel,
      trailingIcon: Icons.keyboard_arrow_down_rounded,
      isBordered: false,
      onTap: onTap,
    );
  }
}
