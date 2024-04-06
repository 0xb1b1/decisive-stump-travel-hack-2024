import 'package:flutter/material.dart';

import '../common/app_palette.dart';
import '../common/app_typography.dart';

class ErrorScene extends StatelessWidget {
  const ErrorScene({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 236,
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          'Произошла ошибка, \nпроверьте ваше интернет-соединение и повторите попытку',
          style: AppTypography.boldText.copyWith(fontSize: 24),
        ),
      ),
    );
  }
}
