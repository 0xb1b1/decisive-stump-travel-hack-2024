import 'package:flutter/material.dart';
import 'package:travel_frontend/src/common/app_typography.dart';
import 'package:travel_frontend/src/common/assets_provider.dart';

import '../../../../../common/app_palette.dart';

class SimilarButton extends StatefulWidget {
  const SimilarButton({super.key});

  @override
  State<SimilarButton> createState() => _SimilarButtonState();
}

class _SimilarButtonState extends State<SimilarButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppPalette.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: AssetsProvider.similar,
          ),
          const SizedBox(
            width: 8,
          ),
          const Text(
            'Похожeе',
            style: AppTypography.hoverDescr,
          ),
        ],
      ),
    );
  }
}
