import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import '../../primitives/product_image.dart';
import '../quantity_stepper/quantity_stepper_component.dart';
import 'cart_item_tile_view_model.dart';

class CartItemTileComponent extends StatelessWidget {
  const CartItemTileComponent({super.key, required this.viewModel});

  final CartItemTileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        ProductImage(
          source: viewModel.imageSource,
          width: 54,
          height: 54,
          radius: AppRadius.sm,
          semanticLabel: viewModel.title,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.title.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(viewModel.subtitle, style: AppTypography.caption.copyWith(color: c.textSecondary)),
            ],
          ),
        ),
        QuantityStepperComponent(viewModel: viewModel.stepper),
      ],
    );
  }
}
