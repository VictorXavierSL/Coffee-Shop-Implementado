import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../../foundations/app_theme.dart';
import '../../foundations/app_typography.dart';
import '../../primitives/product_image.dart';
import 'promo_banner_view_model.dart';

/// 327×140, raio 16. O título fica sobre faixas escuras (efeito "marca-texto"
/// do Figma), que aqui são feitas com `background` no `TextStyle`.
class PromoBannerComponent extends StatelessWidget {
  const PromoBannerComponent({super.key, required this.viewModel});

  final PromoBannerViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AspectRatio(
      aspectRatio: 327 / 140,
      child: Material(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: viewModel.onTap,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ProductImage(source: viewModel.imageSource, radius: 0),
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 13, AppSpacing.lg, 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: c.danger,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Text(viewModel.tag, style: AppTypography.titleSmall.copyWith(color: Colors.white, height: 1.2)),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Expanded(
                      child: FractionallySizedBox(
                        widthFactor: 0.65,
                        alignment: Alignment.topLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: 204,
                            child: Text(
                              viewModel.title,
                              style: AppTypography.bannerTitle.copyWith(
                                color: Colors.white,
                                background: Paint()..color = c.heroStart,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
