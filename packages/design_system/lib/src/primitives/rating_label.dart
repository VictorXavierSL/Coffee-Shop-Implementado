import 'package:flutter/material.dart';

import '../foundations/app_theme.dart';
import '../foundations/app_typography.dart';

/// Primitiva: avaliação com estrela.
///
/// - [RatingLabel.badge]  → selo translúcido no canto da foto do card ("★ 4.8").
/// - [RatingLabel.inline] → linha do Detail ("★ 4.8 (230)").
class RatingLabel extends StatelessWidget {
  const RatingLabel.badge({super.key, required this.rating})
      : reviewCount = null,
        _badge = true;

  const RatingLabel.inline({super.key, required this.rating, this.reviewCount})
      : _badge = false;

  final double rating;
  final int? reviewCount;
  final bool _badge;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final value = rating.toStringAsFixed(1);

    if (_badge) {
      return Container(
        padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
        decoration: BoxDecoration(
          color: c.scrim,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(24),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 12, color: c.star),
            const SizedBox(width: 4),
            Text(value, style: AppTypography.tiny.copyWith(color: Colors.white)),
          ],
        ),
      );
    }

    return Semantics(
      label: 'Nota $value${reviewCount != null ? ', $reviewCount avaliações' : ''}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 20, color: c.star),
          const SizedBox(width: 4),
          Text(value, style: AppTypography.title.copyWith(color: c.textPrimary, height: 1.2)),
          if (reviewCount != null) ...[
            const SizedBox(width: 4),
            Text('($reviewCount)', style: AppTypography.caption.copyWith(color: c.textSecondary)),
          ],
        ],
      ),
    );
  }
}
