import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'order_tracking_view_model.dart';

class OrderTrackingView extends StatefulWidget {
  const OrderTrackingView({super.key, required this.viewModel});

  final OrderTrackingViewModel viewModel;

  @override
  State<OrderTrackingView> createState() => _OrderTrackingViewState();
}

class _OrderTrackingViewState extends State<OrderTrackingView> {
  OrderTrackingViewModel get vm => widget.viewModel;

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
          body: state != null
              ? StateViewComponent(viewModel: state)
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.32,
                      child: const _MapPlaceholder(),
                    ),
                    _TrackingSheet(viewModel: vm),
                  ],
                ),
        );
      },
    );
  }
}

/// O Figma usa um mapa real. Aqui fica um placeholder até integrar um
/// provedor de mapas (ex.: google_maps_flutter).
class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      color: c.surfaceVariant,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.map_outlined, size: 160, color: c.border),
          Icon(Icons.delivery_dining_rounded, size: 40, color: c.primary),
        ],
      ),
    );
  }
}

class _TrackingSheet extends StatelessWidget {
  const _TrackingSheet({required this.viewModel});

  final OrderTrackingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final courier = viewModel.courierCard;
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        boxShadow: AppShadows.bottomBar,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(color: c.border, borderRadius: BorderRadius.circular(AppRadius.pill)),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(viewModel.headline, style: AppTypography.title.copyWith(color: c.textPrimary)),
              const SizedBox(height: AppSpacing.xxs),
              Text(viewModel.destination, style: AppTypography.caption.copyWith(color: c.textSecondary)),
              const SizedBox(height: AppSpacing.md),
              StepProgressComponent(viewModel: viewModel.progress),
              const SizedBox(height: AppSpacing.md),
              StatusCardComponent(viewModel: viewModel.statusCard),
              if (courier != null) ...[
                const SizedBox(height: AppSpacing.md),
                StatusCardComponent(viewModel: courier),
              ],
              const SizedBox(height: AppSpacing.lg),
              ActionButtonComponent(viewModel: viewModel.mainButton),
            ],
          ),
        ),
      ),
    );
  }
}
