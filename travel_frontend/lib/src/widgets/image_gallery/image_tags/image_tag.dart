import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/app_typography.dart';

class ImageTag extends StatelessWidget {
  final String tag;
  final void Function(String) onTagTap;

  const ImageTag({
    super.key,
    required this.tag,
    required this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTagTap(tag),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppPalette.grey,
        ),
        child: Text(
          tag,
          style: AppTypography.tags,
        ),
      ),
    );
  }
}
