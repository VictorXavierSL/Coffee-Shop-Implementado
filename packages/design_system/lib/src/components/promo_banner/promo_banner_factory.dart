import 'package:flutter/widgets.dart';

import 'promo_banner_view_model.dart';

abstract final class PromoBannerFactory {
  static PromoBannerViewModel make({
    required String title,
    String tag = 'Promo',
    String? imageSource,
    VoidCallback? onTap,
  }) {
    return PromoBannerViewModel(tag: tag, title: title, imageSource: imageSource, onTap: onTap);
  }
}
