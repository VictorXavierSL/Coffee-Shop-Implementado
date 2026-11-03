import 'package:flutter/material.dart';

import '../action_button/action_button_view_model.dart';
import 'status_card_view_model.dart';

abstract final class StatusCardFactory {
  static StatusCardViewModel orderStatus({required String title, required String message}) {
    return StatusCardViewModel(icon: Icons.delivery_dining_rounded, title: title, message: message);
  }

  static StatusCardViewModel courier({
    required String name,
    required String role,
    VoidCallback? onCall,
  }) {
    return StatusCardViewModel(
      icon: Icons.person_rounded,
      title: name,
      message: role,
      isBordered: false,
      trailing: ActionButtonViewModel(
        icon: Icons.call_outlined,
        style: ActionButtonStyle.outline,
        size: ActionButtonSize.medium,
        onPressed: onCall,
        semanticLabel: 'Ligar para $name',
      ),
    );
  }
}
