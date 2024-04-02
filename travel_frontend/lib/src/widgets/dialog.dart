import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_palette.dart';

import '../common/app_typography.dart';

class Dialog extends StatelessWidget {
  final String title;
  final String buttonTitle;
  final VoidCallback onTap;

  const Dialog({
    super.key,
    required this.title,
    required this.onTap,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
        horizontal: 56,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppPalette.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Text(
            title,
            style: AppTypography.boldText.copyWith(
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
