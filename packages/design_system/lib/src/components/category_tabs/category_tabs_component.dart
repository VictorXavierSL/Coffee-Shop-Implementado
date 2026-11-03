import 'package:flutter/material.dart';

import '../../foundations/app_spacing.dart';
import '../selectable_chip/selectable_chip_component.dart';
import 'category_tabs_factory.dart';
import 'category_tabs_view_model.dart';

class CategoryTabsComponent extends StatelessWidget {
  const CategoryTabsComponent({
    super.key,
    required this.viewModel,
    this.padding = AppSpacing.screen,
  });

  final CategoryTabsViewModel viewModel;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final chips = CategoryTabsFactory.chipsFor(viewModel);
    return SizedBox(
      height: 29,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (_, i) => SelectableChipComponent(viewModel: chips[i]),
      ),
    );
  }
}
