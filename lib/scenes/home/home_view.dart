import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'home_view_model.dart';

/// Figma: "High-Fidelity (Home)".
class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeViewModel get vm => widget.viewModel;

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
          bottomNavigationBar: BottomNavBarComponent(viewModel: vm.bottomNav),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _HomeHeader(viewModel: vm)),
              if (vm.status == HomeStatus.ready)
                SliverPadding(
                  padding: const EdgeInsets.only(top: AppSpacing.lg),
                  sliver: SliverToBoxAdapter(
                    child: CategoryTabsComponent(viewModel: vm.categoryTabs),
                  ),
                ),
              if (vm.isRefreshing)
                const SliverToBoxAdapter(child: LinearProgressIndicator(minHeight: 2)),
              if (state != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: StateViewComponent(viewModel: state),
                )
              else
                _ProductGrid(cards: vm.productCards),
            ],
          ),
        );
      },
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.viewModel});

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final banner = viewModel.promoBanner;
    return Stack(
      children: [
        Positioned.fill(
          bottom: banner == null ? 0 : 70,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [c.heroStart, c.heroEnd],
              ),
            ),
          ),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, banner == null ? AppSpacing.lg : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: _Location(label: viewModel.locationLabel)),
                    ActionButtonComponent(viewModel: viewModel.themeButton),
                    const SizedBox(width: AppSpacing.xs),
                    ActionButtonComponent(viewModel: viewModel.logoutButton),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  children: [
                    Expanded(child: AppTextFieldComponent(viewModel: viewModel.searchField)),
                    const SizedBox(width: AppSpacing.md),
                    ActionButtonComponent(viewModel: viewModel.filterButton),
                  ],
                ),
                if (banner != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  PromoBannerComponent(viewModel: banner),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Location extends StatelessWidget {
  const _Location({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Localização', style: AppTypography.caption.copyWith(color: c.textSecondary)),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.titleSmall.copyWith(color: c.onHeroMuted),
              ),
            ),
            const SizedBox(width: AppSpacing.xxs),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: c.onHeroMuted),
          ],
        ),
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.cards});

  final List<ProductCardViewModel> cards;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: AppSpacing.lg,
          childAspectRatio: 156 / 238,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, i) => ProductCardComponent(viewModel: cards[i]),
          childCount: cards.length,
        ),
      ),
    );
  }
}
