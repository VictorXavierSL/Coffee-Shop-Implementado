import 'package:flutter/widgets.dart';

/// Banner promocional da Home ("Promo · Buy one get one FREE").
@immutable
class PromoBannerViewModel {
  const PromoBannerViewModel({
    required this.tag,
    required this.title,
    this.imageSource,
    this.onTap,
  });

  final String tag;
  final String title;
  final String? imageSource;
  final VoidCallback? onTap;
}
