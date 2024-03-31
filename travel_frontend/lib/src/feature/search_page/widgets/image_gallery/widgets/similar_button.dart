import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../src/common/app_palette.dart';

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
        color: AppPalette.black.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset('assets/activity.svg'),
          const SizedBox(
            width: 8,
          ),
          const Text('Похожие'),
        ],
      ),
    );
  }
}
