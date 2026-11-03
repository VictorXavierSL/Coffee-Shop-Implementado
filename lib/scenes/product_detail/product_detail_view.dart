import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'product_detail_view_model.dart';

/// Figma: "High-Fidelity (Detail Item)".
class ProductDetailView extends StatefulWidget {
  const ProductDetailView({super.key, required this.viewModel});

  final ProductDetailViewModel viewModel;

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> {
  ProductDetailViewModel get vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    vm.load();
  }

  @override
  void dispose() {
    vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: vm,
      builder: (context, _) {
        final state = vm.contentState;
        return Scaffold(
          appBar: TopBarComponent(viewModel: vm.topBar),
          bottomNavigationBar: state == null ? _BuyBar(viewModel: vm) : null,
          body: state != null
              ? StateViewComponent(viewModel: state)
              : _DetailBody(viewModel: vm),
        );
      },
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.viewModel});

  final ProductDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final product = viewModel.product!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
      children: [
        AspectRatio(
          aspectRatio: 327 / 202,
          child: ProductImage(
            source: product.imageUrl,
            radius: AppRadius.lg,
            semanticLabel: product.name,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTypography.headline.copyWith(color: c.textPrimary)),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(product.subtitle, style: AppTypography.caption.copyWith(color: c.textSecondary)),
                  const SizedBox(height: AppSpacing.md),
                  RatingLabel.inline(rating: product.rating, reviewCount: product.reviewCount),
                ],
              ),
            ),
            for (final badge in viewModel.features) ...[
              const SizedBox(width: AppSpacing.sm),
              FeatureBadgeComponent(viewModel: badge),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const InsetDivider(),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle('Descrição'),
        const SizedBox(height: AppSpacing.xs),
        _Description(viewModel: viewModel),
        const SizedBox(height: AppSpacing.lg),
        const SectionTitle('Tamanho'),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            for (final (i, chip) in viewModel.sizeOptions.indexed) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              Expanded(child: SelectableChipComponent(viewModel: chip)),
            ],
          ],
        ),
      ],
    );
  }
}

class _Description extends StatelessWidget {
  const _Description({required this.viewModel});

  final ProductDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final text = viewModel.product!.description;
    final expanded = viewModel.isDescriptionExpanded;
    final short = text.length > 110 && !expanded ? '${text.substring(0, 110).trimRight()}.. ' : '$text ';

    return Text.rich(
      TextSpan(
        style: AppTypography.bodyLight.copyWith(color: c.textSecondary),
        children: [
          TextSpan(text: short),
          if (text.length > 110)
            WidgetSpan(
              alignment: PlaceholderAlignment.baseline,
              baseline: TextBaseline.alphabetic,
              child: GestureDetector(
                onTap: viewModel.toggleDescription,
                child: Text(
                  expanded ? 'Ler menos' : 'Ler mais',
                  style: AppTypography.titleSmall.copyWith(color: c.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BuyBar extends StatelessWidget {
  const _BuyBar({required this.viewModel});

  final ProductDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        boxShadow: AppShadows.bottomBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.md),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Preço', style: AppTypography.body.copyWith(color: c.textMuted, height: 1.2)),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(viewModel.priceLabel, style: AppTypography.price.copyWith(color: c.primary)),
                ],
              ),
              const SizedBox(width: 34),
              Expanded(child: ActionButtonComponent(viewModel: viewModel.buyButton)),
            ],
          ),
        ),
      ),
    );
  }
}
