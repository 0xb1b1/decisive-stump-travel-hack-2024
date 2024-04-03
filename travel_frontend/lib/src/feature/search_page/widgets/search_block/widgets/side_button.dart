import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_frontend/src/common/app_palette.dart';
import 'package:travel_frontend/src/common/app_typography.dart';


class SideButton extends StatelessWidget {
  final String title;
  final CustomPaint icon;
  final VoidCallback onTap;

  const SideButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppPalette.grey,
        ),
        child: Row(
          children: [
            AutoSizeText(
              title,
              style: AppTypography.boldText,
              maxLines: 2,
            ),
            const SizedBox(width: 8),
            Container(
              alignment: Alignment.center,
              height: 24,
              width: 24,
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
