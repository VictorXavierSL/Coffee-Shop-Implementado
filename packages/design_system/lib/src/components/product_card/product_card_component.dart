import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import '../../primitives/product_image.dart';
import '../../primitives/rating_label.dart';
import '../action_button/action_button_component.dart';
import '../action_button/action_button_factory.dart';
import 'product_card_view_model.dart';

class ProductCardComponent extends StatelessWidget {
  const ProductCardComponent({super.key, required this.viewModel});

  final ProductCardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: viewModel.onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 140 / 128,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ProductImage(source: viewModel.imageSource, semanticLabel: viewModel.title),
                    Positioned(top: 0, right: 0, child: RatingLabel.badge(rating: viewModel.rating)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                viewModel.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.title.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                viewModel.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.caption.copyWith(color: c.textSecondary),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      viewModel.priceLabel,
                      style: AppTypography.price.copyWith(color: c.textPrimary),
                    ),
                  ),
                  ActionButtonComponent(
                    viewModel: ActionButtonFactory.addItem(
                      onPressed: viewModel.onAdd,
                      isEnabled: viewModel.isAddEnabled,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
