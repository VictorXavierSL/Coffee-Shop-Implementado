import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'order_view_model.dart';

/// Figma: "High-Fidelity (Order)".
class OrderView extends StatefulWidget {
  const OrderView({super.key, required this.viewModel});

  final OrderViewModel viewModel;

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  OrderViewModel get vm => widget.viewModel;

  @override
  void initState() {
    super.initState();
    vm.start();
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
      builder: (context, _) => Scaffold(
        appBar: TopBarComponent(viewModel: vm.topBar),
        bottomNavigationBar: vm.isEmpty ? null : _PaymentBar(viewModel: vm),
        body: vm.isEmpty
            ? StateViewComponent(viewModel: vm.emptyState)
            : _OrderBody(viewModel: vm),
      ),
    );
  }
}

class _OrderBody extends StatelessWidget {
  const _OrderBody({required this.viewModel});

  final OrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final discount = viewModel.discountTile;
    return ListView(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.lg),
      children: [
        Padding(
          padding: AppSpacing.screen,
          child: SegmentedControlComponent(viewModel: viewModel.deliveryToggle),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(padding: AppSpacing.screen, child: _AddressSection(viewModel: viewModel)),
        const SizedBox(height: AppSpacing.md),
        const InsetDivider(indent: 40),
        const SizedBox(height: AppSpacing.md),
        for (final tile in viewModel.cartTiles)
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
            child: CartItemTileComponent(viewModel: tile),
          ),
        const SectionBreak(),
        const SizedBox(height: AppSpacing.md),
        if (discount != null)
          Padding(padding: AppSpacing.screen, child: ActionTileComponent(viewModel: discount)),
        const SizedBox(height: AppSpacing.lg),
        Padding(padding: AppSpacing.screen, child: _SummarySection(viewModel: viewModel)),
      ],
    );
  }
}

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.viewModel});

  final OrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final address = viewModel.address;
    if (!viewModel.isDelivery) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Retirar na loja'),
          const SizedBox(height: AppSpacing.md),
          Text('Coffee Shop · Centro', style: AppTypography.titleSmall.copyWith(color: c.textBody)),
          const SizedBox(height: AppSpacing.xxs),
          Text('Pronto em cerca de 5 minutos após o pedido.',
              style: AppTypography.caption.copyWith(color: c.textSecondary)),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Endereço de entrega'),
        const SizedBox(height: AppSpacing.md),
        Text(address?.title ?? 'Nenhum endereço cadastrado',
            style: AppTypography.titleSmall.copyWith(color: c.textBody)),
        if (address != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(address.line, style: AppTypography.caption.copyWith(color: c.textSecondary)),
        ],
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            ActionButtonComponent(viewModel: viewModel.editAddressButton),
            ActionButtonComponent(viewModel: viewModel.addNoteButton),
          ],
        ),
      ],
    );
  }
}

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.viewModel});

  final OrderViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final rows = viewModel.summaryRows;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Resumo do pagamento'),
        const SizedBox(height: AppSpacing.md),
        if (viewModel.quoteError != null)
          Text(viewModel.quoteError!, style: AppTypography.caption.copyWith(color: c.danger))
        else if (rows.isEmpty)
          const LinearProgressIndicator(minHeight: 2)
        else
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: SummaryRowComponent(viewModel: row),
            ),
      ],
    );
  }
}

class _PaymentBar extends StatelessWidget {
  const _PaymentBar({required this.viewModel});

  final OrderViewModel viewModel;

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
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xs, AppSpacing.lg, AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ActionTileComponent(viewModel: viewModel.paymentTile),
              const SizedBox(height: AppSpacing.xs),
              ActionButtonComponent(viewModel: viewModel.orderButton),
            ],
          ),
        ),
      ),
    );
  }
}
