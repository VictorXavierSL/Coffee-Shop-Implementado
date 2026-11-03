import 'package:flutter/widgets.dart';

import '../selectable_chip/selectable_chip_factory.dart';
import '../selectable_chip/selectable_chip_view_model.dart';
import 'category_tabs_view_model.dart';

abstract final class CategoryTabsFactory {
  static CategoryTabsViewModel make({
    required List<String> labels,
    required int selectedIndex,
    ValueChanged<int>? onSelected,
  }) {
    return CategoryTabsViewModel(
      labels: labels,
      selectedIndex: selectedIndex,
      onSelected: onSelected,
    );
  }

  /// Converte o grupo em ViewModels de chip (usado pelo Component).
  static List<SelectableChipViewModel> chipsFor(CategoryTabsViewModel vm) {
    return [
      for (var i = 0; i < vm.labels.length; i++)
        SelectableChipFactory.category(
          label: vm.labels[i],
          isSelected: i == vm.selectedIndex,
          onSelected: vm.onSelected == null ? null : () => vm.onSelected!(i),
        ),
    ];
  }
}
