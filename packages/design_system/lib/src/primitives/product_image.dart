import 'package:flutter/material.dart';

import '../foundations/app_theme.dart';

/// Primitiva: foto de produto com fallback.
///
/// Aceita caminho de asset (`assets/...`) ou URL (`http...`). Se a imagem não
/// existir ou falhar, desenha um placeholder com a cor da marca — assim o
/// app funciona mesmo antes de as fotos do Figma serem exportadas.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.radius = 12,
    this.semanticLabel,
  });

  final String? source;
  final double? width;
  final double? height;
  final double radius;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(width: width, height: height, child: _image(context)),
    );
  }

  Widget _image(BuildContext context) {
    final src = source;
    Widget fallback(BuildContext ctx, Object _, StackTrace? __) => const _Placeholder();
    if (src == null || src.isEmpty) return const _Placeholder();
    if (src.startsWith('http')) {
      return Image.network(src, fit: BoxFit.cover, semanticLabel: semanticLabel, errorBuilder: fallback);
    }
    return Image.asset(src, fit: BoxFit.cover, semanticLabel: semanticLabel, errorBuilder: fallback);
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [c.heroEnd, c.primary],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, box) => Center(
          child: Icon(
            Icons.coffee_rounded,
            color: c.onPrimary.withValues(alpha: 0.85),
            size: (box.biggest.shortestSide * 0.4).clamp(16, 72).toDouble(),
          ),
        ),
      ),
    );
  }
}
